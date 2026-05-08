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
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
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
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
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
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
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
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
        )
        #expect(quote.priceChangePercentFormatted == "N/A")
    }

    @Test func priceChangeDefaultsToZeroWhenNil() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
        )
        #expect(quote.priceChange == 0.0)
        #expect(quote.priceChangePercent == 0.0)
    }

    // MARK: - Computed Fallback Tests (when API returns null change but provides previousClose)

    @Test func priceChangeComputedFromPreviousClose() {
        let quote = MarketQuote(
            symbol: "ES=F", shortName: "S&P Futures", fullExchangeName: "CME",
            regularMarketPrice: FormattedValue(raw: 7385.0, fmt: "7,385.00"),
            regularMarketChange: nil,
            regularMarketChangePercent: nil,
            regularMarketPreviousClose: FormattedValue(raw: 7363.0, fmt: "7,363.00")
        )
        #expect(quote.priceChange == 22.0)
        #expect(quote.priceChangeFormatted == "+22.00")
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func priceChangePercentComputedFromPreviousClose() {
        let quote = MarketQuote(
            symbol: "ES=F", shortName: "S&P Futures", fullExchangeName: "CME",
            regularMarketPrice: FormattedValue(raw: 7385.0, fmt: "7,385.00"),
            regularMarketChange: nil,
            regularMarketChangePercent: nil,
            regularMarketPreviousClose: FormattedValue(raw: 7363.0, fmt: "7,363.00")
        )
        let expectedPercent = (22.0 / 7363.0) * 100.0
        #expect(abs(quote.priceChangePercent - expectedPercent) < 0.01)
        #expect(quote.priceChangePercentFormatted.contains("+"))
        #expect(quote.priceChangePercentFormatted.contains("%"))
    }

    @Test func negativeChangeComputedFromPreviousClose() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: "Test", fullExchangeName: nil,
            regularMarketPrice: FormattedValue(raw: 95.0, fmt: "95.00"),
            regularMarketChange: nil,
            regularMarketChangePercent: nil,
            regularMarketPreviousClose: FormattedValue(raw: 100.0, fmt: "100.00")
        )
        #expect(quote.priceChange == -5.0)
        #expect(quote.priceChangeFormatted == "-5.00")
        #expect(quote.isPriceChangePositive == false)
        let expectedPercent = (-5.0 / 100.0) * 100.0
        #expect(abs(quote.priceChangePercent - expectedPercent) < 0.01)
    }

    @Test func directChangeValuesPreferredOverComputed() {
        let quote = MarketQuote(
            symbol: "AAPL", shortName: "Apple", fullExchangeName: nil,
            regularMarketPrice: FormattedValue(raw: 150.0, fmt: "150.00"),
            regularMarketChange: FormattedValue(raw: 3.0, fmt: "+3.00"),
            regularMarketChangePercent: FormattedValue(raw: 2.0, fmt: "+2.00%"),
            regularMarketPreviousClose: FormattedValue(raw: 145.0, fmt: "145.00")
        )
        #expect(quote.priceChange == 3.0)
        #expect(quote.priceChangeFormatted == "+3.00")
        #expect(quote.priceChangePercent == 2.0)
        #expect(quote.priceChangePercentFormatted == "+2.00%")
    }

    @Test func changeReturnsNAWhenOnlyPriceAvailable() {
        let quote = MarketQuote(
            symbol: "TEST", shortName: nil, fullExchangeName: nil,
            regularMarketPrice: FormattedValue(raw: 100.0, fmt: "100.00"),
            regularMarketChange: nil,
            regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
        )
        #expect(quote.priceChange == 0.0)
        #expect(quote.priceChangeFormatted == "N/A")
        #expect(quote.priceChangePercent == 0.0)
        #expect(quote.priceChangePercentFormatted == "N/A")
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
