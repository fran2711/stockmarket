//
//  PreviewHelpers.swift
//  Stock Market
//
//  Created by Fran Lucena on 8/5/26.
//

import Foundation

// MARK: - Preview Mock Service

final class PreviewStockAPIService: StockAPIServiceProtocol, @unchecked Sendable {
    func fetchMarketSummary(region: String) async throws -> [MarketQuote] {
        MarketQuote.sampleList
    }

    func fetchStockDetail(symbol: String) async throws -> StockDetailData {
        StockDetailData.sample
    }
}

// MARK: - Preview DI Container

final class PreviewDependencyContainer: DependencyContainerProtocol {
    let stockAPIService: StockAPIServiceProtocol = PreviewStockAPIService()

    func makeStockListViewModel() -> StockListViewModel {
        StockListViewModel(stockAPIService: stockAPIService)
    }

    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
        StockDetailViewModel(symbol: symbol, stockAPIService: stockAPIService)
    }
}

// MARK: - Sample Data

extension MarketQuote {
    static let samplePositive = MarketQuote(
        symbol: "AAPL",
        shortName: "Apple Inc.",
        fullExchangeName: "NasdaqGS",
        regularMarketPrice: FormattedValue(raw: 213.25, fmt: "213.25"),
        regularMarketChange: FormattedValue(raw: 4.32, fmt: "+4.32"),
        regularMarketChangePercent: FormattedValue(raw: 2.07, fmt: "+2.07%")
    )

    static let sampleNegative = MarketQuote(
        symbol: "TSLA",
        shortName: "Tesla, Inc.",
        fullExchangeName: "NasdaqGS",
        regularMarketPrice: FormattedValue(raw: 284.50, fmt: "284.50"),
        regularMarketChange: FormattedValue(raw: -8.75, fmt: "-8.75"),
        regularMarketChangePercent: FormattedValue(raw: -2.98, fmt: "-2.98%")
    )

    static let sampleList: [MarketQuote] = [
        .samplePositive,
        .sampleNegative,
        MarketQuote(
            symbol: "GOOG",
            shortName: "Alphabet Inc.",
            fullExchangeName: "NasdaqGS",
            regularMarketPrice: FormattedValue(raw: 178.90, fmt: "178.90"),
            regularMarketChange: FormattedValue(raw: 1.45, fmt: "+1.45"),
            regularMarketChangePercent: FormattedValue(raw: 0.82, fmt: "+0.82%")
        ),
        MarketQuote(
            symbol: "MSFT",
            shortName: "Microsoft Corporation",
            fullExchangeName: "NasdaqGS",
            regularMarketPrice: FormattedValue(raw: 452.10, fmt: "452.10"),
            regularMarketChange: FormattedValue(raw: -2.30, fmt: "-2.30"),
            regularMarketChangePercent: FormattedValue(raw: -0.51, fmt: "-0.51%")
        ),
        MarketQuote(
            symbol: "AMZN",
            shortName: "Amazon.com, Inc.",
            fullExchangeName: "NasdaqGS",
            regularMarketPrice: FormattedValue(raw: 195.75, fmt: "195.75"),
            regularMarketChange: FormattedValue(raw: 3.10, fmt: "+3.10"),
            regularMarketChangePercent: FormattedValue(raw: 1.61, fmt: "+1.61%")
        )
    ]
}

extension StockQuoteDetail {
    static let sample = StockQuoteDetail(
        symbol: "AAPL",
        shortName: "Apple Inc.",
        longName: "Apple Inc.",
        currency: "USD",
        fullExchangeName: "NasdaqGS",
        regularMarketPrice: 213.25,
        regularMarketChange: 4.32,
        regularMarketChangePercent: 2.07,
        regularMarketVolume: 68_450_000,
        marketCap: 3_250_000_000_000,
        regularMarketDayHigh: 215.10,
        regularMarketDayLow: 210.50,
        regularMarketOpen: 211.00,
        regularMarketPreviousClose: 208.93,
        fiftyTwoWeekHigh: 237.49,
        fiftyTwoWeekLow: 164.08,
        trailingPE: 33.85,
        forwardPE: 29.12,
        dividendYield: 0.48,
        beta: 1.24,
        averageDailyVolume3Month: 52_300_000
    )
}

extension SummaryProfile {
    static let sample = SummaryProfile(
        sector: "Technology",
        industry: "Consumer Electronics",
        longBusinessSummary: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. The company offers iPhone, Mac, iPad, and wearables, home, and accessories.",
        city: "Cupertino",
        country: "United States",
        website: "https://www.apple.com"
    )
}

extension StockDetailData {
    static let sample = StockDetailData(
        quote: .sample,
        profile: .sample
    )
}
