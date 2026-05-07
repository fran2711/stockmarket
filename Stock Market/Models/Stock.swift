//
//  Stock.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

struct FormattedValue: Codable {
    let raw: Double?
    let fmt: String?
}

struct MarketSummaryResponse: Codable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse?
}

struct MarketSummaryAndSparkResponse: Codable {
    let result: [MarketQuote]?
}

struct MarketQuote: Codable, Identifiable {
    let symbol: String
    let shortName: String?
    let fullExchangeName: String?
    let regularMarketPrice: FormattedValue?
    let regularMarketChange: FormattedValue?
    let regularMarketChangePercent: FormattedValue?

    var id: String { symbol }

    var displayName: String {
        shortName ?? symbol
    }

    var currentPrice: Double {
        regularMarketPrice?.raw ?? 0.0
    }

    var currentPriceFormatted: String {
        regularMarketPrice?.fmt ?? "N/A"
    }

    var priceChange: Double {
        regularMarketChange?.raw ?? 0.0
    }

    var priceChangeFormatted: String {
        regularMarketChange?.fmt ?? "N/A"
    }

    var priceChangePercent: Double {
        regularMarketChangePercent?.raw ?? 0.0
    }

    var priceChangePercentFormatted: String {
        regularMarketChangePercent?.fmt ?? "N/A"
    }

    var isPriceChangePositive: Bool {
        priceChange >= 0
    }
}
