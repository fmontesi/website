include "console.iol"
include "string_utils.iol"
include "file.iol"

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

main
{
	if ( #args != 3 ) {
		println@Console( "[ERROR] Must specify three arguments: <initial> <name key> <output filename>" )();
		throw( InvalidArgs )
	};

	format = "xml";
	method = "get";
	
	request.initial = args[0];
	request.nameKey = args[1];

	println@Console( "Requesting list of publications for " + request.nameKey )();
	getPersonPublications@DBLPServer( request )( response );
	
	format = "html";
	for( i = k = 0, i < #response.dblpkey, i++ ) {
		if ( !is_defined( response.dblpkey[i].(Attrs) ) ) {
			// It's a publication key
			println@Console( "Fetching bibtex for publication " + response.dblpkey[i] )();
			getBibtex@DBLPServer( response.dblpkey[i] )( bibtex );
			fileOut.content += bibtex
		}
	};
	fileOut.filename = args[2];
	println@Console( "Writing output to file " + fileOut.filename )();
	writeFile@File( fileOut )()
}