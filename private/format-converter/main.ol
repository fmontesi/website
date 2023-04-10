from ..ganalytics.main import GoogleAnalytics
from json_utils import JsonUtils
from xml_utils import XmlUtils

type JsonToXmlRequest:void {
	.json:string
	.xmlParams?:void {
		.indent?:bool
		.rootNodeName?:string
		.isXmlStore?:bool
	}
}

type XmlToJsonRequest:string {
	.isXmlStore?:bool
	.options?:void {
		.includeAttributes?:bool
		.includeRoot?:bool
		.charset?:string
		.skipMixedText?:bool
	}
}

interface FormatConverterIface {
RequestResponse:
	jsonToXml(JsonToXmlRequest)(string),
	xmlToJson(XmlToJsonRequest)(string)
}

service FormatConverter {
	execution: concurrent

	inputPort Input {
		location: "local"
		interfaces: FormatConverterIface
	}

	embed JsonUtils as JsonUtils
	embed XmlUtils as XmlUtils
	embed GoogleAnalytics as GoogleAnalytics

	main {
		[ jsonToXml( request )( response ) {
			getJsonValue@JsonUtils( request.json )( root )
			xmlRequest << request.xmlParams
			xmlRequest.root -> root
			valueToXml@XmlUtils( xmlRequest )( response )
		} ] {
			collect@GoogleAnalytics( {
				v = 1
				tid = "UA-53616744-1"
				cid = 555
				t = "event"
				ec = "service"
				ea = "format_converter"
				el = "jsonToXml"
			} )()
		}

		[ xmlToJson( request )( response ) {
			xmlToValue@XmlUtils( request )( xml )
			getJsonString@JsonUtils( xml )( response )
		} ] {
			collect@GoogleAnalytics( {
				v = 1
				tid = "UA-53616744-1"
				cid = 555
				t = "event"
				ec = "service"
				ea = "format_converter"
				el = "xmlToJson"
			} )()
		}
	}
}
