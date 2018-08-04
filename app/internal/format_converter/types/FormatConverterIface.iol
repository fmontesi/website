type JsonToXmlRequest:void {
	.json:string
	.xmlParams?:void {
		.indent?:bool
		.rootNodeName?:string
		.isXmlStore?:bool
	}
}

interface FormatConverterIface {
RequestResponse:
	jsonToXml(JsonToXmlRequest)(string)
}
