//
//  APIConfigTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

struct APIConfigTests {
    @Test func marketSummaryEndpointURL() {
        let endpoint = APIConfig.Endpoint.marketSummary(region: "US")
        let url = endpoint.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("market/v2/get-summary") == true)
        #expect(url?.absoluteString.contains("region=US") == true)
    }

    @Test func stockQuoteEndpointURL() {
        let endpoint = APIConfig.Endpoint.stockQuote(symbol: "AAPL", region: "US")
        let url = endpoint.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("market/v2/get-quotes") == true)
        #expect(url?.absoluteString.contains("symbols=AAPL") == true)
    }

    @Test func stockProfileEndpointURL() {
        let endpoint = APIConfig.Endpoint.stockProfile(symbol: "AAPL")
        let url = endpoint.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("stock/v3/get-profile") == true)
        #expect(url?.absoluteString.contains("symbol=AAPL") == true)
    }

    @Test func headersContainRequiredKeys() {
        let headers = APIConfig.headers
        #expect(headers["X-RapidAPI-Key"] != nil)
        #expect(headers["X-RapidAPI-Host"] == "apidojo-yahoo-finance-v1.p.rapidapi.com")
    }
}
