include "string_utils.iol"
include "../ganalytics/GoogleAnalytics.iol"

execution { concurrent }

interface StringUtilsRestrictedIface {
RequestResponse:
	match(MatchRequest)(MatchResult)
}

inputPort Input {
Location: "local"
Interfaces: StringUtilsRestrictedIface
}

main
{
	[ match( request )( response ) {
		match@StringUtils( request )( response )
	} ] {
		collect@GoogleAnalytics( {
			.v = 1,
			.tid = "UA-53616744-1",
			.cid = 555,
			.t = "event",
			.ec = "service",
			.ea = "string_utils",
			.el = "match"
		} )()
	}
}
