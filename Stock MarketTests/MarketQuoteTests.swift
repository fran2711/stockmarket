//
//  MarketQuoteTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

// MARK: - MarketQuote Model Tests

struct MarketQuoteTests {
    @Test func displayNameUsesShortNameWhenAvailable() {
        let quote = MarketQuote.mock(symbol: "AAPL", shortName: "Apple Inc.")
        #expect(quote.displayName == "Apple Inc.")
    }

    @Test func displayNameFallsBackToSymbol() {
        let quote = MarketQuote(
            symbol: "AAPL", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil
        )
        #expect(quote.displayName == "AAPL")
    }

    @Test func isPriceChangePositiveWhenChangeIsPositive() {
        let quote = MarketQuote.mock(change: 5.0)
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func isPriceChangePositiveWhenChangeIsZero() {
        let quote = MarketQuote.mock(change: 0.0)
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func isPriceChangeNegativeWhenChangeIsNegative() {
        let quote = MarketQuote.mock(change: -3.0)
        #expect(quote.isPriceChangePositive == false)
    }

    @Test func currentPriceDefaultsToZeroWhenNil() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil
        )
        #expect(quote.currentPrice == 0.0)
        #expect(quote.currentPriceFormatted == "N/A")
    }

    @Test func identifierMatchesSymbol() {
        let quote = MarketQuote.mock(symbol: "GOOG")
        #expect(quote.id == "GOOG")
    }

    @Test func priceChangeFormattedReturnsValue() {
        let quote = MarketQuote.mock(changeFormatted: "+2.50")
        #expect(quote.priceChangeFormatted == "+2.50")
    }

    @Test func priceChangeFormattedReturnsNAWhenNil() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil
        )
        #expect(quote.priceChangeFormatted == "N/A")
    }

    @Test func priceChangePercentFormattedReturnsValue() {
        let quote = MarketQuote.mock(changePercentFormatted: "1.70%")
        #expect(quote.priceChangePercentFormatted == "1.70%")
    }

    @Test func priceChangePercentFormattedReturnsNAWhenNil() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil
        )
        #expect(quote.priceChangePercentFormatted == "N/A")
    }

    @Test func priceChangeDefaultsToZeroWhenNil() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil
        )
        #expect(quote.priceChange == 0.0)
        #expect(quote.priceChangePercent == 0.0)
    }
}

// MARK: - FormattedValue Tests

struct FormattedValueTests {
    @Test func decodesFromJSON() throws {
        let json = """
        {"raw": 150.5, "fmt": "150.50"}
        """.data(using: .utf8)!
        let value = try JSONDecoder().decode(FormattedValue.self, from: json)
        #expect(value.raw == 150.5)
        #expect(value.fmt == "150.50")
    }

    @Test func decodesNullValues() throws {
        let json = """
        {"raw": null, "fmt": null}
        """.data(using: .utf8)!
        let value = try JSONDecoder().decode(FormattedValue.self, from: json)
        #expect(value.raw == nil)
        #expect(value.fmt == nil)
    }

    @Test func encodesToJSON() throws {
        let value = FormattedValue(raw: 42.0, fmt: "42.00")
        let data = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(FormattedValue.self, from: data)
        #expect(decoded.raw == 42.0)
        #expect(decoded.fmt == "42.00")
    }
}
