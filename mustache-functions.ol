from file import File
from string-utils import StringUtils
from mustache import Mustache

interface MustacheFunctionsInterface {
RequestResponse:
	citep( string )( string ) throws PublicationNotFound( string ),
	citation( string )( string ) throws PublicationNotFound( string )
}

service MustacheFunctions {
	execution: concurrent

	embed StringUtils as stringUtils
	embed File as file
	embed Mustache as mustache

	inputPort input {
		location: "local"
		interfaces: MustacheFunctionsInterface
	}

	main {
		[ citep( key )( response ) {
			// TODO
			readFile@file( { filename = "data/publications-by-path.json", format = "json" } )( publicationsByPath )
			if( !is_defined( publicationsByPath.( path ) ) ) {
				throw PublicationNotFound( "Could not find the publication " + path + "." )
			}

			publication -> publicationsByPath.( path )

			if( #publication.authors == 1 ) {
				cit = publication.authors[ 0 ].name
			} else {
				cit = publication.authors[ 0 ].name + " et al."
			}
		} ]

		[ citation( request )( response ) {
			split@stringUtils( request { regex = " " } )( splitResponse )
			key = splitResponse.result[ 0 ]
			path = splitResponse.result[ 1 ]
			readFile@file( { filename = "data/publications-by-path.json", format = "json" } )( publicationsByPath )
			if( !is_defined( publicationsByPath.( path ) ) ) {
				throw PublicationNotFound( "Could not find the publication " + path + "." )
			}

			publication -> publicationsByPath.( path )

			render@mustache( {
				template = "{{> reference.html}}"
				data << publication
				dir = "templates"
			} )( response )
		} ]
	}
}