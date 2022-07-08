from console import Console
from time import Time

constants {
	RefreshTimeout = 60000 // 1 min
}

type GetCollectionsResponse {
	collections* {
		title:string
		papers* {
			id:int
			title:string
			doi?:string
			bibitem:string
			links* {
				name:string
				link:string
				last:bool
			}
		}
	}
}

interface ACPInterface {
RequestResponse:
	getPapersByAuthor( string )( undefined )
}

service ACPSrv {
	execution: concurrent

	embed Time as Time

	inputPort Input {
		location: "local"
		OneWay: timeout
		RequestResponse: getCollections( void )( GetCollectionsResponse )
	}

	outputPort CL {
		location: "socket://acp.sdu.dk:443"
		protocol: https {
			osc.getPapersByAuthor.alias = "srv/publications/byAuthor/%!{$}.xml"
			osc.getPapersByAuthor.method = "get"
			keepAlive = false
		}
		interfaces: ACPInterface
	}

	init {
		refreshPublications
	}

	define refreshPublications {
		scope( s ) {
			install( default => setNextTimeout@Time( RefreshTimeout ) )
			getPapersByAuthor@CL( "MontesiFabrizio" )( allPapers )
			paperId = 0
			for( collection in allPapers.collection ) {
				if( #collection.paper > 0 ) {
					c.title = collection.title
					for( paper in collection.paper ) {
						p.id = paperId++
						p.title = paper.content
						p.bibitem = paper.bibitem
						i = 0
						for( link in paper.link ) {
							p.links[#p.links] << {
								name =
									if( string(link.name) == "" ) "PDF"
									else link.name
								link = link.link
								last = (++i == #paper.link)
							}
							if( link.name == "doi" )
								p.doi = link.link
						}
						/* if( doi instanceof string ) {
							html += "<span style=\"float:right; width:20%\"><a data-size=\"medium\" href=\"https://plu.mx/plum/a/?doi=" + doi + "\" class=\"plumx-plum-print-popup\"></a></span>"
						} */
						c.papers[#c.papers] << p
						undef( p )
					}
					data.collections[#data.collections] << c
					undef( c )
				}
			}
			synchronized( Refresh ) {
				global.data << data
			}
			undef( data )
		}
		setNextTimeout@Time( RefreshTimeout )
	}

	main {
		[ timeout() ] {
			refreshPublications
		}

		[ getCollections()( response ) {
			synchronized( Refresh ) {
				response << global.data
			}
		} ]
	}
}