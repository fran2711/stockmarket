//
//  StockRowView.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI

struct StockRowView: View {
    let stock: MarketQuote

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.symbol)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(stock.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(stock.currentPriceFormatted)
                    .font(.headline)
                    .fontWeight(.semibold)

                HStack(spacing: 2) {
                    Image(systemName: stock.isPriceChangePositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2)
                    Text("\(stock.priceChangeFormatted) (\(stock.priceChangePercentFormatted))")
                        .font(.caption)
                }
                .foregroundStyle(stock.isPriceChangePositive ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Previews

#Preview("Positive Change") {
    List {
        StockRowView(stock: .samplePositive)
    }
    .listStyle(.plain)
}

#Preview("Negative Change") {
    List {
        StockRowView(stock: .sampleNegative)
    }
    .listStyle(.plain)
}

#Preview("Stock List") {
    List(MarketQuote.sampleList) { stock in
        StockRowView(stock: stock)
    }
    .listStyle(.plain)
}
