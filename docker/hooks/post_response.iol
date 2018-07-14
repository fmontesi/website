include "hooks_types.iol"

interface GoogleAnalyticsIface {
RequestResponse: collect
}

outputPort GoogleAnalytics {
Location: "socket://www.google-analytics.com:80/"
Protocol: http { .format = "x-www-form-urlencoded" }
Interfaces: GoogleAnalyticsIface
}

service PostResponseHook {
Interfaces: PostResponseHookIface
main {
	run(mesg)() {
		endsWith@StringUtils( mesg.request.path { .suffix = ".pdf" } )( isPdf );
		if ( isPdf ) {
			contains@StringUtils( mesg.request.path { .substring = "files" } )( isPub );
			contains@StringUtils( mesg.request.path { .substring = "teaching" } )( isTeaching );
			if ( isTeaching ) {
				ec = "Teaching"
			} else if ( isPub ) {
				ec = "Publications"
			} else {
				ec = "Others"
			};
			split@StringUtils( mesg.request.path { .regex = "/" } )( result );
			collect@GoogleAnalytics( {
				.v = 1,
				.tid = "UA-53616744-1",
				.cid = 555,
				.t = "event",
				.ec = ec,
				.ea = "Download",
				.el = result.result[ #result.result - 1 ]
			} )()
		}
	}
}
}
