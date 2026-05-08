//
//  TestHelpers.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation
@testable import Stock_Market

// MARK: - Mock Service

final class MockStockAPIService: StockAPIServiceProtocol, @unchecked Sendable {
    var marketSummaryResult: Result<[MarketQuote], Error> = .success([])
    var stockDetailResult: Result<StockDetailData, Error> = .success(
        StockDetailData(
            quote: StockQuoteDetail(
                symbol: nil, shortName: nil, longName: nil, currency: nil,
                fullExchangeName: nil, regularMarketPrice: nil, regularMarketChange: nil,
                regularMarketChangePercent: nil, regularMarketVolume: nil, marketCap: nil,
                regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
                regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil, fiftyTwoWeekLow: nil,
                trailingPE: nil, forwardPE: nil, dividendYield: nil, beta: nil,
                averageDailyVolume3Month: nil
            ),
            profile: nil
        )
    )
    var fetchMarketSummaryCallCount = 0
    var fetchStockDetailCallCount = 0
    var lastFetchedSymbol: String?

    func fetchMarketSummary(region: String) async throws -> [MarketQuote] {
        fetchMarketSummaryCallCount += 1
        return try marketSummaryResult.get()
    }

    func fetchStockDetail(symbol: String) async throws -> StockDetailData {
        fetchStockDetailCallCount += 1
        lastFetchedSymbol = symbol
        return try stockDetailResult.get()
    }
}

// MARK: - Mock Extensions

extension MarketQuote {
    static func mock(
        symbol: String = "AAPL",
        shortName: String = "Apple Inc.",
        price: Double = 150.0,
        priceFormatted: String = "150.00",
        change: Double = 2.5,
        changeFormatted: String = "2.50",
        changePercent: Double = 1.7,
        changePercentFormatted: String = "1.70%"
    ) -> MarketQuote {
        MarketQuote(
            symbol: symbol,
            shortName: shortName,
            fullExchangeName: "NASDAQ",
            regularMarketPrice: FormattedValue(raw: price, fmt: priceFormatted),
            regularMarketChange: FormattedValue(raw: change, fmt: changeFormatted),
            regularMarketChangePercent: FormattedValue(raw: changePercent, fmt: changePercentFormatted)
        )
    }
}

extension StockQuoteDetail {
    static func mock(
        symbol: String = "AAPL",
        shortName: String = "Apple Inc.",
        longName: String = "Apple Inc.",
        price: Double = 150.0,
        change: Double = 2.5,
        changePercent: Double = 1.7
    ) -> StockQuoteDetail {
        StockQuoteDetail(
            symbol: symbol, shortName: shortName, longName: longName,
            currency: "USD", fullExchangeName: "NasdaqGS",
            regularMarketPrice: price, regularMarketChange: change,
            regularMarketChangePercent: changePercent,
            regularMarketVolume: 75000000, marketCap: 2500000000000,
            regularMarketDayHigh: 152.0, regularMarketDayLow: 148.0,
            regularMarketOpen: 149.0, regularMarketPreviousClose: 147.5,
            fiftyTwoWeekHigh: 180.0, fiftyTwoWeekLow: 120.0,
            trailingPE: 28.5, forwardPE: 25.0,
            dividendYield: 0.55, beta: 1.2,
            averageDailyVolume3Month: 50000000
        )
    }
}
