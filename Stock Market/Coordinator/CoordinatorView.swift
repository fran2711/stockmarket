//
//  CoordinatorView.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    init(container: DependencyContainerProtocol) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            StockListView(
                viewModel: coordinator.makeStockListViewModel(),
                coordinator: coordinator
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .stockDetail(let symbol):
                    StockDetailView(
                        viewModel: coordinator.makeStockDetailViewModel(symbol: symbol)
                    )
                }
            }
        }
        .environmentObject(coordinator)
    }
}
