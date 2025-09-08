//
//  LimitsProvider.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import Foundation

public protocol LimitsProviding {
    func maxAmount(for currency: String) -> Double?
}

public struct HardcodedLimitsProvider: LimitsProviding {
    public init() {}
    public func maxAmount(for currency: String) -> Double? {
        switch currency {
        case "PLN": return 20_000
        case "EUR": return 5_000
        case "GBP": return 1_000
        case "UAH": return 50_000
        default: return nil
        }
    }
}
