//
//  StockListViewModel.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation
import Combine

@MainActor
final class StockListViewModel: ObservableObject {
    @Published var stocks: [MarketQuote] = []
    @Published var filteredStocks: [MarketQuote] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let stockAPIService: StockAPIServiceProtocol
    private let refreshInterval: TimeInterval
    private var timerTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(
        stockAPIService: StockAPIServiceProtocol,
        refreshInterval: TimeInterval = 8.0
    ) {
        self.stockAPIService = stockAPIService
        self.refreshInterval = refreshInterval
        setupSearchFilter()
    }

    private func setupSearchFilter() {
        $searchText
            .combineLatest($stocks)
            .map { searchText, stocks in
                guard !searchText.isEmpty else { return stocks }
                return stocks.filter { stock in
                    stock.displayName.localizedCaseInsensitiveContains(searchText) ||
                    stock.symbol.localizedCaseInsensitiveContains(searchText)
                }
            }
            .assign(to: &$filteredStocks)
    }

    func startAutoRefresh() {
        fetchStocks()
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(self.refreshInterval * 1_000_000_000))
                guard !Task.isCancelled else { break }
                self.fetchStocks()
            }
        }
    }

    func stopAutoRefresh() {
        timerTask?.cancel()
        timerTask = nil
    }

    func fetchStocks() {
        Task { [weak self] in
            guard let self else { return }
            if self.stocks.isEmpty {
                self.isLoading = true
            }
            self.errorMessage = nil

            do {
                let quotes = try await self.stockAPIService.fetchMarketSummary(region: "US")
                self.stocks = quotes
                self.isLoading = false
            } catch {
                self.isLoading = false
                if self.stocks.isEmpty {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
