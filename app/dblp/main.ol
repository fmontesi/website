from console import Console
from string_utils import StringUtils
from ..ganalytics.main import GoogleAnalytics

constants {
	Attrs = "@Attributes",
	PublicationType_InProceedings = 1,
	PublicationType_Article = 2
}

type GetAuthorBibtexRequest {
	pid:string
}

interface DBLPUtilsInterface {
RequestResponse:
	getAuthorBibtex( GetAuthorBibtexRequest )( string )
		throws IOException
}

type _DBLP_GetPersonPublicationsRequest {
	pid:string
}

interface DBLPServerInterface {
RequestResponse:
	getPersonPublications(_DBLP_GetPersonPublicationsRequest)(undefined),
	getBibtex(string)(string)
}

service DBLP {
	execution: concurrent

	embed Console as Console
	embed StringUtils as StringUtils
	embed GoogleAnalytics as GoogleAnalytics

	outputPort DBLPServer {
		Location: "socket://dblp.uni-trier.de:443/"
		Protocol: https {
			osc.getPersonPublications.alias = "pid/%!{pid}.xml"
			osc.getBibtex.alias = "rec/%!{$}.bib"
			format -> format
			method -> method
		}
		Interfaces: DBLPServerInterface
	}

	inputPort DBLPInput {
		Location: "local"
		Interfaces: DBLPUtilsInterface
	}

	init {
		format = "xml"
		method = "get"
	}

	main {
		getAuthorBibtex( request )( result ) {
			getPersonPublications@DBLPServer( request )( response )

			format = "html"
			for( record in response.r ) {
				foreach( elem : record ) {
					if( is_defined( record.(elem).(Attrs).key ) ) {
						getBibtex@DBLPServer( record.(elem).(Attrs).key )( bibtex )
						result += bibtex
					}
				}
			}
			if( !(result instanceof string) ) {
				undef( result )
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
}