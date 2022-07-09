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
from .acp import ACPSrv
from .acp import GetCollectionsResponse
from ganalytics import GoogleAnalytics
from .dblp-utils import DblpUtils

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
	publications( void )( GetCollectionsResponse )
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
	embed ACPSrv as acp
	embed GoogleAnalytics as ga
	// embed DblpUtils as dblpUtils

	inputPort WebInput {
		location: "socket://localhost:8080"
		protocol: http {
			format -> format
			contentType -> contentType
			cacheControl.maxAge -> cacheControl.maxAge
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
				format = getResult.format
				contentType = getResult.mimeType
				if( is_defined( getResult.cacheControl ) ) {
					cacheControl.maxAge = getResult.cacheControl.maxAge
				}

				substring@stringUtils( getResult.path { begin = length@stringUtils( global.wwwDir ) } )( webPath )
				if( getResult.format == "html" ) {
					if( is_defined( global.dataBindings.(webPath) ) ) {
						invoke@reflection( {
							operation = global.dataBindings.(webPath)
							outputPort = "self"
						} )( data )
					} else {
						data << {}
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
		} ] {
			endsWith@stringUtils( webPath { suffix = ".pdf" } )( isPdf )
			if( isPdf ) {
				contains@stringUtils( webPath { substring = "files" } )( isPub )
				contains@stringUtils( webPath { substring = "teaching" } )( isTeaching )
				if( isTeaching ) {
					ec = "Teaching"
				} else if( isPub ) {
					ec = "Publications"
				} else {
					ec = "Others"
				}
				split@stringUtils( webPath { regex = "/" } )( result )
				collect@ga( {
					v = 1
					tid = "UA-53616744-1"
					cid = 555
					t = "event"
					ec = ec
					ea = "Download"
					el = result.result[ #result.result - 1 ]
				} )()
			}
		}

		[ hello( request )( response ) {
			template = "
				{{< fm-page.html}}
				{{$content}}
				<div class=\"container\">
				Hello {{name}}. Your name's length is {{length}}.
				</div>
				{{/content}}
				{{/fm-page.html}}
			"
			render@mustache( {
				template -> template
				data << {
					name = request.name
					length = length@stringUtils( request.name )
				}
				dir = global.templatesDir
			} )( response )
		} ]

		[ publications()( response ) {
			getCollections@acp()( response )
		} ]
	}
}
