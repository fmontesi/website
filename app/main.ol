from .dblp.main import DBLP
from .string_utils.main import StringUtilsSrv
from .format_converter.main import FormatConverter
from .hooks.main import PreResponseHook, PostResponseHook
from runtime import Runtime

service Main {
	embed Runtime as Runtime
	embed DBLP as DBLP
	embed StringUtilsSrv as StringUtilsSrv
	embed FormatConverter as FormatConverter
	embed PreResponseHook as PreResponseHook
	embed PostResponseHook as PostResponseHook

	main {
		loadEmbeddedService@Runtime( {
			filepath = "leonardo/main.ol"
			service = "Leonardo"
			params << {
				location = "socket://localhost:8080"
				wwwDir = "../web"
				defaultPage = "index.html"
				PreResponseHook << PreResponseHook
				PostResponseHook << PostResponseHook
				redirection[0] << {
					name = "dblp"
					binding << DBLP
				}
				redirection[1] << {
					name = "StringUtils"
					binding << StringUtilsSrv
				}
				redirection[2] << {
					name = "FormatConverter"
					binding << FormatConverter
				}
			}
		} )()

		linkIn( Shutdown )
	}
}
