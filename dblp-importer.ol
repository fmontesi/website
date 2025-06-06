#!/usr/bin/env -S jolie -s Main --responseTimeout 10000

from console import Console
from file import File
from vectors import Vectors
from string-utils import StringUtils
from .private.quicksort import Quicksort
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
			id: long
			key: string
			path: string
			title: string
			year: string
			doi?:string
			abstract?:string
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
			notes* {
				text: string
			}
			fullView?: string
		}
	}
}

interface DblpServerInterface {
RequestResponse:
	getPersonPublications,
	getBibtex
}

interface UtilsInterface {
RequestResponse: entry, where, authors, authorLink, links, bibtex, title, abstract, arxivAbstract
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

	outputPort crossRef {
		location: "socket://api.crossref.org:443/"
		protocol: https {
			osc.getWork << {
				alias = "works/%!{doi}"
				method = "get"
			}
		}
		RequestResponse: getWork
	}

	outputPort arxiv {
		location: "socket://export.arxiv.org:80/"
		protocol: http {
			osc.query << {
				alias = "api/query"
				method = "get"
			}
		}
		RequestResponse: query
	}

	embed Runtime as runtime
	embed StringUtils as su
	embed File as files
	embed Console as console
	embed StringUtils as stringUtils

	init {
		readFile@files( {
			filename = "data/publications-extension.json"
			format = "json"
		} )( publicationsExtension )

		// Store all (for now) unused keys
		foreach( key : publicationsExtension ) {
			extraKeys.(key) = false
		}

		getLocalLocation@runtime()( self.location )
	}

