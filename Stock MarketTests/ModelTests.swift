//
//  ModelTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

// MARK: - StockQuoteDetail Tests

struct StockQuoteDetailTests {
    @Test func displayNamePrefersLongName() {
        let quote = StockQuoteDetail(
            symbol: "AAPL", shortName: "Apple", longName: "Apple Inc.",
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.displayName == "Apple Inc.")
    }

    @Test func displayNameFallsBackToShortName() {
        let quote = StockQuoteDetail(
            symbol: "AAPL", shortName: "Apple", longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.displayName == "Apple")
    }

    @Test func displayNameFallsBackToSymbol() {
        let quote = StockQuoteDetail(
            symbol: "AAPL", shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.displayName == "AAPL")
    }

    @Test func displayNameFallsBackToUnknown() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.displayName == "Unknown")
    }

    @Test func isPriceChangePositiveWhenPositive() {
        let quote = StockQuoteDetail.mock(change: 5.0)
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func isPriceChangePositiveWhenZero() {
        let quote = StockQuoteDetail.mock(change: 0.0)
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func isPriceChangeNegativeWhenNegative() {
        let quote = StockQuoteDetail.mock(change: -3.5)
        #expect(quote.isPriceChangePositive == false)
    }

    @Test func isPriceChangePositiveWhenNil() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.isPriceChangePositive == true)
    }

    @Test func formattedPriceShowsTwoDecimals() {
        let quote = StockQuoteDetail.mock(price: 150.456)
        #expect(quote.formattedPrice == "150.46")
    }

    @Test func formattedPriceReturnsNAWhenNil() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedPrice == "N/A")
    }

    @Test func formattedChangeShowsSign() {
        let positiveQuote = StockQuoteDetail.mock(change: 2.5)
        #expect(positiveQuote.formattedChange == "+2.50")

        let negativeQuote = StockQuoteDetail.mock(change: -1.3)
        #expect(negativeQuote.formattedChange == "-1.30")
    }

    @Test func formattedChangePercentShowsSign() {
        let quote = StockQuoteDetail.mock(changePercent: -0.5)
        #expect(quote.formattedChangePercent == "-0.50%")
    }

    @Test func formattedMarketCapTrillions() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: 2_500_000_000_000,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedMarketCap == "2.50T")
    }

    @Test func formattedMarketCapBillions() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: 500_000_000_000,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedMarketCap == "500.00B")
    }

    @Test func formattedVolumeMillions() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: 75_000_000, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedVolume == "75.00M")
    }

    @Test func formattedVolumeThousands() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: 5_000, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedVolume == "5.0K")
    }

    @Test func formattedVolumeSmall() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: 500, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedVolume == "500")
    }

    @Test func formattedVolumeReturnsNAWhenNil() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedVolume == "N/A")
    }

    @Test func formattedMarketCapMillions() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: 750_000_000,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedMarketCap == "750.00M")
    }

    @Test func formattedMarketCapReturnsNAWhenNil() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedMarketCap == "N/A")
    }

    @Test func formattedChangeReturnsNAWhenNil() {
        let quote = StockQuoteDetail(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil, regularMarketPrice: nil,
            regularMarketChange: nil, regularMarketChangePercent: nil,
            regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        #expect(quote.formattedChange == "N/A")
        #expect(quote.formattedChangePercent == "N/A")
    }
}
