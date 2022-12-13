interface GoogleAnalyticsIface {
RequestResponse: collect
}

service GoogleAnalytics {
	outputPort Output {
		location: "socket://www.google-analytics.com:80/"
		protocol: http {
			format = "x-www-form-urlencoded"
			osc.collect.template = "g/collect?v={v}&tid={tid}&en={en}&dt={dt}"
		}
		interfaces: GoogleAnalyticsIface
	}
	
	inputPort Input {
		location: "local"
		aggregates: Output
	}

	main {
		linkIn( Shutdown )
	}
}
