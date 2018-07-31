// Global Jolie object
var Jolie = {
	// Calls an operation at the originating server using JSON
	call: function( params ) {
		if ( typeof params.service === 'undefined' ) {
			params.url = '/' + params.operation;
		} else {
			params.url = '/!' + params.service + '!/' + params.operation;
		}
		params.dataType = 'json';
		params.contentType = 'application/json';
		params.data = JSON.stringify( params.data );

		if ( typeof params.method === 'undefined' ) {
			params.method = 'POST';
		}

		$.ajax( params );
	}
};

// Make Jolie global
window.Jolie = Jolie;
