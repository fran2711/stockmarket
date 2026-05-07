//
//  AppCoordinator.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case stockDetail(symbol: String)
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()

    private let container: DependencyContainerProtocol

    init(container: DependencyContainerProtocol) {
        self.container = container
    }

    func navigateToStockDetail(symbol: String) {
        navigationPath.append(AppRoute.stockDetail(symbol: symbol))
    }

    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func navigateToRoot() {
        navigationPath = NavigationPath()
    }

    func makeStockListViewModel() -> StockListViewModel {
        container.makeStockListViewModel()
    }

    func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
        container.makeStockDetailViewModel(symbol: symbol)
    }
}
