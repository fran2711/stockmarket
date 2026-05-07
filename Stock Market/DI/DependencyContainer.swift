//
//  DependencyContainer.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

protocol DependencyContainerProtocol {
    var stockAPIService: StockAPIServiceProtocol { get }
    func makeStockListViewModel() -> StockListViewModel
    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel
}

final class DependencyContainer: DependencyContainerProtocol {
    private let networkService: NetworkServiceProtocol
    let stockAPIService: StockAPIServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.stockAPIService = StockAPIService(networkService: networkService)
    }

    func makeStockListViewModel() -> StockListViewModel {
        StockListViewModel(stockAPIService: stockAPIService)
    }

    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
        StockDetailViewModel(symbol: symbol, stockAPIService: stockAPIService)
    }
}
