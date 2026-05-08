//
//  DependencyContainerTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import Foundation
@testable import Stock_Market

@MainActor
struct DependencyContainerTests {
    @Test func containerCreatesStockListViewModel() async {
        let container = DependencyContainer()
        let viewModel = await container.makeStockListViewModel()
        #expect(viewModel.stocks.isEmpty)
    }

    @Test func containerCreatesStockDetailViewModel() async {
        let container = DependencyContainer()
        let viewModel = await container.makeStockDetailViewModel(symbol: "AAPL")
        #expect(viewModel.symbol == "AAPL")
    }
}
