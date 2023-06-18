from .private.dblp import DBLP
from .private.string-utils-srv import StringUtilsSrv
from .private.format-converter import FormatConverter
from .bliki import BlikiUtils
from protocols.http import DefaultOperationHttpRequest
from runtime import Runtime
from console import Console
from file import File
from string-utils import StringUtils
from @jolie.leonardo import WebFiles
from @jolie.commonmark import CommonMark
from mustache import Mustache
from reflection import Reflection
// from .acp import ACPSrv
// from .acp import GetCollectionsResponse
from .private.ganalytics import GoogleAnalytics
// from .dblp-utils import DblpUtils
from .dblp-importer import PublicationDataset

type HelloRequest {
	name:string
}

interface WebInterface {
RequestResponse:
	get( DefaultOperationHttpRequest )( undefined ),
	hello( HelloRequest )( string )
}

interface MustacheOperations {
RequestResponse:
	publications( void )( PublicationDataset ),
	dissemination,
	blikiIndex,
	blikiFeed
}

service Main {
	execution: concurrent

	embed Runtime as runtime
	embed DBLP as dblp
	embed StringUtilsSrv as stringUtilsSrv
	embed FormatConverter as formatConverter
	embed WebFiles as webFiles
	embed Console as console
	embed Mustache as mustache
	embed File as file
	embed StringUtils as stringUtils
	embed Reflection as reflection
	embed CommonMark as commonMark
	embed BlikiUtils as blikiUtils
	// embed ACPSrv as acp
	embed GoogleAnalytics as ga
	// embed DblpUtils as dblpUtils

	inputPort WebInput {
		location: "socket://localhost:8080"
		protocol: http {
			format -> httpParams.format
			contentType -> httpParams.contentType
			cacheControl.maxAge -> httpParams.cacheControl.maxAge
			redirect -> redirect
			statusCode -> statusCode
			default.get = "get"

			osc.hello << {
				template = "/hello?name={name}"
				method = "get"
			}
		}
		interfaces: WebInterface
		redirects:
			dblp => dblp,
			FormatConverter => formatConverter,
			StringUtils => stringUtilsSrv
	}

	inputPort Local {
		location: "local"
		interfaces: MustacheOperations
	}

	outputPort self {
		interfaces: MustacheOperations
	}

	init {
		global.wwwDir = "web"
		global.templatesDir = "templates"
		global.dataBindings.("/research.html") = "publications"
		global.dataBindings.("/dissemination.html") = "dissemination"
		global.dataBindings.("/bliki/index.html") = "blikiIndex"
		global.dataBindings.("/bliki/feed.xml") = "blikiFeed"
		format = "html"

		getLocalLocation@runtime()( self.location )

		println@console( "Server started at " + global.inputPorts.WebInput.location )()
	}

	main {
		[ get( request )( response ) {
			scope( get ) {
				install(
					FileNotFound =>
						// println@console( "File not found: " + get.FileNotFound )()
						statusCode = 404,
					MovedPermanently =>
						redirect = get.MovedPermanently
						statusCode = 301
				)

				// It's a bliki page request. Sets blikiPage: string | void
				match@stringUtils( request.operation { regex = ".*bliki/([^/\\.]+)" } )( blikiMatch )
				if( blikiMatch ) {
					request.operation += ".md"
					blikiPage = blikiMatch.group[1]
				} else {
					blikiPage = {}
				}
				undef( blikiMatch )

				scope( markdown ) {
					// println@console( request.operation )()
					// install( FileNotFound =>
					// 	// if( endsWith@stringUtils( request.operation { suffix = ".html" } ) ) {
					// 	// 	println@console( "Could try md" )()
					// 	// } else
					// 	if ( endsWith@stringUtils( request.operation { suffix = "/" } ) ) {
							
					// 	} else {
					// 		throw FileNotFound( markdown.FileNotFound )
					// 	}
					// )
					get@webFiles( {
						target = request.operation
						wwwDir = global.wwwDir
					} )( getResult )
				}
				httpParams -> getResult.httpParams

				if( endsWith@stringUtils( getResult.path { suffix = ".md" } ) ) {
					getResult.httpParams.format = "html"
					getResult.httpParams.contentType = "text/html"
					// getResult.content = string( getResult.content )
					getResult.content = render@commonMark( string( getResult.content ) )
				}

				substring@stringUtils( getResult.path { begin = length@stringUtils( global.wwwDir ) } )( webPath )
				if( getResult.httpParams.format == "html" || getResult.httpParams.format == "xml" ) {
					if( is_defined( global.dataBindings.(webPath) ) ) {
						invoke@reflection( {
							operation = global.dataBindings.(webPath)
							outputPort = "self"
						} )( data )
					} else {
						data << {}
					}

					if( blikiPage instanceof string ) {
						data << entryData@blikiUtils( blikiPage )
						split@stringUtils( data.published { regex = "T" } )( s )
						data.published = s.result[0]
						split@stringUtils( data.updated { regex = "T" } )( s )
						data.updated = s.result[0]
						undef( s )
					}

					data.webPath = webPath
					data.menu.cols[0] << {
						item[0] << {
							text = "Home"
							link = "/index.html"
						}
						item[1] << {
							text = "Research"
							link = "/research.html"
						}
						item[2] << {
							text = "Dissemination"
							link = "/dissemination.html"
						}
						item[3] << {
							text = "Education"
							link = "/education.html"
						}
						item[4] << {
							text = "People"
							link = "/people.html"
						}
					}
					data.menu.cols[1] << {
						item[0] << {
							text = "Book"
							link = "/introduction-to-choreographies/"
						}
						item[1] << {
							text = "Bliki"
							link = "/bliki/"
						}
						item[2] << {
							text = "Projects"
							link = "/projects/"
						}
						item[3] << {
							text = "Tools"
							link = "/tools.html"
						}
						item[4] << {
							text = "Blog"
							link = "https://fmontesi.github.io"
						}
					}
					render@mustache( {
						template -> getResult.content
						data -> data
						dir = global.templatesDir
					} )( response )

					// if( endsWith@stringUtils( getResult.path { suffix = ".md" } ) ) {
					// 	render@commonMark( response )( response )
					// }
				} else {
					response -> getResult.content
				}
			}
		} ]
		/* {
			endsWith@stringUtils( webPath { suffix = ".pdf" } )( isPdf )
			if( isPdf ) {
				contains@stringUtils( webPath { substring = "files" } )( isPub )
				contains@stringUtils( webPath { substring = "teaching" } )( isTeaching )
				if( isTeaching ) {
					en = "download_teaching"
				} else if( isPub ) {
					en = "download_publications"
				} else {
					en = "download_others"
				}
				split@stringUtils( webPath { regex = "/" } )( result )
				collect@ga( {
					v = 2
					tid = "G-4PF4QHJMB8"
					// cid = 555
					// ec = ec
					en = en
					dt = result.result[ #result.result - 1 ]
					// dl = "https://www.fabriziomontesi.com/research.html"
					// dr = "https://www.fabriziomontesi.com/"
				} )()
			}
		}
		*/

		[ publications()(
			readFile@file( {
				filename = "data/publications.json"
				format = "json"
			} )
		) ]

		[ dissemination()(
			readFile@file( {
				filename = "data/dissemination.json"
				format = "json"
			} )
		) ]

		[ blikiIndex()( response ) {
			entries@blikiUtils()( entriesResp )
			i = 0
			for( entry in entriesResp.entries ) {
				response.entries[i++] << {
					text = entry.id
					link = entry.id
				}
			}
		} ]

		[ blikiFeed()( response ) {
			entries@blikiUtils()( entriesResp )
			i = 0
			for( entry in entriesResp.entries ) {
				response.entries[ i++ ] << {
					id = entry.id
					title = entry.id
					published = entry.published
					updated = entry.updated
				}
			}
			lastUpdated@blikiUtils()( response.updated )
		} ]
	}
}
