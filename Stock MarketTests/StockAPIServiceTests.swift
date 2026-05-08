//
//  StockAPIServiceTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

// MARK: - Mock Network Service

final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {
    var results: [String: Any] = [:]
    var errorToThrow: Error?
    var lastRequestedURL: URL?
    var fetchCallCount = 0

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        fetchCallCount += 1
        lastRequestedURL = url
        if let error = errorToThrow {
            throw error
        }
        let key = String(describing: type)
        guard let result = results[key] as? T else {
            throw NetworkError.decodingError(
                NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock for \(key)"])
            )
        }
        return result
    }
}

// MARK: - StockAPIService Tests

struct StockAPIServiceTests {
    @Test func fetchMarketSummaryReturnsQuotes() async throws {
        let mockNetwork = MockNetworkService()
        let expectedResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse(
                result: [MarketQuote.mock(symbol: "AAPL"), MarketQuote.mock(symbol: "GOOG")]
            )
        )
        mockNetwork.results["MarketSummaryResponse"] = expectedResponse

        let service = StockAPIService(networkService: mockNetwork)
        let quotes = try await service.fetchMarketSummary(region: "US")

        #expect(quotes.count == 2)
        #expect(quotes[0].symbol == "AAPL")
        #expect(quotes[1].symbol == "GOOG")
        #expect(mockNetwork.fetchCallCount == 1)
        #expect(mockNetwork.lastRequestedURL?.absoluteString.contains("market/v2/get-summary") == true)
    }

    @Test func fetchMarketSummaryReturnsEmptyWhenResponseIsNil() async throws {
        let mockNetwork = MockNetworkService()
        mockNetwork.results["MarketSummaryResponse"] = MarketSummaryResponse(marketSummaryAndSparkResponse: nil)

        let service = StockAPIService(networkService: mockNetwork)
        let quotes = try await service.fetchMarketSummary(region: "US")

        #expect(quotes.isEmpty)
    }

    @Test func fetchMarketSummaryReturnsEmptyWhenResultIsNil() async throws {
        let mockNetwork = MockNetworkService()
        mockNetwork.results["MarketSummaryResponse"] = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse(result: nil)
        )

        let service = StockAPIService(networkService: mockNetwork)
        let quotes = try await service.fetchMarketSummary(region: "US")

        #expect(quotes.isEmpty)
    }

    @Test func fetchMarketSummaryPropagatesNetworkError() async {
        let mockNetwork = MockNetworkService()
        mockNetwork.errorToThrow = NetworkError.httpError(statusCode: 500)

        let service = StockAPIService(networkService: mockNetwork)

        do {
            _ = try await service.fetchMarketSummary(region: "US")
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .httpError(let code) = error {
                #expect(code == 500)
            } else {
                #expect(Bool(false), "Wrong error case")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }

    @Test func fetchMarketSummaryPassesCorrectRegion() async throws {
        let mockNetwork = MockNetworkService()
        mockNetwork.results["MarketSummaryResponse"] = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse(result: [])
        )

        let service = StockAPIService(networkService: mockNetwork)
        _ = try await service.fetchMarketSummary(region: "ES")

        #expect(mockNetwork.lastRequestedURL?.absoluteString.contains("region=ES") == true)
    }

    @Test func fetchStockDetailReturnsQuoteAndProfile() async throws {
        let mockNetwork = MockNetworkService()
        mockNetwork.results["QuoteResponse"] = QuoteResponse(
            quoteResponse: QuoteResponseBody(result: [StockQuoteDetail.mock(symbol: "TSLA")])
        )
        mockNetwork.results["ProfileResponse"] = ProfileResponse(
            quoteSummary: QuoteSummary(result: [
                ProfileResult(summaryProfile: SummaryProfile(
                    sector: "Technology", industry: "Auto", longBusinessSummary: nil,
                    city: "Austin", country: "US", website: nil
                ))
            ])
        )

        let service = StockAPIService(networkService: mockNetwork)
        let detail = try await service.fetchStockDetail(symbol: "TSLA")

        #expect(detail.quote.symbol == "TSLA")
        #expect(detail.profile?.sector == "Technology")
    }

    @Test func fetchStockDetailThrowsWhenQuoteIsEmpty() async {
        let mockNetwork = MockNetworkService()
        mockNetwork.results["QuoteResponse"] = QuoteResponse(
            quoteResponse: QuoteResponseBody(result: [])
        )

        let service = StockAPIService(networkService: mockNetwork)

        do {
            _ = try await service.fetchStockDetail(symbol: "INVALID")
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .invalidResponse = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected invalidResponse")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }

    @Test func fetchStockDetailPropagatesNetworkError() async {
        let mockNetwork = MockNetworkService()
        mockNetwork.errorToThrow = NetworkError.httpError(statusCode: 403)

        let service = StockAPIService(networkService: mockNetwork)

        do {
            _ = try await service.fetchStockDetail(symbol: "AAPL")
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .httpError(let code) = error {
                #expect(code == 403)
            } else {
                #expect(Bool(false), "Wrong error case")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }
}
