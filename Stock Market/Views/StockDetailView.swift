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
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(error)
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
        .navigationTitle(viewModel.symbol)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchDetail()
        }
    }

    private func detailContent(_ detail: StockDetailResponse) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                priceHeader(detail.price)
                if let summary = detail.summaryDetail {
                    tradingDataSection(summary, price: detail.price)
                }
                if let profile = detail.summaryProfile {
                    profileSection(profile)
                }
            }
            .padding()
        }
    }

    private func priceHeader(_ price: StockPrice?) -> some View {
        VStack(spacing: 8) {
            Text(price?.displayName ?? viewModel.symbol)
                .font(.title2)
                .fontWeight(.bold)

            if let exchange = price?.exchangeName {
                Text(exchange)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(price?.regularMarketPrice?.fmt ?? "N/A")
                .font(.system(size: 44, weight: .bold, design: .rounded))

            if let priceChangeFormatted = price?.regularMarketChange?.fmt,
               let priceChangePercentFormatted = price?.regularMarketChangePercent?.fmt {
                let isPricePositive = price?.isPriceChangePositive ?? true
                HStack(spacing: 4) {
                    Image(systemName: isPricePositive ? "arrow.up.right" : "arrow.down.right")
                    Text("\(priceChangeFormatted) (\(priceChangePercentFormatted))")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(isPricePositive ? .green : .red)
            }

            if let currency = price?.currency {
                Text(currency)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

    private func tradingDataSection(_ summary: SummaryDetail, price: StockPrice?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trading Data")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                dataCell(title: "Open", value: summary.open?.fmt)
                dataCell(title: "Previous Close", value: summary.previousClose?.fmt)
                dataCell(title: "Day High", value: summary.dayHigh?.fmt)
                dataCell(title: "Day Low", value: summary.dayLow?.fmt)
                dataCell(title: "52W High", value: summary.fiftyTwoWeekHigh?.fmt)
                dataCell(title: "52W Low", value: summary.fiftyTwoWeekLow?.fmt)
                dataCell(title: "Volume", value: summary.volume?.fmt ?? price?.regularMarketVolume?.fmt)
                dataCell(title: "Avg Volume", value: summary.averageVolume?.fmt)
                dataCell(title: "Market Cap", value: summary.marketCap?.fmt ?? price?.marketCap?.fmt)
                dataCell(title: "P/E (TTM)", value: summary.trailingPE?.fmt)
                dataCell(title: "Forward P/E", value: summary.forwardPE?.fmt)
                dataCell(title: "Dividend Yield", value: summary.dividendYield?.fmt)
                dataCell(title: "Beta", value: summary.beta?.fmt)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
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
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}
