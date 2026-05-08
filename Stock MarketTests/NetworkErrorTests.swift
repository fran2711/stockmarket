//
//  NetworkErrorTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

struct NetworkErrorTests {
    @Test func errorDescriptions() {
        #expect(NetworkError.invalidURL.errorDescription == "Invalid URL")
        #expect(NetworkError.invalidResponse.errorDescription == "Invalid response from server")
        #expect(NetworkError.httpError(statusCode: 404).errorDescription == "HTTP error: 404")
    }

    @Test func decodingErrorDescription() {
        let underlyingError = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "type mismatch"])
        let error = NetworkError.decodingError(underlyingError)
        #expect(error.errorDescription?.contains("Decoding error") == true)
    }

    @Test func unknownErrorDescription() {
        let underlyingError = NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "connection lost"])
        let error = NetworkError.unknown(underlyingError)
        #expect(error.errorDescription == "connection lost")
    }
}
