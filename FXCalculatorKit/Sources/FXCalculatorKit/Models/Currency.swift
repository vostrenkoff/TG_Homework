//
//  Currency.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import Foundation

public struct Currency: Hashable, Identifiable, Codable, Sendable {
    public let country: String
    public let code: String
    public let name: String
    public var id: String { code }

    public init(country: String, code: String, name: String) {
        self.country = country
        self.code = code
        self.name = name
    }
}

public enum SupportedCurrencies {
    public static let all: [Currency] = [
        .init(country: "Poland",        code: "PLN", name: "Polish zloty"),
        .init(country: "Germany",       code: "EUR", name: "Euro"),
        .init(country: "Great Britain", code: "GBP", name: "British Pound"),
        .init(country: "Ukraine",       code: "UAH", name: "Hrivna")
    ]
}
