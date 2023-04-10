from runtime import Runtime

type QSType {
	items*:int { ? }
}

interface QuicksortInterface {
RequestResponse: sort( QSType )( QSType )
}

service Quicksort {
	execution: concurrent

	inputPort QuicksortInput {
		location: "local"
		interfaces: QuicksortInterface
	}

	outputPort Self {
		interfaces: QuicksortInterface
	}

	embed Runtime as runtime

	init {
		getLocalLocation@runtime()( Self.location )
	}

	main {
		[ sort( req )( res ){
			if( #req.items <= 1 ){
				res << req
			} else {
				pivot = (#req.items)/2;
				pivIt << req.items[ pivot ];
				for ( i=0, i<#req.items, i++) {
					if( i != pivot ) {
						if( req.items[ i ] > pivIt ) {
							left.items[ #left.items ] << req.items[ i ]
						} else {
							right.items[ #right.items ] << req.items[ i ]
						}
					}
				};
				if( #left.items > 0 ) {
					sort@Self( left )( qsLeft )
				};
				if( #right.items > 0 ){
					sort@Self( right )( qsRight )
				};
				qsLeft.items[ #qsLeft.items ] << pivIt;
				for ( i=0, i<#qsRight.items, i++) {
					qsLeft.items[ #qsLeft.items ] << qsRight.items[ i ]
				};
				res << qsLeft
			}
		} ] { nullProcess } 
	}
}