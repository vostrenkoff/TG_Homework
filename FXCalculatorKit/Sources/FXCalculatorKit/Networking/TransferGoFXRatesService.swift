//
//  TransferGoFXRatesService.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//

import Foundation

private struct AnyDouble: Decodable {
    let value: Double
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let d = try? c.decode(Double.self) {
            value = d
        } else {
            let s = try c.decode(String.self)
            let normalized = s.replacingOccurrences(of: ",", with: ".")
            guard let v = Double(normalized) else {
                throw DecodingError.dataCorruptedError(in: c, debugDescription: "Cannot parse double from \(s)")
            }
            value = v
        }
    }
}

// raw response covering all known key variants
private struct FXRatesRaw: Decodable {
    let from: String
    let to: String
    
    let rate: AnyDouble?
    let amount: AnyDouble?
    let result: AnyDouble?
    let fromAmount: AnyDouble?
    let toAmount: AnyDouble?
}

public final class TransferGoFXRatesService: FXRatesAPI {
    private let session: URLSession
    private let baseURL = URL(string: "https://my.transfergo.com/api/fx-rates")
    private let limits: LimitsProviding

    public init(session: URLSession = .shared, limits: LimitsProviding = HardcodedLimitsProvider()) {
        self.session = session
        self.limits = limits
    }


    public func quote(from: String, to: String, amount: Double) async throws -> FXQuote {
        if let max = limits.maxAmount(for: from), amount > max {         // checking limits
            throw FXAPIError.limitExceeded(max: max, currency: from)
        }

        guard var comps = URLComponents(url: baseURL!, resolvingAgainstBaseURL: false) else {
            throw FXAPIError.invalidURL
        }
        comps.queryItems = [
            .init(name: "from", value: from),
            .init(name: "to", value: to),
            .init(name: "amount", value: String(amount))
        ]
        guard let url = comps.url else { throw FXAPIError.invalidURL }

        // GET request
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        // check status
        let (data, resp) = try await session.data(for: req)
        if let http = resp as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw FXAPIError.badStatus(http.statusCode)
        }

        // get JSON
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // Try single object first
            if let raw = try? decoder.decode(FXRatesRaw.self, from: data) {
                let rate = raw.rate?.value ?? 0
                let amt = raw.amount?.value ?? raw.fromAmount?.value ?? amount
                let converted = raw.result?.value ?? raw.toAmount?.value ?? (rate > 0 ? amt * rate : 0)
                return FXQuote(from: raw.from, to: raw.to, amount: amt, converted: converted, rate: rate)
            }
            // Try array, take the first item
            if let arr = try? decoder.decode([FXRatesRaw].self, from: data), let raw = arr.first {
                let rate = raw.rate?.value ?? 0
                let amt = raw.amount?.value ?? raw.fromAmount?.value ?? amount
                let converted = raw.result?.value ?? raw.toAmount?.value ?? (rate > 0 ? amt * rate : 0)
                return FXQuote(from: raw.from, to: raw.to, amount: amt, converted: converted, rate: rate)
            }

            #if DEBUG
            if let rawStr = String(data: data, encoding: .utf8) {
                print("[FX] Decoding failed. Raw payload: \(rawStr)")
            }
            #endif
            throw FXAPIError.decoding
        } catch {
            #if DEBUG
            if let rawStr = String(data: data, encoding: .utf8) {
                print("[FX] Decoding error: \(error). Raw payload: \(rawStr)")
            }
            #endif
            throw FXAPIError.decoding
        }
    }
}
