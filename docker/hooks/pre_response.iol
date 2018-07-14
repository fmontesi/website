include "hooks_types.iol"

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
			}
		}
	}
}
}
