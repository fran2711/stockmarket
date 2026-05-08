//
//  StockRowViewTests.swift
//  Stock MarketTests
//
//  Created by Fran Lucena on 8/5/26.
//

import Testing
import SwiftUI
@testable import Stock_Market

@MainActor
@Suite("StockRowView Tests")
struct StockRowViewTests {

    @Test func rendersWithPositiveChange() {
        let stock = MarketQuote.mock(
            symbol: "AAPL",
            shortName: "Apple Inc.",
            price: 150.0,
            change: 2.5,
            changePercent: 1.7
        )
        let view = StockRowView(stock: stock)
        let renderer = ImageRenderer(content: view.frame(width: 375))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersWithNegativeChange() {
        let stock = MarketQuote.mock(
            symbol: "TSLA",
            shortName: "Tesla Inc.",
            price: 200.0,
            change: -5.0,
            changeFormatted: "-5.00",
            changePercent: -2.5,
            changePercentFormatted: "-2.50%"
        )
        let view = StockRowView(stock: stock)
        let renderer = ImageRenderer(content: view.frame(width: 375))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersWithNilValues() {
        let stock = MarketQuote(
            symbol: "???",
            shortName: nil,
            fullExchangeName: nil,
            regularMarketPrice: nil,
            regularMarketChange: nil,
            regularMarketChangePercent: nil,
            regularMarketPreviousClose: nil
        )
        let view = StockRowView(stock: stock)
        let renderer = ImageRenderer(content: view.frame(width: 375))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersWithComputedFallbackChange() {
        let stock = MarketQuote.mock(
            symbol: "GOOG",
            shortName: "Alphabet",
            price: 100.0,
            change: 0,
            changeFormatted: "0.00",
            changePercent: 0,
            changePercentFormatted: "0.00%",
            previousClose: 95.0
        )
        let view = StockRowView(stock: stock)
        let renderer = ImageRenderer(content: view.frame(width: 375))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersInDarkMode() {
        let stock = MarketQuote.mock()
        let view = StockRowView(stock: stock)
            .environment(\.colorScheme, .dark)
        let renderer = ImageRenderer(content: view.frame(width: 375))
        #expect(renderer.cgImage != nil)
    }

    @Test func rendersMultipleInList() {
        let stocks = MarketQuote.sampleList
        let view = List(stocks) { stock in
            StockRowView(stock: stock)
        }
        .listStyle(.plain)
        let renderer = ImageRenderer(content: view.frame(width: 375, height: 600))
        #expect(renderer.cgImage != nil)
    }
}
