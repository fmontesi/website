from console import Console
from time import Time

constants {
	RefreshTimeout = 60000 // 1 min
}

interface CLIface {
RequestResponse:
	getPapersByAuthor(string)(undefined)
}

service CLSrv {
	execution: concurrent

	embed Time as Time

	inputPort Input {
		location: "local"
		OneWay: timeout
		RequestResponse: getPublicationsList( void )( string )
	}

	outputPort CL {
		location: "socket://concurrency.sdu.dk:443"
		protocol: https {
			osc.getPapersByAuthor.alias = "srv/publications/byAuthor/%!{$}.xml"
			osc.getPapersByAuthor.method = "get"
			keepAlive = false
		}
		interfaces: CLIface
	}

	init {
		buildPublicationsList
	}

	define buildPublicationsList {
		scope( s ) {
			install( default => setNextTimeout@Time( RefreshTimeout ) )
			html = "<ul class=\"PubList\" id=\"papers_list\">"
			getPapersByAuthor@CL( "MontesiFabrizio" )( allPapers )
			paperId = 0
			for( collection in allPapers.collection ) {
				if( #collection.paper > 0 ) {
					html += "<li style=\"list-style-type: none; margin-left: -2.5em\"><h3>" + collection.title + "</h3></li>"
					for( paper in collection.paper ) {
						doi = void
						html += "<li style=\"margin-bottom: 1em;\" class=\"d-flex\"><span style=\"float:left; width:80%\">" + paper.content
						html += "<br/>"
						html += "<a class=\"text-primary\" style=\"cursor:pointer\" data-toggle=\"collapse\" data-target=\"#bibItem-" + paperId + "\">Bibtex</a>"
						i = 0
						for( link in paper.link ) {
							if( string(link.name) == "" ) {
								link.name = "PDF"
							}
							if( i++ > 0 ) { html += " " }
							html += " | <a  class=\"text-primary\" href=\"" + link.link + "\">" + link.name + "</a>"
							if ( link.name == "doi" ) {
								doi = link.link
							}
						}
						html += "<div id=\"bibItem-" + paperId + "\" class=\"collapse panel panel-default\">"
							+ "<div class=\"panel-body\"><pre>" + paper.bibitem + "</pre></div></div>"
						html += "</span>"
						if( doi instanceof string ) {
							html += "<span style=\"float:right; width:20%\"><a data-size=\"medium\" href=\"https://plu.mx/plum/a/?doi=" + doi + "\" class=\"plumx-plum-print-popup\"></a></span>"
						}
						html += "</li>"
						paperId++
					}
				}
			}
			html += "</ul>"
			synchronized( HTML ) {
				global.html = html
			}
			undef( html )
		}
		setNextTimeout@Time( RefreshTimeout )
	}

	main {
		[ timeout() ] {
			buildPublicationsList
		}

		[ getPublicationsList()( response ) {
			synchronized( HTML ) {
				response = global.html
			}
		} ]
	}
}