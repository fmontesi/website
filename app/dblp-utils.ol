// Work in progress

from console import Console
from time import Time
from string-utils import StringUtils
from quicksort import Quicksort

constants {
	PersonId = "65/3603",
	Attributes = "@Attributes",
	DoiUrlPrefix = "https://doi.org/",
	ArxivUrlPrefix = "http://arxiv.org/",
	RefreshTimeout = 60000 // 1 min
}

type GetCollectionsResponse {
	collections* {
		title:string
		entries* {
			key:string
		}
	}
}

interface DblpUtilsInterface {
OneWay:
	timeout
RequestResponse:
	getCollections( void )( GetCollectionsResponse )
}

interface DblpServerInterface {
RequestResponse:
	getPersonPublications,
	getBibtex
}

service DblpUtils {
	execution: concurrent

	inputPort Input {
		location: "local"
		interfaces: DblpUtilsInterface
	}

	outputPort dblp {
		location: "socket://dblp.uni-trier.de:443/"
		protocol: https {
			osc.getPersonPublications.alias = "pid/%!{pid}.xml"
			osc.getBibtex.alias = "rec/%!{$}.bib"
			format -> format
			method -> method
		}
		interfaces: DblpServerInterface
	}

	embed Time as time
	embed Console as console
	embed StringUtils as stringUtils
	embed Quicksort as quicksort

	init {
		refreshCollections
	}

	define refreshCollections {
		scope( dataFetch ) {
			install( default => setNextTimeout@time( RefreshTimeout ) )
			getPersonPublications@dblp( { pid = PersonId } )( dblpPerson )
			for( r in dblpPerson.r ) {
				// paperType =
				// 	if( is_defined( r.inproceedings ) )
				// 		"inproceedings"
				// 	else if( is_defined( r.proceedings ) )
				// 		"proceedings"
				// 	else if( is_defined( r.article ) )
				// 		"article"
				// 	else {}
				// if( paperType instanceof string ) {
				// 	p -> r.(paperType)
				// 	cMap.(p.year).papers[#cMap.(p.year).papers] << p
				// }
				undef( key )
				foreach( k : r ) {
					if( is_defined( r.(k).year ) ) {
						key = k
					}
				}
				if( is_defined( key ) ) {
					year = r.(key).year
					r.(key).type = key
					cMap.(year).papers[#cMap.(year).papers] << r.(key)
				}
			}
			foreach( yearKey : cMap ) {
				request.items[#request.items] = int(yearKey)
			}
			sort@quicksort( request )( sortedYears )
 			for( year in sortedYears.items ) {
				collection.title = string(year)
				for( r in cMap.(year).papers ) {
					entry.key = r.(Attributes).key
					entry.title = r.title
					entry.year = r.year
					entry.type = r.type
					if( r.type == "inproceedings" ) {
						entry.where = "In proceedings of " + r.booktitle + " " + r.year + ", pp. " + r.pages
						for( author in r.author )
							entry.authors[#entry.authors] = author
					} else if( r.type == "article" ) {
						entry.where = "In " + r.journal + " " + r.volume
						for( author in r.author )
							entry.authors[#entry.authors] = author
					} else if( r.type == "proceedings" ) {
						entry.where = r.publisher + ", " + r.series + ", Vol. " + r.volume
						for( author in r.editor )
							entry.authors[#entry.authors] = author
					}

					// for( ee in r.ee ) {
					// 	if( startsWith@stringUtils( ee { prefix = DoiUrlPrefix } ) ) {
					// 		entry.links[#entry.links] << {
					// 			type = "doi"
					// 			href = ee
					// 			oa = ee.(Attributes).type == "oa"
					// 		}
					// 	}
					// 	if( ee.(Attributes).type == "oa" ) {
					// 		entry.oaLink = ee
					// 	}
					// }
					
					// entry.where = "In "
					// if( is_defined( r.pages ) )
					// 	entry.pages = r.pages
					
					// entry.volume = r.volume
					// entry.pages = r.pages
					// entry.year = r.year
					valueToPrettyString@stringUtils( entry )( s )
					println@console( s )()
					collection.entries[#collection.entries] << entry
					undef( entry )
				}
				collections[#collections] << collection
			}
			
			valueToPrettyString@stringUtils( collections )( s )
			println@console( s )()
			synchronized( Refresh ) {
				global.collections << collections
			}
			undef( cMap )
			undef( collections )
			setNextTimeout@time( RefreshTimeout )
		}
	}

	main {
		[ timeout() ] {
			refreshCollections
		}

		[ getCollections()( ) {
			synchronized( Refresh ) {
				response.collections << global.collections
			}
		} ]
	}
}