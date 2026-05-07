//
//  APIConfig.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://yh-finance.p.rapidapi.com"
    static let apiKey = "YOUR_RAPIDAPI_KEY_HERE"
    static let apiHost = "yh-finance.p.rapidapi.com"

    static var headers: [String: String] {
        [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": apiHost
        ]
    }

    enum Endpoint {
        case marketSummary(region: String)
        case stockSummary(symbol: String)

        var path: String {
            switch self {
            case .marketSummary:
                return "/market/v2/get-summary"
            case .stockSummary:
                return "/stock/v2/get-summary"
            }
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .marketSummary(let region):
                return [URLQueryItem(name: "region", value: region)]
            case .stockSummary(let symbol):
                return [
                    URLQueryItem(name: "symbol", value: symbol),
                    URLQueryItem(name: "region", value: "US")
                ]
            }
        }

        var url: URL? {
            var components = URLComponents(string: APIConfig.baseURL + path)
            components?.queryItems = queryItems
            return components?.url
        }
    }
}
