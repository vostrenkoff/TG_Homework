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
}

public struct FXRatesAPIResponse: Codable, Sendable {
    public let from: String
    public let to: String
    public let amount: Double
    public let rate: Double
    public let result: Double
}
