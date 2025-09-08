//
//  MockFXRatesService.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import Foundation

public final class MockFXRatesService: FXRatesAPI {
    public init() {}
    public var next: FXQuote = .init(from: "PLN", to: "UAH", amount: 300, converted: 2850, rate: 9.5)
    public var error: FXAPIError?

    public func quote(from: String, to: String, amount: Double) async throws -> FXQuote {
        if let e = error { throw e }
        return FXQuote(from: from, to: to, amount: amount, converted: amount * next.rate, rate: next.rate)
    }
}