	main {
		[ entry( r )( entry ) {
			// entry.key = r.(Attributes).key
			entry.key = r.key
			entry.year = r.year
			entry.type = r.type
			title@self( r.title )( entry.title )
			where@self( r )( where )
			entry.where =
				if( where instanceof string )
			 		where
				else
					"ERROR"

			if( is_defined( r.authors ) ) {
				vec.authors << r.authors
			} else {
				authors@self(
					if( entry.type == "proceedings" )
						{ authors -> r.editor }
					else
						{ authors -> r.author }
				)( vec )
			}
			if( #vec.authors > 0 ) {
				entry.authors << vec.authors
			}

			entry.bibtex =
				if( is_defined( r.bibtex ) )
					r.bibtex
				else
					bibtex@self( r )

			if( is_defined( publicationsExtension.(entry.key) ) ) {
				extraData << publicationsExtension.(entry.key)

				if( is_defined( extraData.pdf ) )
					entry.pdf = extraData.pdf

				if( is_defined( extraData.peerReviewedVersion ) )
					entry.peerReviewedVersion = extraData.peerReviewedVersion
				
				if( is_defined( extraData.notes ) )
					entry.notes << extraData.notes
				
				if( is_defined( extraData.path ) )
					entry.path = extraData.path

				if( is_defined( extraData.abstract ) )
					entry.abstract = extraData.abstract
				
				if( is_defined( extraData.fullView ) )
					entry.fullView = extraData.fullView
				
				if( is_defined( extraData.links ) )
					entry.links << extraData.links
				
				if( is_defined( extraData.notes ) )
					entry.notes << extraData.notes
			}

			if( !is_defined( entry.links ) ) {
				links@self( r )( vec )
				if( #vec.links > 0 ) {
					entry.links << vec.links
					for( link in entry.links ) {
						if( link.name == "doi.org" ) {
							replaceAll@stringUtils( link.href { regex = "https://doi.org/", replacement = "" } )( entry.doi )
						}
					}
				}
			}
		} ]

		[ title( rawTitle )(
			if( endsWith@su( rawTitle { suffix = "." } ) )
				substring@su( rawTitle {
					begin = 0
					end = length@su( rawTitle ) - 1
				} )
			else
				rawTitle
		) ]

		[ where( r )( where ) {
			where = 
				if( is_defined( r.where ) )
					r.where
				else if( r.type == "inproceedings" )
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
				authorLink@self( author )( link )
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

		[ abstract( entry )( abstract ) {
			if( is_defined( entry.abstract ) ) {
				abstract = entry.abstract
			} else {
				println@console( "Missing abstract for " + entry.key + "." )()
				if( startsWith@stringUtils( entry.key { prefix = "journals/corr/abs-" } ) ) {
					replaceAll@stringUtils( entry.key { regex = "journals/corr/abs-", replacement = "" } )( arxivId )
					replaceAll@stringUtils( arxivId { regex = "-", replacement = "." } )( arxivId )
					print@console( "\t Entry is from arXiv (id " + arxivId + "). Trying arXiv... " )()
					arxivAbstract@self( arxivId )( abstract )
				} else if( startsWith@stringUtils( entry.key { prefix = "journals/corr/" } ) ) {
					print@console( "\t Entry is from arXiv, looking for id... " )()
					arxivId = {}
					for( link in entry.links ) {
						if( link.name == "arxiv.org" && startsWith@stringUtils( link.href { prefix = "http://arxiv.org/abs/" } ) ) {
							replaceAll@stringUtils( link.href { regex = "http://arxiv.org/abs/", replacement = "" } )( arxivId )
						}
					}
					if( arxivId instanceof string ) {
						print@console( "found id " + arxivId + ". Trying arXiv... " )()
						arxivAbstract@self( arxivId )( abstract )
					}
				} else if( is_defined( entry.doi ) ) {
					print@console( "\tEntry has doi (" + entry.doi + "). Trying Crossref... " )()
					scope( crossRefFetch ) {
						install( default => println@console( "❌ (not found or error in contacting Crossref)" )() )
						getWork@crossRef( { doi = entry.doi } )( crossRefData )
						if( is_defined( crossRefData.message.abstract ) ) {
							replaceAll@stringUtils( crossRefData.message.abstract { regex = "<jats:title>.*</jats:title>", replacement = "" } )( abstract )
							println@console( "✅" )()
						} else {
							println@console( "❌ (no abstract in Crossref entry)" )()
						}
					}
				}
			}

			if( abstract instanceof string ) {
				trim@stringUtils( abstract )( abstract )
			}
		} ]

		[ arxivAbstract( arxivId )( abstract ) {
			scope( fetch ) {
				install( default => println@console( "❌ (not found or error in contacting arXiv)" )() )
				query@arxiv( { id_list = arxivId } )( arxivRecord )
				if( arxivRecord.entry.title == "Error" ) {
					println@console( "❌ (error returned from arXiv)" )()
				} else if( is_defined( arxivRecord.entry.summary ) ) {
					abstract = arxivRecord.entry.summary
					println@console( "✅" )()
				} else {
					println@console( "❌ (arXiv entry has no abstract)" )()
				}
			}
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
	embed Vectors as vectors

	init {
		readFile@files( {
			filename = "data/publications-extension.json"
			format = "json"
		} )( publicationsExtension )
	}

	main {
		if( args[0] == "no-dblp" ) {
			readFile@files( {
				filename = "data/publications.json"
				format = "json"
			} )( data )
			collections << data.collections
		} else {
			readFile@files( {
				filename = "data/publications-manual.json"
				format = "json"
			} )( manual )
			for( collection in manual.collections ) {
				for( r in collection.entries ) {
					cMap.(collection.title).papers[#cMap.(collection.title).papers] << r
				}
				sortedCollectionNames.items[#sortedCollectionNames.items] = collection.title
			}
			undef( collection )

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
					r.(key).key = r.(key).(Attributes).key
					cMap.(year).papers[#cMap.(year).papers] << r.(key)
					dblpYears.(year) = true
				}
			}
			foreach( yearKey : dblpYears ) {
				request.items[#request.items] = int(yearKey)
			}
			sort@quicksort( request )( sortedDblpYears )
			concat@vectors( {
				fst << sortedCollectionNames
				snd << sortedDblpYears
			} )( sortedCollectionNames )

			for( year in sortedCollectionNames.items ) {
				println@console( "Processing collection " + year )()
				collection.title = string(year)
				for( r in cMap.(year).papers ) {
					entry@utils( r )( collection.entries[#collection.entries] )
				}
				collections[#collections] << collection
				undef( collection )
			}

			id = 0
			for( collection in collections ) {
				for( entry in collection.entries ) {
					entry.id = id++
					abstract@utils( entry )( abstract )
					if( abstract instanceof string ) {
						entry.abstract = abstract
						publicationsExtension.(entry.key).abstract = abstract
					}
				}
			}
		}

		undef( pathMap )
		for( collection in collections ) {
			for( entry in collection.entries ) {
				if( !is_defined( entry.path ) ) {
					path = entry.title
					toLowerCase@stringUtils( path )( path )
					replaceAll@stringUtils( path { regex = " - .*" replacement = "" } )( path )
					replaceAll@stringUtils( path { regex = ": .*" replacement = "" } )( path )
					replaceAll@stringUtils( path { regex = "[^[^\\p{P}]-]+" replacement = "" } )( path ) // remove all punctuation but -
					replaceAll@stringUtils( path { regex = "π" replacement = "pi" } )( path )
					replaceAll@stringUtils( path { regex = "\\p{javaWhitespace}+", replacement = "-" } )( path )
					if( startsWith@stringUtils( entry.key { prefix = "journals/corr/" } ) ) {
						path += "-arxiv"
					}
					entry.path = path
				} else {
					path = entry.path
				}
				if( !is_defined( pathMap.(path) )
					|| (
						pathMap.(path).collection.title == "Highlights"
						&& pathMap.(path).key == entry.key
					) ) {
					undef( pathMap.(path) )
					pathMap.(path) << entry
					pathMap.(path).collection.title = collection.title
					println@console( "Imported " + entry.key + " as " + path )()
				} else {
					throw DuplicatePublicationPath( { path = path, key = entry.key } )
				}
				undef( path )
			}
		}

		writeFile@files( { filename = "data/publications.json", format << "json", content << { collections -> collections } } )()
		writeFile@files( { filename = "data/publications-by-path.json", format << "json", content << pathMap } )()
		writeFile@files( { filename = "data/publications-extension.json", format << "json", content << publicationsExtension } )()
	}
}
