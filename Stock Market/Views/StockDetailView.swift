//
//  StockDetailView.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI

struct StockDetailView: View {
    @StateObject var viewModel: StockDetailViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading details...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        viewModel.fetchDetail()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if let detail = viewModel.detail {
                detailContent(detail)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.symbol)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchDetail()
        }
    }

    private func detailContent(_ detail: StockDetailData) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                priceHeader(detail.quote)
                tradingDataSection(detail.quote)
                if let profile = detail.profile {
                    profileSection(profile)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private func priceHeader(_ quote: StockQuoteDetail) -> some View {
        VStack(spacing: 8) {
            Text(quote.displayName)
                .font(.title2)
                .fontWeight(.bold)

            if let exchange = quote.fullExchangeName {
                Text(exchange)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(quote.formattedPrice)
                .font(.system(size: 44, weight: .bold, design: .rounded))

            HStack(spacing: 4) {
                Image(systemName: quote.isPriceChangePositive ? "arrow.up.right" : "arrow.down.right")
                Text("\(quote.formattedChange) (\(quote.formattedChangePercent))")
            }
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(quote.isPriceChangePositive ? .green : .red)

            if let currency = quote.currency {
                Text(currency)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.primary.opacity(0.05), radius: 5)
    }

    private func tradingDataSection(_ quote: StockQuoteDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trading Data")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                dataCell(title: "Open", value: quote.regularMarketOpen.map { String(format: "%.2f", $0) })
                dataCell(title: "Previous Close", value: quote.regularMarketPreviousClose.map { String(format: "%.2f", $0) })
                dataCell(title: "Day High", value: quote.regularMarketDayHigh.map { String(format: "%.2f", $0) })
                dataCell(title: "Day Low", value: quote.regularMarketDayLow.map { String(format: "%.2f", $0) })
                dataCell(title: "52W High", value: quote.fiftyTwoWeekHigh.map { String(format: "%.2f", $0) })
                dataCell(title: "52W Low", value: quote.fiftyTwoWeekLow.map { String(format: "%.2f", $0) })
                dataCell(title: "Volume", value: quote.formattedVolume)
                dataCell(title: "Avg Volume", value: quote.averageDailyVolume3Month.map {
                    $0 >= 1_000_000 ? String(format: "%.2fM", Double($0) / 1_000_000.0) : "\($0)"
                })
                dataCell(title: "Market Cap", value: quote.formattedMarketCap)
                dataCell(title: "P/E (TTM)", value: quote.trailingPE.map { String(format: "%.2f", $0) })
                dataCell(title: "Forward P/E", value: quote.forwardPE.map { String(format: "%.2f", $0) })
                dataCell(title: "Dividend Yield", value: quote.dividendYield.map { String(format: "%.2f%%", $0) })
                dataCell(title: "Beta", value: quote.beta.map { String(format: "%.3f", $0) })
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.primary.opacity(0.05), radius: 5)
    }

    private func dataCell(title: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value ?? "N/A")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileSection(_ profile: SummaryProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)

            if let sector = profile.sector {
                HStack {
                    Text("Sector:")
                        .foregroundStyle(.secondary)
                    Text(sector)
                }
                .font(.subheadline)
            }

            if let industry = profile.industry {
                HStack {
                    Text("Industry:")
                        .foregroundStyle(.secondary)
                    Text(industry)
                }
                .font(.subheadline)
            }

            if let location = [profile.city, profile.country].compactMap({ $0 }).joined(separator: ", ") as String?,
               !location.isEmpty {
                HStack {
                    Text("Location:")
                        .foregroundStyle(.secondary)
                    Text(location)
                }
                .font(.subheadline)
            }

            if let summary = profile.longBusinessSummary {
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.primary.opacity(0.05), radius: 5)
    }
}

// MARK: - Previews

#Preview("Stock Detail") {
    let service = PreviewStockAPIService()
    let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: service)
    NavigationStack {
        StockDetailView(viewModel: viewModel)
    }
}

#Preview("Stock Detail - Dark") {
    let service = PreviewStockAPIService()
    let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: service)
    NavigationStack {
        StockDetailView(viewModel: viewModel)
    }
    .preferredColorScheme(.dark)
}

#Preview("Loading State") {
    let service = PreviewStockAPIService()
    let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: service)
    let _ = { viewModel.isLoading = true }()
    return NavigationStack {
        StockDetailView(viewModel: viewModel)
    }
}

#Preview("Error State") {
    let service = PreviewStockAPIService()
    let viewModel = StockDetailViewModel(symbol: "AAPL", stockAPIService: service)
    let _ = { viewModel.errorMessage = "Failed to load stock details." }()
    return NavigationStack {
        StockDetailView(viewModel: viewModel)
    }
}
