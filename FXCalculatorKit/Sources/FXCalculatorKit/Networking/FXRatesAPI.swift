//
//  FXRatesAPI.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import Foundation

public protocol FXRatesAPI {
    func quote(from: String, to: String, amount: Double) async throws -> FXQuote
}

public enum FXAPIError: Error, LocalizedError, Equatable {
    case invalidURL
    case badStatus(Int)
    case decoding
    case limitExceeded(max: Double, currency: String)
    case other(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .badStatus(let c): return "Server error (status: \(c))"
        case .decoding: return "Failed to decode response"
        case .limitExceeded(let max, let cur): return "Max for \(cur) is \(max)"
        case .other(let m): return m
        }
    }
}