//
//  StockListView.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI

struct StockListView: View {
    @StateObject var viewModel: StockListViewModel
    let coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.stocks.isEmpty {
                ProgressView("Loading stocks...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage, viewModel.stocks.isEmpty {
                errorView(message: errorMessage)
            } else {
                stockListContent
            }
        }
        .navigationTitle("Markets")
        .searchable(text: $viewModel.searchText, prompt: "Search stocks")
        .onAppear {
            viewModel.startAutoRefresh()
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
    }

    private var stockListContent: some View {
        List(viewModel.filteredStocks) { stock in
            Button {
                coordinator.navigateToStockDetail(symbol: stock.symbol)
            } label: {
                StockRowView(stock: stock)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.fetchStocks()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry") {
                viewModel.fetchStocks()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
