#!/usr/bin/env -S jolie -s Main --responseTimeout 2000

from console import Console

service Main {
	outputPort dblp {
		location: "socket://dblp.uni-trier.de:443/"
		protocol: https {
			osc.getPersonPublications.alias = "pid/%!{pid}.xml"
			osc.getBibtex.alias = "rec/%!{$}.bib"
			format -> format
			method -> method
		}
		RequestResponse: getBibtex
	}
	embed Console as console

	main {
		println@console( getBibtex@dblp( "journals/scp/GiallorenzoMPRU25" ) )()
	}
}