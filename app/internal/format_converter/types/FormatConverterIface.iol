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
