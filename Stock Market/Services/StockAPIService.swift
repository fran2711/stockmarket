//
//  StockAPIService.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

protocol StockAPIServiceProtocol {
    func fetchMarketSummary(region: String) async throws -> [MarketQuote]
    func fetchStockDetail(symbol: String) async throws -> StockDetailResponse
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

    func fetchStockDetail(symbol: String) async throws -> StockDetailResponse {
        guard let url = APIConfig.Endpoint.stockSummary(symbol: symbol).url else {
            throw NetworkError.invalidURL
        }
        return try await networkService.fetch(StockDetailResponse.self, from: url)
    }
}
