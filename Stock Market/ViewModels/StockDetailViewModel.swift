//
//  StockDetailViewModel.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation
import Combine

@MainActor
final class StockDetailViewModel: ObservableObject {
    @Published var detail: StockDetailData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let symbol: String
    private let stockAPIService: StockAPIServiceProtocol

    init(symbol: String, stockAPIService: StockAPIServiceProtocol) {
        self.symbol = symbol
        self.stockAPIService = stockAPIService
    }

    func fetchDetail() {
        Task { [weak self] in
            guard let self else { return }
            self.isLoading = true
            self.errorMessage = nil

            do {
                let response = try await self.stockAPIService.fetchStockDetail(symbol: self.symbol)
                self.detail = response
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
