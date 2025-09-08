//
//  TransferGoFXRatesService.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//

import Foundation


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
            let d = try JSONDecoder().decode(FXRatesAPIResponse.self, from: data)
            return FXQuote(from: d.from, to: d.to, amount: d.amount, converted: d.result, rate: d.rate)
        } catch {
            throw FXAPIError.decoding
        }
    }
}
