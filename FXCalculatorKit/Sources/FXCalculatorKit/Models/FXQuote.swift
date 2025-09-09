//
//  FXQuote.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import Foundation

public struct FXQuote: Codable, Equatable, Sendable {
    public let from: String
    public let to: String
    public let amount: Double
    public let converted: Double
    public let rate: Double
    
    
//    DEBUG
//    public init(from: String, to: String, amount: Double, converted: Double, rate: Double) {
//        self.from = from
//        self.to = to
//        self.amount = amount
//        self.converted = converted
//        self.rate = rate
//    }
}

public struct FXRatesAPIResponse: Codable, Sendable {
    public let from: String
    public let to: String
    public let amount: Double
    public let rate: Double
    public let result: Double
}
