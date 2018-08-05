include "../ganalytics/GoogleAnalytics.iol"
include "types/FormatConverterIface.iol"
include "json_utils.iol"
include "xml_utils.iol"

execution { concurrent }

inputPort Input {
Location: "local"
Interfaces: FormatConverterIface
}

main
{
	[ jsonToXml( request )( response ) {
		getJsonValue@JsonUtils( request.json )( root );
		xmlRequest << request.xmlParams;
		xmlRequest.root -> root;
		valueToXml@XmlUtils( xmlRequest )( response )
	} ] {
		collect@GoogleAnalytics( {
			.v = 1,
			.tid = "UA-53616744-1",
			.cid = 555,
			.t = "event",
			.ec = "service",
			.ea = "format_converter",
			.el = "jsonToXml"
		} )()
	}

	[ xmlToJson( request )( response ) {
		xmlToValue@XmlUtils( request )( xml );
		getJsonString@JsonUtils( xml )( response )
	} ] {
		collect@GoogleAnalytics( {
			.v = 1,
			.tid = "UA-53616744-1",
			.cid = 555,
			.t = "event",
			.ec = "service",
			.ea = "format_converter",
			.el = "xmlToJson"
		} )()
	}
}
