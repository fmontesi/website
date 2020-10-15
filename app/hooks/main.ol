from file import File
from string_utils import StringUtils
from ..leonardo.hooks import PreResponseHookIface, PostResponseHookIface
from ..ganalytics.main import GoogleAnalytics
from .clsrv import CLSrv

constants {
	PublicationsListToken = "<!--PublicationsList-->"
}

service PreResponseHook {
	execution: concurrent

	embed CLSrv as CLSrv
	embed File as File
	embed StringUtils as StringUtils

	inputPort Input {
		location: "local"
		interfaces: PreResponseHookIface
	}

	main {
		run( mesg )( mesg.content ) {
			if( mesg.content instanceof string ) {
				startsWith@StringUtils( mesg.content { prefix = "<!--Themed-->" } )( isThemed )
				if( isThemed ) {
					readFile@File( {
						format = "text"
						filename = mesg.config.wwwDir + "header.html"
					} )( header )
					readFile@File( {
						format = "text",
						filename = mesg.config.wwwDir + "footer.html"
					} )( footer )
					mesg.content = header + mesg.content + footer
				}

				contains@StringUtils( mesg.content { substring = PublicationsListToken } )( requiresPubs )
				if( requiresPubs ) {
					getPublicationsList@CLSrv()( pubList )
					replaceAll@StringUtils(
						mesg.content { regex = PublicationsListToken replacement = pubList }
					)( mesg.content )
				}
			}
		}
	}
}

service PostResponseHook {
	execution: concurrent
	
	embed StringUtils as StringUtils
	embed GoogleAnalytics as GoogleAnalytics
	
	inputPort Input {
		location: "local"
		interfaces: PostResponseHookIface
	}

	main {
		run( mesg )() {
			endsWith@StringUtils( mesg.request.path { suffix = ".pdf" } )( isPdf )
			if( isPdf ) {
				contains@StringUtils( mesg.request.path { substring = "files" } )( isPub )
				contains@StringUtils( mesg.request.path { substring = "teaching" } )( isTeaching )
				if( isTeaching ) {
					ec = "Teaching"
				} else if( isPub ) {
					ec = "Publications"
				} else {
					ec = "Others"
				}
				split@StringUtils( mesg.request.path { regex = "/" } )( result )
				collect@GoogleAnalytics( {
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
	}
}
