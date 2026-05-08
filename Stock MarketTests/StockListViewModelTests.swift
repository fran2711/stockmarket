//
//  StockListViewModelTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

@MainActor
struct StockListViewModelTests {
    @Test func fetchStocksUpdatesStocksList() async throws {
        let mockService = MockStockAPIService()
        let expectedStocks = [
            MarketQuote.mock(symbol: "AAPL", shortName: "Apple Inc."),
            MarketQuote.mock(symbol: "GOOG", shortName: "Alphabet Inc.")
        ]
        mockService.marketSummaryResult = .success(expectedStocks)

        let viewModel = StockListViewModel(stockAPIService: mockService)
        viewModel.fetchStocks()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.stocks.count == 2)
        #expect(viewModel.stocks[0].symbol == "AAPL")
        #expect(viewModel.stocks[1].symbol == "GOOG")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test func fetchStocksSetsErrorOnFailure() async throws {
        let mockService = MockStockAPIService()
        mockService.marketSummaryResult = .failure(NetworkError.invalidURL)

        let viewModel = StockListViewModel(stockAPIService: mockService)
        viewModel.fetchStocks()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.stocks.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }

    @Test func searchFiltersByName() async throws {
        let mockService = MockStockAPIService()
        let stocks = [
            MarketQuote.mock(symbol: "AAPL", shortName: "Apple Inc."),
            MarketQuote.mock(symbol: "GOOG", shortName: "Alphabet Inc."),
            MarketQuote.mock(symbol: "MSFT", shortName: "Microsoft Corporation")
        ]
        mockService.marketSummaryResult = .success(stocks)

        let viewModel = StockListViewModel(stockAPIService: mockService)
        viewModel.fetchStocks()

        try await Task.sleep(nanoseconds: 100_000_000)

        viewModel.searchText = "Apple"
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.filteredStocks.count == 1)
        #expect(viewModel.filteredStocks[0].symbol == "AAPL")
    }

    @Test func searchFiltersBySymbol() async throws {
        let mockService = MockStockAPIService()
        let stocks = [
            MarketQuote.mock(symbol: "AAPL", shortName: "Apple Inc."),
            MarketQuote.mock(symbol: "GOOG", shortName: "Alphabet Inc.")
        ]
        mockService.marketSummaryResult = .success(stocks)

        let viewModel = StockListViewModel(stockAPIService: mockService)
        viewModel.fetchStocks()

        try await Task.sleep(nanoseconds: 100_000_000)

        viewModel.searchText = "GOOG"
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.filteredStocks.count == 1)
        #expect(viewModel.filteredStocks[0].symbol == "GOOG")
    }

    @Test func emptySearchShowsAllStocks() async throws {
        let mockService = MockStockAPIService()
        let stocks = [
            MarketQuote.mock(symbol: "AAPL"),
            MarketQuote.mock(symbol: "GOOG")
        ]
        mockService.marketSummaryResult = .success(stocks)

        let viewModel = StockListViewModel(stockAPIService: mockService)
        viewModel.fetchStocks()

        try await Task.sleep(nanoseconds: 100_000_000)

        viewModel.searchText = ""
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.filteredStocks.count == 2)
    }

    @Test func stopAutoRefreshCancelsTimer() async throws {
        let mockService = MockStockAPIService()
        mockService.marketSummaryResult = .success([])

        let viewModel = StockListViewModel(stockAPIService: mockService, refreshInterval: 100)
        viewModel.startAutoRefresh()

        try await Task.sleep(nanoseconds: 100_000_000)
        let initialCallCount = mockService.fetchMarketSummaryCallCount

        viewModel.stopAutoRefresh()

        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(mockService.fetchMarketSummaryCallCount == initialCallCount)
    }
}
