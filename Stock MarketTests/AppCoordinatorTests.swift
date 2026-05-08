//
//  AppCoordinatorTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 7/5/26.
//

import Testing
import SwiftUI
@testable import Stock_Market

@MainActor
struct AppCoordinatorTests {
    @Test func navigateToStockDetailAppendsRoute() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)

        #expect(coordinator.navigationPath.isEmpty)

        coordinator.navigateToStockDetail(symbol: "AAPL")
        #expect(coordinator.navigationPath.count == 1)
    }

    @Test func navigateToStockDetailMultipleTimes() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)

        coordinator.navigateToStockDetail(symbol: "AAPL")
        coordinator.navigateToStockDetail(symbol: "GOOG")

        #expect(coordinator.navigationPath.count == 2)
    }

    @Test func navigateBackRemovesLastRoute() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)

        coordinator.navigateToStockDetail(symbol: "AAPL")
        coordinator.navigateToStockDetail(symbol: "GOOG")
        coordinator.navigateBack()

        #expect(coordinator.navigationPath.count == 1)
    }

    @Test func navigateBackDoesNothingWhenEmpty() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)

        coordinator.navigateBack()
        #expect(coordinator.navigationPath.isEmpty)
    }

    @Test func navigateToRootClearsAllRoutes() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)

        coordinator.navigateToStockDetail(symbol: "AAPL")
        coordinator.navigateToStockDetail(symbol: "GOOG")
        coordinator.navigateToStockDetail(symbol: "MSFT")
        coordinator.navigateToRoot()

        #expect(coordinator.navigationPath.isEmpty)
    }

    @Test func makeStockListViewModelReturnsInstance() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)
        let viewModel = coordinator.makeStockListViewModel()
        #expect(viewModel.stocks.isEmpty)
    }

    @Test func makeStockDetailViewModelReturnsCorrectSymbol() {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)
        let viewModel = coordinator.makeStockDetailViewModel(symbol: "TSLA")
        #expect(viewModel.symbol == "TSLA")
    }
}
