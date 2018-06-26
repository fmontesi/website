include "console.iol"
include "string_utils.iol"
include "dblp_utils.iol"

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
Location: "socket://dblp.uni-trier.de:80/"
Protocol: http {
	.osc.getPersonPublications.alias = "pers/xk/%{initial}/%{nameKey}.xml";
	.osc.getBibtex.alias = "rec/bib2/%!{$}.bib";
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
		println@Console( "[DBLP:getAuthorBibtex] Requesting publications for " + request.nameKey )();
		getPersonPublications@DBLPServer( request )( response );

		format = "html";
		for( i = k = 0, i < #response.dblpkey, i++ ) {
			if ( !is_defined( response.dblpkey[i].(Attrs) ) ) {
				// It's a publication key
				getBibtex@DBLPServer( response.dblpkey[i] )( bibtex );
				result += bibtex
			}
		};
		println@Console( "[DBLP:getAuthorBibtex] Request served for " + request.nameKey )();
		if( !(result instanceof string) ) {
			undef( result );
			result = "[Error] Something went wrong. Please check your parameters."
		}
	}
}
