from .dblp.main import DBLP
from .string-utils-srv import StringUtilsSrv
from .format-converter import FormatConverter
from protocols.http import DefaultOperationHttpRequest
from runtime import Runtime
from console import Console
from file import File
from string-utils import StringUtils
from leonardo import WebFiles
from mustache import Mustache
from reflection import Reflection
// from .acp import ACPSrv
// from .acp import GetCollectionsResponse
from ganalytics import GoogleAnalytics
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
	publications( void )( PublicationDataset )
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
		global.wwwDir = "../web"
		global.templatesDir = "../templates"
		global.dataBindings.("/research.html") = "publications"
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
				get@webFiles( {
					target = request.operation
					wwwDir = global.wwwDir
				} )( getResult )
				httpParams -> getResult.httpParams

				substring@stringUtils( getResult.path { begin = length@stringUtils( global.wwwDir ) } )( webPath )
				if( getResult.httpParams.format == "html" ) {
					if( is_defined( global.dataBindings.(webPath) ) ) {
						invoke@reflection( {
							operation = global.dataBindings.(webPath)
							outputPort = "self"
						} )( data )
					} else {
						data << {}
					}
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
							text = "Teaching"
							link = "/teaching.html"
						}
						item[3] << {
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
							text = "Media"
							link = "/media.html"
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
				filename = "publications.json"
				format = "json"
			} )
		) ]
	}
}
