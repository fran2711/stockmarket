//
//  StockDetail.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

// MARK: - Quote Response (from /market/v2/get-quotes)

struct QuoteResponse: Codable {
    let quoteResponse: QuoteResponseBody?
}

struct QuoteResponseBody: Codable {
    let result: [StockQuoteDetail]?
}

struct StockQuoteDetail: Codable {
    let symbol: String?
    let shortName: String?
    let longName: String?
    let currency: String?
    let fullExchangeName: String?
    let regularMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
    let regularMarketVolume: Int?
    let marketCap: Int?
    let regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let regularMarketOpen: Double?
    let regularMarketPreviousClose: Double?
    let fiftyTwoWeekHigh: Double?
    let fiftyTwoWeekLow: Double?
    let trailingPE: Double?
    let forwardPE: Double?
    let dividendYield: Double?
    let beta: Double?
    let averageDailyVolume3Month: Int?

    var displayName: String {
        longName ?? shortName ?? symbol ?? "Unknown"
    }

    var isPriceChangePositive: Bool {
        (regularMarketChange ?? 0) >= 0
    }

    var formattedPrice: String {
        guard let price = regularMarketPrice else { return "N/A" }
        return String(format: "%.2f", price)
    }

    var formattedChange: String {
        guard let change = regularMarketChange else { return "N/A" }
        return String(format: "%+.2f", change)
    }

    var formattedChangePercent: String {
        guard let percent = regularMarketChangePercent else { return "N/A" }
        return String(format: "%+.2f%%", percent)
    }

    var formattedMarketCap: String {
        guard let cap = marketCap else { return "N/A" }
        let billion = 1_000_000_000
        let trillion = 1_000_000_000_000
        if cap >= trillion {
            return String(format: "%.2fT", Double(cap) / Double(trillion))
        } else if cap >= billion {
            return String(format: "%.2fB", Double(cap) / Double(billion))
        } else {
            return String(format: "%.2fM", Double(cap) / 1_000_000.0)
        }
    }

    var formattedVolume: String {
        guard let volume = regularMarketVolume else { return "N/A" }
        if volume >= 1_000_000 {
            return String(format: "%.2fM", Double(volume) / 1_000_000.0)
        } else if volume >= 1_000 {
            return String(format: "%.1fK", Double(volume) / 1_000.0)
        }
        return "\(volume)"
    }
}

// MARK: - Profile Response (from /stock/v3/get-profile)

struct ProfileResponse: Codable {
    let quoteSummary: QuoteSummary?
}

struct QuoteSummary: Codable {
    let result: [ProfileResult]?
}

struct ProfileResult: Codable {
    let summaryProfile: SummaryProfile?
}

struct SummaryProfile: Codable {
    let sector: String?
    let industry: String?
    let longBusinessSummary: String?
    let city: String?
    let country: String?
    let website: String?
}

// MARK: - Combined Detail Model

struct StockDetailData {
    let quote: StockQuoteDetail
    let profile: SummaryProfile?
}
