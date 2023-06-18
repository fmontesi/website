from exec import Exec
from file import File
from string-utils import StringUtils

service BlikiUtils {
	execution: concurrent
	embed File as file
	embed StringUtils as stringUtils

	inputPort Input {
		location: "local"
		RequestResponse: entries, lastUpdated, entryData
	}

	main {
		[ entries()( response ) {
			readFile@file( {
				filename = "data/bliki.json"
				format = "json"
			} )( blikiData )

			list@file( {
				directory = "web/bliki"
				regex = ".+\\.md"
				order.byname = true
			} )( listResponse )
			i = 0
			for( result in listResponse.result ) {
				match@stringUtils( result {
					regex = "([^\\.]+)\\.md"
				} )( matchResult )
				if( matchResult.group[1] instanceof string ) {
					id = matchResult.group[1]
					response.entries[i] << {
						id = id
						filename = result
					}
					response.entries[i] << blikiData.entries.(id)
					i++
				}
			}
		} ]

		[ lastUpdated()( response ) {
			readFile@file( {
				filename = "data/bliki.json"
				format = "json"
			} )( blikiData )
			response = blikiData.lastUpdated
		} ]

		[ entryData( id )( blikiData.entries.(id) ) {
			readFile@file( {
				filename = "data/bliki.json"
				format = "json"
			} )( blikiData )
		} ]
	}
}
