outputPort GoogleAnalytics {
Location: "socket://www.google-analytics.com:80/"
Protocol: http { .format = "x-www-form-urlencoded" }
RequestResponse: collect
}
