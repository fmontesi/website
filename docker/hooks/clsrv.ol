include "console.iol"
include "time.iol"

constants {
	RefreshTimeout = 60000 // 1 min
}

execution { concurrent }

interface CLIface {
RequestResponse:
	getPapersByAuthor(string)(undefined)
}

outputPort CLSrv {
Location: "socket://concurrency.sdu.dk:443"
Protocol: https {
	.osc.getPapersByAuthor.alias = "srv/publications/byAuthor/%!{$}.xml";
	.osc.getPapersByAuthor.method = "get";
	.keepAlive = false
}
Interfaces: CLIface
}

inputPort CLInput {
Location: "local"
OneWay: timeout
RequestResponse: getPublicationsList(void)(string)
}

define buildPublicationsList {
	html = "<ul class=\"PubList\" id=\"papers_list\">";
	getPapersByAuthor@CLSrv( "Montesi:Fabrizio" )( allPapers );
	for( collection in allPapers.collection ) {
		paperId = 0;
		if ( #collection.paper > 0 ) {
			html += "<li style=\"list-style-type: none; margin-left: -2.5em;\"><h3>" + collection.title + "</h3></li>";
			for( paper in collection.paper ) {
				html += "<li><p>" + paper.content;
				html += "<br/>";
				html += "<a data-toggle=\"collapse\" data-target=\"#bibItem-" + paperId + "\">Bibtex</a>";
				i = 0;
				for( link in paper.link ) {
					if ( string(link.name) == "" ) {
						link.name = "PDF"
					};
					if ( i++ > 0 ) { html += " " };
					html += " | <a href=\"" + link.link + "\">" + link.name + "</a>"
				};
				html += "<div id=\"bibItem-" + paperId + "\" class=\"collapse panel panel-default\">"
					+ "<div class=\"panel-body\"><pre>" + paper.bibitem + "</pre></div></div>";
				html += "</p>";
				html += "</li>";
				paperId++
			}
		}
	};
	html += "</ul>";
	synchronized( HTML ) {
		global.html = html
	};
	undef( html );
	setNextTimeout@Time( RefreshTimeout )
}

init
{
	buildPublicationsList
}

main
{
	[ timeout() ] {
		buildPublicationsList
	}

	[ getPublicationsList()( response ) {
		synchronized( HTML ) {
			response = global.html
		}
	} ]
}
