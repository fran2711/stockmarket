//
//  APIConfig.swift
//  Stock Market
//
//  Created by Fran Lucena on 7/5/26.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://\(apiHost)"

    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "RAPID_API_KEY") as? String, !key.isEmpty else {
            fatalError("RAPID_API_KEY not found in Info.plist")
        }
        return key
    }

    static var apiHost: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "RAPID_API_HOST") as? String, !host.isEmpty else {
            fatalError("RAPID_API_HOST not found in Info.plist")
        }
        return host
    }

    static var headers: [String: String] {
        [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": apiHost
        ]
    }

    enum Endpoint {
        case marketSummary(region: String)
        case stockQuote(symbol: String, region: String)
        case stockProfile(symbol: String)

        var path: String {
            switch self {
            case .marketSummary:
                return "/market/v2/get-summary"
            case .stockQuote:
                return "/market/v2/get-quotes"
            case .stockProfile:
                return "/stock/v3/get-profile"
            }
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .marketSummary(let region):
                return [URLQueryItem(name: "region", value: region)]
            case .stockQuote(let symbol, let region):
                return [
                    URLQueryItem(name: "symbols", value: symbol),
                    URLQueryItem(name: "region", value: region)
                ]
            case .stockProfile(let symbol):
                return [URLQueryItem(name: "symbol", value: symbol)]
            }
        }

        var url: URL? {
            var components = URLComponents(string: APIConfig.baseURL + path)
            components?.queryItems = queryItems
            return components?.url
        }
    }
}
