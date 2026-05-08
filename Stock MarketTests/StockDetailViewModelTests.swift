//
//  StockDetailViewModelTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

@MainActor
struct StockDetailViewModelTests {
    @Test func fetchDetailUpdatesDetailData() async throws {
        let mockService = MockStockAPIService()
        let expectedDetail = StockDetailData(
            quote: StockQuoteDetail.mock(symbol: "AAPL"),
            profile: SummaryProfile(
                sector: "Technology", industry: "Consumer Electronics",
                longBusinessSummary: "Apple Inc. designs...",
                city: "Cupertino", country: "United States", website: "https://apple.com"
            )
        )
        mockService.stockDetailResult = .success(expectedDetail)

        let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: mockService)
        viewModel.fetchDetail()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.detail != nil)
        #expect(viewModel.detail?.quote.symbol == "AAPL")
        #expect(viewModel.detail?.quote.displayName == "Apple Inc.")
        #expect(viewModel.detail?.profile?.sector == "Technology")
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
