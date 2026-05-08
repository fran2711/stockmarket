//
//  StockAPIService.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

protocol StockAPIServiceProtocol {
    func fetchMarketSummary(region: String) async throws -> [MarketQuote]
    func fetchStockDetail(symbol: String) async throws -> StockDetailData
}

final class StockAPIService: StockAPIServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchMarketSummary(region: String) async throws -> [MarketQuote] {
        guard let url = APIConfig.Endpoint.marketSummary(region: region).url else {
            throw NetworkError.invalidURL
        }
        let response = try await networkService.fetch(MarketSummaryResponse.self, from: url)
        return response.marketSummaryAndSparkResponse?.result ?? []
    }

    func fetchStockDetail(symbol: String) async throws -> StockDetailData {
        guard let quoteURL = APIConfig.Endpoint.stockQuote(symbol: symbol, region: "US").url else {
            throw NetworkError.invalidURL
        }

        let quoteResponse = try await networkService.fetch(QuoteResponse.self, from: quoteURL)
        guard let quote = quoteResponse.quoteResponse?.result?.first else {
            throw NetworkError.invalidResponse
        }

        var profile: SummaryProfile?
        if let profileURL = APIConfig.Endpoint.stockProfile(symbol: symbol).url {
            let profileResponse = try? await networkService.fetch(ProfileResponse.self, from: profileURL)
            profile = profileResponse?.quoteSummary?.result?.first?.summaryProfile
        }

        return StockDetailData(quote: quote, profile: profile)
    }
}
