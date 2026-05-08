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
    let regularMarketPreviousClose: FormattedValue?

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
        if let change = regularMarketChange?.raw {
            return change
        }
        guard let price = regularMarketPrice?.raw,
              let previousClose = regularMarketPreviousClose?.raw else { return 0.0 }
        return price - previousClose
    }

    var priceChangeFormatted: String {
        if let fmt = regularMarketChange?.fmt {
            return fmt
        }
        guard regularMarketPrice?.raw != nil,
              regularMarketPreviousClose?.raw != nil else { return "N/A" }
        return String(format: "%+.2f", priceChange)
    }

    var priceChangePercent: Double {
        if let percent = regularMarketChangePercent?.raw {
            return percent
        }
        guard let previousClose = regularMarketPreviousClose?.raw,
              previousClose != 0 else { return 0.0 }
        return (priceChange / previousClose) * 100.0
    }

    var priceChangePercentFormatted: String {
        if let fmt = regularMarketChangePercent?.fmt {
            return fmt
        }
        guard regularMarketPrice?.raw != nil,
              regularMarketPreviousClose?.raw != nil else { return "N/A" }
        return String(format: "%+.2f%%", priceChangePercent)
    }

    var isPriceChangePositive: Bool {
        priceChange >= 0
    }
}
