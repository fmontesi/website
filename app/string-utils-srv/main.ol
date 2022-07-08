from string-utils import StringUtils, MatchRequest, MatchResult
from ganalytics.main import GoogleAnalytics

interface StringUtilsRestrictedIface {
RequestResponse:
	match( MatchRequest )( MatchResult )
}

service StringUtilsSrv {
	execution: concurrent

	embed GoogleAnalytics as GoogleAnalytics
	embed StringUtils as StringUtils

	inputPort Input {
		location: "local"
		interfaces: StringUtilsRestrictedIface
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
}
