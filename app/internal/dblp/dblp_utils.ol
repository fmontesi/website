include "console.iol"
include "string_utils.iol"
include "dblp_utils.iol"
include "../ganalytics/GoogleAnalytics.iol"

execution { concurrent }

constants {
	Attrs = "@Attributes",
	PublicationType_InProceedings = 1,
	PublicationType_Article = 2
}

type _DBLP_GetPersonPublicationsRequest:void {
	.nameKey:string
	.initial:string
}

interface DBLPServerInterface {
RequestResponse:
	getPersonPublications(_DBLP_GetPersonPublicationsRequest)(undefined),
	getBibtex(string)(string)
}

outputPort DBLPServer {
Location: "socket://dblp.uni-trier.de:443/"
Protocol: https {
	.osc.getPersonPublications.alias = "pers/xk/%{initial}/%{nameKey}.xml";
	.osc.getBibtex.alias = "rec/bib2/%!{$}.bib";
	.addHeader.header[0] << "Accept-Charset" { .value = "utf-8, iso-8859-1;q=0.5" };
	.debug = .debug.showContent = true;
	.format -> format;
	.method -> method;
	.keepAlive = false // DBLP does not like reusing connections
}
Interfaces: DBLPServerInterface
}

inputPort DBLPInput {
Location: "local"
Interfaces: DBLPUtilsInterface
}

init
{
	format = "xml";
	method = "get"
}

main
{
	getAuthorBibtex( request )( result ) {
		getPersonPublications@DBLPServer( request )( response );

		format = "html";
		for( dblpkey in response.dblpkey ) {
			if ( !is_defined( dblpkey.(Attrs) ) ) {
				// It's a publication key
				getBibtex@DBLPServer( dblpkey )( bibtex );
				result += bibtex
			}
		};
		if( !(result instanceof string) ) {
			undef( result );
			result = "[Error] Something went wrong. Please check your parameters."
		}
	};
	collect@GoogleAnalytics( {
		.v = 1,
		.tid = "UA-53616744-1",
		.cid = 555,
		.t = "event",
		.ec = "service",
		.ea = "dblp",
		.el = "getAuthorBibtex(" + request.nameKey + ")"
	} )()
}
