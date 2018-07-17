include "hooks_types.iol"

constants {
	PublicationsListToken = "<!--PublicationsList-->"
}

outputPort CLSrv {
RequestResponse: getPublicationsList(void)(string)
}

embedded {
Jolie: "hooks/clsrv.ol" in CLSrv
}

service PreResponseHook {
Interfaces: PreResponseHookIface
main {
	run(mesg)(mesg.content) {
		if ( mesg.content instanceof string ) {
			startsWith@StringUtils( mesg.content { .prefix = "<!--Themed-->" } )( isThemed );
			if ( isThemed ) {
				readFile@File( {
					.format = "text",
					.filename = mesg.config.wwwDir + "header.html"
				} )( header );
				readFile@File( {
					.format = "text",
					.filename = mesg.config.wwwDir + "footer.html"
				} )( footer );
				mesg.content = header + mesg.content + footer
			};

			contains@StringUtils( mesg.content { .substring = PublicationsListToken } )( requiresPubs );
			if ( requiresPubs ) {
				getPublicationsList@CLSrv()( pubList );
				replaceAll@StringUtils(
					mesg.content { .regex = PublicationsListToken, .replacement = pubList }
				)( mesg.content )
			}
		}
	}
}
}
