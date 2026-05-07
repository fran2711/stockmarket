//
//  Stock_MarketApp.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import SwiftUI

@main
struct Stock_MarketApp: App {
    private let container: DependencyContainerProtocol = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            CoordinatorView(container: container)
        }
    }
}
