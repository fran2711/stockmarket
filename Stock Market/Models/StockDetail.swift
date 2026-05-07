//
//  StockDetail.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

struct StockDetailResponse: Codable {
    let price: StockPrice?
    let summaryDetail: SummaryDetail?
    let summaryProfile: SummaryProfile?
}

struct StockPrice: Codable {
    let symbol: String?
    let shortName: String?
    let longName: String?
    let currency: String?
    let regularMarketPrice: FormattedValue?
    let regularMarketChange: FormattedValue?
    let regularMarketChangePercent: FormattedValue?
    let regularMarketVolume: FormattedValue?
    let marketCap: FormattedValue?
    let regularMarketDayHigh: FormattedValue?
    let regularMarketDayLow: FormattedValue?
    let regularMarketOpen: FormattedValue?
    let regularMarketPreviousClose: FormattedValue?
    let exchangeName: String?

    var displayName: String {
        longName ?? shortName ?? symbol ?? "Unknown"
    }

    var isPriceChangePositive: Bool {
        (regularMarketChange?.raw ?? 0) >= 0
    }
}

struct SummaryDetail: Codable {
    let previousClose: FormattedValue?
    let open: FormattedValue?
    let dayLow: FormattedValue?
    let dayHigh: FormattedValue?
    let fiftyTwoWeekLow: FormattedValue?
    let fiftyTwoWeekHigh: FormattedValue?
    let volume: FormattedValue?
    let averageVolume: FormattedValue?
    let marketCap: FormattedValue?
    let trailingPE: FormattedValue?
    let forwardPE: FormattedValue?
    let dividendYield: FormattedValue?
    let beta: FormattedValue?
}

struct SummaryProfile: Codable {
    let sector: String?
    let industry: String?
    let longBusinessSummary: String?
    let city: String?
    let country: String?
    let website: String?
}
