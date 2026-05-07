//
//  Stock_MarketTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

// MARK: - Mock Service

final class MockStockAPIService: StockAPIServiceProtocol, @unchecked Sendable {
    var marketSummaryResult: Result<[MarketQuote], Error> = .success([])
    var stockDetailResult: Result<StockDetailResponse, Error> = .success(
        StockDetailResponse(price: nil, summaryDetail: nil, summaryProfile: nil)
    )
    var fetchMarketSummaryCallCount = 0
    var fetchStockDetailCallCount = 0
    var lastFetchedSymbol: String?

    func fetchMarketSummary(region: String) async throws -> [MarketQuote] {
        fetchMarketSummaryCallCount += 1
        return try marketSummaryResult.get()
    }

    func fetchStockDetail(symbol: String) async throws -> StockDetailResponse {
        fetchStockDetailCallCount += 1
        lastFetchedSymbol = symbol
        return try stockDetailResult.get()
    }
}

// MARK: - Test Helpers

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

// MARK: - Model Tests

struct MarketQuoteTests {
    @Test func displayNameUsesShortNameWhenAvailable() {
        let quote = MarketQuote.mock(symbol: "AAPL", shortName: "Apple Inc.")
        #expect(quote.displayName == "Apple Inc.")
    }

    @Test func displayNameFallsBackToSymbol() {
        let quote = MarketQuote(
            symbol: "AAPL",
            shortName: nil,
            fullExchangeName: nil,
            regularMarketPrice: nil,
            regularMarketChange: nil,
            regularMarketChangePercent: nil
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
            symbol: "TEST",
            shortName: nil,
            fullExchangeName: nil,
            regularMarketPrice: nil,
            regularMarketChange: nil,
            regularMarketChangePercent: nil
        )
        #expect(quote.currentPrice == 0.0)
        #expect(quote.currentPriceFormatted == "N/A")
    }

    @Test func identifierMatchesSymbol() {
        let quote = MarketQuote.mock(symbol: "GOOG")
        #expect(quote.id == "GOOG")
    }
}

// MARK: - StockListViewModel Tests

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

// MARK: - StockDetailViewModel Tests

@MainActor
struct StockDetailViewModelTests {
    @Test func fetchDetailUpdatesDetailData() async throws {
        let mockService = MockStockAPIService()
        let expectedDetail = StockDetailResponse(
            price: StockPrice(
                symbol: "AAPL",
                shortName: "Apple Inc.",
                longName: "Apple Inc.",
                currency: "USD",
                regularMarketPrice: FormattedValue(raw: 150.0, fmt: "150.00"),
                regularMarketChange: FormattedValue(raw: 2.5, fmt: "2.50"),
                regularMarketChangePercent: FormattedValue(raw: 1.7, fmt: "1.70%"),
                regularMarketVolume: FormattedValue(raw: 75000000, fmt: "75M"),
                marketCap: FormattedValue(raw: 2500000000000, fmt: "2.5T"),
                regularMarketDayHigh: FormattedValue(raw: 152.0, fmt: "152.00"),
                regularMarketDayLow: FormattedValue(raw: 148.0, fmt: "148.00"),
                regularMarketOpen: FormattedValue(raw: 149.0, fmt: "149.00"),
                regularMarketPreviousClose: FormattedValue(raw: 147.5, fmt: "147.50"),
                exchangeName: "NASDAQ"
            ),
            summaryDetail: nil,
            summaryProfile: nil
        )
        mockService.stockDetailResult = .success(expectedDetail)

        let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: mockService)
        viewModel.fetchDetail()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.detail != nil)
        #expect(viewModel.detail?.price?.symbol == "AAPL")
        #expect(viewModel.detail?.price?.displayName == "Apple Inc.")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(mockService.lastFetchedSymbol == "AAPL")
    }

    @Test func fetchDetailSetsErrorOnFailure() async throws {
        let mockService = MockStockAPIService()
        mockService.stockDetailResult = .failure(NetworkError.httpError(statusCode: 500))

        let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: mockService)
        viewModel.fetchDetail()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.detail == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }

    @Test func symbolIsStoredCorrectly() {
        let mockService = MockStockAPIService()
        let viewModel = StockDetailViewModel(symbol: "TSLA", stockAPIService: mockService)
        #expect(viewModel.symbol == "TSLA")
    }
}

