//
//  ConverterViewModel.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//
import Foundation
import SwiftUI

// check textfield (send or receive)
public enum FocusField: Hashable { case send, receive, none }

@MainActor
public final class ConverterViewModel: ObservableObject {
    @Published public var from: Currency { didSet { Task { await recalcFromSend() } } }
    @Published public var to:   Currency { didSet { Task { await recalcFromSend() } } }
    
    @Published public var sendAmount: String
    @Published public var receiveAmount: String
    
    // UI
    @Published public var rateText: String = "—"          // conversion rate text
    @Published public var errorText: String? = nil        // is there an error?
    @Published public var focused: FocusField = .none     // track focus
    
    // list of supported currencies
    public let currencies: [Currency]

    // dependencies
    private nonisolated(unsafe) let api: FXRatesAPI            // real api or mock
    private var debounceTask: Task<Void, Never>?   // prevent spamming API too often

    // default state settings
    public init(api: FXRatesAPI,
                defaultFrom: Currency = SupportedCurrencies.all[0],
                defaultTo:   Currency = SupportedCurrencies.all[3],
                defaultAmount: Double = 300) {
        self.api = api
        self.currencies = SupportedCurrencies.all
        self.from = defaultFrom
        self.to = defaultTo
        self.sendAmount = Self.format(defaultAmount)
        self.receiveAmount = ""
    }

    // initial conversion request
    public func onAppear() { Task { await recalcFromSend() } }
    
    // swap currencies and recalculate
    public func swap() {
        let f = from; from = to; to = f
        Task { await recalcFromSend() }
    }

    // when edited SEND amount
    public func updateSend(_ text: String)    { sendAmount = text;    schedule(.forward) }
    
    // when edited RECEIVE amount
    public func updateReceive(_ text: String) { receiveAmount = text; schedule(.backward) }
    
    // when changed FROM/TO currencies
    public func selectFrom(_ c: Currency) { from = c; Task { await recalcFromSend() } }
    public func selectTo(_ c: Currency)   { to = c;   Task { await recalcFromSend() } }

    // direction of conversion
    private enum Direction { case forward, backward }

    // wait 300ms after typing before calling API)
    private func schedule(_ d: Direction) {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await self?.recalc(d)
        }
    }

    // reset error and recalc based on direction
    private func recalc(_ d: Direction) async {
        errorText = nil
        switch d {
        case .forward:  await recalcFromSend()
        case .backward: await recalcFromReceive()
        }
    }

    // recalculate when user updates SEND amount
    private func recalcFromSend() async {
        guard let amt = Double(sendAmount.replacingOccurrences(of: ",", with: ".")) else { return }
        do {
            let q = try await api.quote(from: from.code, to: to.code, amount: amt)
            receiveAmount = Self.format(q.converted)
            rateText = "1 \(q.from) = \(Self.format(q.rate)) \(q.to)"
        } catch let e as FXAPIError {
            errorText = e.localizedDescription
        } catch {
            errorText = error.localizedDescription
        }
    }

    // recalculate when user updates RECEIVE amount
    private func recalcFromReceive() async {
        guard let amt = Double(receiveAmount.replacingOccurrences(of: ",", with: ".")) else { return }
        do {
            let q = try await api.quote(from: to.code, to: from.code, amount: amt)
            sendAmount = Self.format(q.converted)
        } catch let e as FXAPIError {
            errorText = e.localizedDescription
        } catch {
            errorText = error.localizedDescription
        }
    }

    // format numbers
    private static func format(_ value: Double) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}
