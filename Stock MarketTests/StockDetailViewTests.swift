//
//  StockDetailViewTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 8/5/26.
//

import Testing
import SwiftUI
@testable import Stock_Market

@MainActor
@Suite("StockDetailView Tests")
struct StockDetailViewTests {

    private func makeViewModel(
        symbol: String = "AAPL",
        detail: StockDetailData? = nil,
        isLoading: Bool = false,
        errorMessage: String? = nil
    ) -> StockDetailViewModel {
        let service = MockStockAPIService()
        if let detail {
            service.stockDetailResult = .success(detail)
        }
        let vm = StockDetailViewModel(symbol: symbol, stockAPIService: service)
        vm.isLoading = isLoading
        vm.errorMessage = errorMessage
        if let detail {
            vm.detail = detail
        }
        return vm
    }

    // MARK: - Loading State

    @Test func rendersLoadingState() {
        let vm = makeViewModel(isLoading: true)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 800))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Error State

    @Test func rendersErrorState() {
        let vm = makeViewModel(errorMessage: "Failed to load stock details.")
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 800))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Detail with Full Data

    @Test func rendersDetailWithFullData() {
        let detail = StockDetailData(
            quote: .sample,
            profile: .sample
        )
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Detail without Profile

    @Test func rendersDetailWithoutProfile() {
        let detail = StockDetailData(
            quote: .sample,
            profile: nil
        )
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Detail with Nil Optional Fields

    @Test func rendersDetailWithMinimalQuoteData() {
        let quote = StockQuoteDetail(
            symbol: "TEST", shortName: nil, longName: nil,
            currency: nil, fullExchangeName: nil,
            regularMarketPrice: nil, regularMarketChange: nil,
            regularMarketChangePercent: nil, regularMarketVolume: nil,
            marketCap: nil, regularMarketDayHigh: nil,
            regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, fiftyTwoWeekHigh: nil,
            fiftyTwoWeekLow: nil, trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil, averageDailyVolume3Month: nil
        )
        let detail = StockDetailData(quote: quote, profile: nil)
        let vm = makeViewModel(symbol: "TEST", detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Profile with Partial Data

    @Test func rendersDetailWithPartialProfile() {
        let profile = SummaryProfile(
            sector: "Technology",
            industry: nil,
            longBusinessSummary: nil,
            city: nil,
            country: nil,
            website: nil
        )
        let detail = StockDetailData(quote: .sample, profile: profile)
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersDetailWithFullProfile() {
        let profile = SummaryProfile(
            sector: "Technology",
            industry: "Consumer Electronics",
            longBusinessSummary: "Apple Inc. designs and manufactures consumer electronics worldwide.",
            city: "Cupertino",
            country: "United States",
            website: "https://www.apple.com"
        )
        let detail = StockDetailData(quote: .sample, profile: profile)
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Negative Price Change

    @Test func rendersDetailWithNegativeChange() {
        let quote = StockQuoteDetail(
            symbol: "TSLA", shortName: "Tesla", longName: "Tesla, Inc.",
            currency: "USD", fullExchangeName: "NasdaqGS",
            regularMarketPrice: 200.0, regularMarketChange: -5.0,
            regularMarketChangePercent: -2.5,
            regularMarketVolume: 50_000_000, marketCap: 600_000_000_000,
            regularMarketDayHigh: 210.0, regularMarketDayLow: 198.0,
            regularMarketOpen: 205.0, regularMarketPreviousClose: 205.0,
            fiftyTwoWeekHigh: 300.0, fiftyTwoWeekLow: 150.0,
            trailingPE: 50.0, forwardPE: 40.0,
            dividendYield: nil, beta: 2.0,
            averageDailyVolume3Month: 80_000_000
        )
        let detail = StockDetailData(quote: quote, profile: nil)
        let vm = makeViewModel(symbol: "TSLA", detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Dark Mode

    @Test func rendersInDarkMode() {
        let detail = StockDetailData(quote: .sample, profile: .sample)
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        .environment(\.colorScheme, .dark)
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Avg Volume Formatting in View

    @Test func rendersWithSmallAvgVolume() {
        let quote = StockQuoteDetail(
            symbol: "SMALL", shortName: "Small Co", longName: nil,
            currency: "USD", fullExchangeName: nil,
            regularMarketPrice: 10.0, regularMarketChange: 0.1,
            regularMarketChangePercent: 1.0,
            regularMarketVolume: 500, marketCap: 1_000_000,
            regularMarketDayHigh: nil, regularMarketDayLow: nil,
            regularMarketOpen: nil, regularMarketPreviousClose: nil,
            fiftyTwoWeekHigh: nil, fiftyTwoWeekLow: nil,
            trailingPE: nil, forwardPE: nil,
            dividendYield: nil, beta: nil,
            averageDailyVolume3Month: 500
        )
        let detail = StockDetailData(quote: quote, profile: nil)
        let vm = makeViewModel(symbol: "SMALL", detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }

    // MARK: - Profile with Only Location

    @Test func rendersProfileWithOnlyLocation() {
        let profile = SummaryProfile(
            sector: nil,
            industry: nil,
            longBusinessSummary: nil,
            city: "Seattle",
            country: "United States",
            website: nil
        )
        let detail = StockDetailData(quote: .sample, profile: profile)
        let vm = makeViewModel(detail: detail)
        let view = NavigationStack {
            StockDetailView(viewModel: vm)
        }
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 1200))
        #expect(renderer.cgImage != nil)
    }
}
