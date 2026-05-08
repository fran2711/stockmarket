//
//  NetworkServiceTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

// MARK: - Mock URL Session

final class MockURLSessionDataProvider: URLSessionDataProvider, @unchecked Sendable {
    var data: Data = Data()
    var response: URLResponse = URLResponse()
    var errorToThrow: Error?
    var capturedRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        capturedRequest = request
        if let error = errorToThrow {
            throw error
        }
        return (data, response)
    }

    func configure(statusCode: Int, data: Data = Data(), url: URL = URL(string: "https://mock.test")!) {
        self.data = data
        self.response = HTTPURLResponse(
            url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil
        )!
    }
}

// MARK: - NetworkService Tests

struct NetworkServiceTests {
    @Test func fetchThrowsDecodingErrorOnInvalidJSON() async {
        let mockSession = MockURLSessionDataProvider()
        mockSession.configure(statusCode: 200, data: Data("invalid json".utf8))

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/decoding-error")!

        do {
            let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .decodingError = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected decodingError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func fetchThrowsHTTPErrorOnNon200StatusCode() async {
        let mockSession = MockURLSessionDataProvider()
        mockSession.configure(statusCode: 403)

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/http-403")!

        do {
            let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .httpError(let code) = error {
                #expect(code == 403)
            } else {
                #expect(Bool(false), "Expected httpError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func fetchThrowsHTTPErrorOn500() async {
        let mockSession = MockURLSessionDataProvider()
        mockSession.configure(statusCode: 500)

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/http-500")!

        do {
            let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .httpError(let code) = error {
                #expect(code == 500)
            } else {
                #expect(Bool(false), "Expected httpError")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func fetchSucceedsWithValidResponse() async throws {
        let mockSession = MockURLSessionDataProvider()
        let validJSON = """
        {"marketSummaryAndSparkResponse": {"result": [{"symbol": "AAPL", "shortName": "Apple"}]}}
        """
        mockSession.configure(statusCode: 200, data: Data(validJSON.utf8))

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/valid-response")!

        let result: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
        #expect(result.marketSummaryAndSparkResponse?.result?.count == 1)
        #expect(result.marketSummaryAndSparkResponse?.result?.first?.symbol == "AAPL")
    }

    @Test func fetchSetsCorrectHeaders() async throws {
        let mockSession = MockURLSessionDataProvider()
        let validJSON = """
        {"marketSummaryAndSparkResponse": {"result": []}}
        """
        mockSession.configure(statusCode: 200, data: Data(validJSON.utf8))

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/headers-check")!

        let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)

        #expect(mockSession.capturedRequest?.value(forHTTPHeaderField: "X-RapidAPI-Host") == "apidojo-yahoo-finance-v1.p.rapidapi.com")
        #expect(mockSession.capturedRequest?.value(forHTTPHeaderField: "X-RapidAPI-Key") != nil)
        #expect(mockSession.capturedRequest?.httpMethod == "GET")
    }

    @Test func fetchThrowsInvalidResponseWhenNotHTTP() async {
        let mockSession = MockURLSessionDataProvider()
        mockSession.data = Data()
        mockSession.response = URLResponse()

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/not-http")!

        do {
            let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .invalidResponse = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected invalidResponse, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func fetchThrowsUnknownErrorOnNetworkFailure() async {
        let mockSession = MockURLSessionDataProvider()
        mockSession.errorToThrow = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet"])

        let service = NetworkService(session: mockSession)
        let url = URL(string: "https://mock.test/no-internet")!

        do {
            let _: MarketSummaryResponse = try await service.fetch(MarketSummaryResponse.self, from: url)
            #expect(Bool(false), "Should have thrown")
        } catch let error as NetworkError {
            if case .unknown = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected unknown error, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
}