// MARK: - DependencyContainer Tests

@MainActor
struct DependencyContainerTests {
    @Test func containerCreatesStockListViewModel() async {
        let container = DependencyContainer()
        let viewModel = await container.makeStockListViewModel()
        #expect(viewModel != nil)
    }

    @Test func containerCreatesStockDetailViewModel() async {
        let container = DependencyContainer()
        let viewModel = await container.makeStockDetailViewModel(symbol: "AAPL")
        #expect(viewModel.symbol == "AAPL")
    }
}

// MARK: - StockPrice Model Tests

struct StockPriceTests {
    @Test func displayNamePrefersLongName() {
        let stockPrice = StockPrice(
            symbol: "AAPL", shortName: "Apple", longName: "Apple Inc.",
            currency: "USD", regularMarketPrice: nil, regularMarketChange: nil,
            regularMarketChangePercent: nil, regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, exchangeName: nil
        )
        #expect(stockPrice.displayName == "Apple Inc.")
    }

    @Test func displayNameFallsBackToShortName() {
        let stockPrice = StockPrice(
            symbol: "AAPL", shortName: "Apple", longName: nil,
            currency: nil, regularMarketPrice: nil, regularMarketChange: nil,
            regularMarketChangePercent: nil, regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, exchangeName: nil
        )
        #expect(stockPrice.displayName == "Apple")
    }

    @Test func displayNameFallsBackToSymbol() {
        let stockPrice = StockPrice(
            symbol: "AAPL", shortName: nil, longName: nil,
            currency: nil, regularMarketPrice: nil, regularMarketChange: nil,
            regularMarketChangePercent: nil, regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, exchangeName: nil
        )
        #expect(stockPrice.displayName == "AAPL")
    }

    @Test func displayNameFallsBackToUnknown() {
        let stockPrice = StockPrice(
            symbol: nil, shortName: nil, longName: nil,
            currency: nil, regularMarketPrice: nil, regularMarketChange: nil,
            regularMarketChangePercent: nil, regularMarketVolume: nil, marketCap: nil,
            regularMarketDayHigh: nil, regularMarketDayLow: nil, regularMarketOpen: nil,
            regularMarketPreviousClose: nil, exchangeName: nil
        )
        #expect(stockPrice.displayName == "Unknown")
    }
}

// MARK: - NetworkError Tests

struct NetworkErrorTests {
    @Test func errorDescriptions() {
        #expect(NetworkError.invalidURL.errorDescription == "Invalid URL")
        #expect(NetworkError.invalidResponse.errorDescription == "Invalid response from server")
        #expect(NetworkError.httpError(statusCode: 404).errorDescription == "HTTP error: 404")
    }
}

// MARK: - APIConfig Tests

struct APIConfigTests {
    @Test func marketSummaryEndpointURL() {
        let endpoint = APIConfig.Endpoint.marketSummary(region: "US")
        let url = endpoint.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("market/v2/get-summary") == true)
        #expect(url?.absoluteString.contains("region=US") == true)
    }

    @Test func stockSummaryEndpointURL() {
        let endpoint = APIConfig.Endpoint.stockSummary(symbol: "AAPL")
        let url = endpoint.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("stock/v2/get-summary") == true)
        #expect(url?.absoluteString.contains("symbol=AAPL") == true)
    }

    @Test func headersContainRequiredKeys() {
        let headers = APIConfig.headers
        #expect(headers["X-RapidAPI-Key"] != nil)
        #expect(headers["X-RapidAPI-Host"] == "yh-finance.p.rapidapi.com")
    }
}
