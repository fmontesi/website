#!/usr/bin/env -S jolie -s Main

from console import Console
from file import File
from string-utils import StringUtils
from quicksort import Quicksort
from runtime import Runtime

constants {
	PersonId = "65/3603",
	Attributes = "@Attributes",
	DoiUrlPrefix = "https://doi.org/",
	ArxivUrlPrefix = "http://arxiv.org/"
}

type PublicationDataset {
	collections* {
		title: string
		entries* {
			id: int
			key: string
			title: string
			year: string
			authors* {
				name: string
				link?: string
				last: bool
			}
			type: string
			where: string
			links* {
				name: string
				href: string
				last: bool
			}
			bibtex: string
			pdf?: string
			peerReviewedVersion?: string
		}
	}
}

interface DblpServerInterface {
RequestResponse:
	getPersonPublications,
	getBibtex
}

interface UtilsInterface {
RequestResponse: entry, where, authors, authorLink, links, bibtex, title
}

service Utils {
	execution: concurrent

	inputPort Input {
		location: "local"
		interfaces: UtilsInterface
	}

	outputPort self {
		interfaces: UtilsInterface
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

	embed Runtime as runtime
	embed StringUtils as su
	embed File as files
	embed Console as console

	init {
		readFile@files( {
			filename = "publications-extension.json"
			format = "json"
		} )( publicationsExtension )
		getLocalLocation@runtime()( self.location )
	}

	main {
		[ entry( request )( entry ) {
			r -> request.r
			entry.id = request.id
			entry.key = r.(Attributes).key
			entry.year = r.year
			entry.type = r.type
			title@self( r.title )( entry.title )
			where@self( r )( where )
			if( where instanceof string ) {
				entry.where = where
			} else {
				entry.where = "ERROR"
			}
			authors@self(
				if( entry.type == "proceedings" )
					{ authors -> r.editor }
				else
					{ authors -> r.author }
			)( vec )
			if( #vec.authors > 0 ) {
				entry.authors << vec.authors
			}
			links@self( r )( vec )
			if( #vec.links > 0 ) {
				entry.links << vec.links
			}
			bibtex@self( r )( entry.bibtex )

			if( is_defined( publicationsExtension.(entry.key) ) ) {
				extraData << publicationsExtension.(entry.key)
				entry.pdf = extraData.pdf
				if( is_defined( extraData.peerReviewedVersion ) )
					entry.peerReviewedVersion = extraData.peerReviewedVersion
			}
		} ]

		[ title( rawTitle )( title ) {
			title =
				if( endsWith@su( rawTitle { suffix = "." } ) )
					substring@su( rawTitle { })
		} ]

		[ where( r )( where ) {
			where = 
				if( r.type == "inproceedings" )
					"In proceedings of " + r.booktitle + " " + r.year + ", pp. " + r.pages
				else if( r.type == "article" )
					"In " + r.journal + " " + r.volume
				else if( r.type == "proceedings" )
					r.publisher + ", " + r.series + ", Vol. " + r.volume
				else if( r.type == "incollection" )
					"Book chapter in " + r.booktitle + ", pp. " + r.pages
				else
					r.publisher
		} ]

		[ authors( vec )( result ) {
			i = 0
			for( author in vec.authors ) {
				a.name = author
				a.last = (++i == #vec.authors)
				authorLink@self( vec.authors )( link )
				if( link instanceof string ) {
					a.link = link
				}
				result.authors[#result.authors] << a
			}
		} ]

		[ authorLink( author )( link ) {
			link =
				if( is_defined( author.(Attributes).pid ) )
					"https://dblp.uni-trier.de/pid/" + author.(Attributes).pid
				else
					{}
		} ]

		[ links( r )( result ) {
			i = 0
			for( ee in r.ee ) {
				match@su( ee {
					regex = "(?:http|https)://(?:www\\.)?([^/]+).*"
				} )( result )
				result.links[#result.links] << {
					href = ee
					last = (++i == #r.ee)
					name =
						if( result )
							result.group[1]
						else "link (other)"
				}
				// if( ee.(Attributes).type == "oa" ) {
				// 	entry.oaLink = ee
				// }
			}
		} ]

		[ bibtex( r )( bibtex ) {
			getBibtex@dblp( r.(Attributes).key )( bibtex )
		} ]
	}
}

service Main {
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

	embed Utils as utils

	embed Console as console
	embed StringUtils as stringUtils
	embed Quicksort as quicksort
	embed File as files

	// init {
	// 	refreshCollections
	// }

	main {
		getPersonPublications@dblp( { pid = PersonId } )( dblpPerson )
		for( r in dblpPerson.r ) {
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
		id = 0
		for( year in sortedYears.items ) {
			collection.title = string(year)
			for( r in cMap.(year).papers ) {
				entry@utils( { r << r, id = id++ } )( collection.entries[#collection.entries] )
			}
			collections[#collections] << collection
			undef( collection )
		}

		writeFile@files( { filename = "publications.json", format = "json", content << { collections -> collections } } )()
	}
}