// Global Jolie object
var Jolie = {
	// Calls an operation at the originating server using JSON
	call: function( params ) {
		params.url = '/' + params.operation;
		params.dataType = 'json';
		params.contentType = 'application/json';
		params.data = JSON.stringify( params.data );

		if ( typeof params.method === 'undefined' ) {
			params.method = 'POST';
		}

		params.headers = {
			'X-Jolie-ServicePath': (typeof params.service === 'undefined') ? '/' : params.service
		};

		$.ajax( params );
	}
};

// Make Jolie global
window.Jolie = Jolie;
