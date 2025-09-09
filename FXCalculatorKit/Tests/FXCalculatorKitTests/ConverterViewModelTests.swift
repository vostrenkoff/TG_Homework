//
//  ConverterViewModelTests.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import XCTest
@testable import FXCalculatorKit

private struct MockAPI: FXRatesAPI {
    var impl: (String, String, Double) async throws -> FXQuote

    func quote(from: String, to: String, amount: Double) async throws -> FXQuote {
        try await impl(from, to, amount)
    }
}

final class ConverterViewModelTests: XCTestCase {
    @MainActor
    private func waitUntil(_ condition: @escaping () -> Bool, timeout: TimeInterval = 1.0) async {
        let start = Date()
        while !condition() && Date().timeIntervalSince(start) < timeout {
            try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
        }
    }
    // Ensures forward conversion updates receive amount and rate correctly
    func testForwardConversionUpdatesReceiveAndRate() async {
        let mock = MockFXRatesService()
        mock.next = .init(from: "PLN", to: "UAH", amount: 300, converted: 3000, rate: 10)
        let vm = await MainActor.run { ConverterViewModel(api: mock) }
        await MainActor.run { vm.onAppear() }
        try? await Task.sleep(nanoseconds: 120_000_000)
        await MainActor.run {
            XCTAssertEqual(vm.receiveAmount, "3000.00")
            XCTAssertEqual(vm.rateText, "1 PLN = 10.00 UAH")
        }
    }
    // Checks forward conversion updates using MockAPI
    @MainActor func test_forward_updatesReceiveAndRate() async {
        let api = MockAPI { from, to, amount in
            FXQuote(from: from, to: to, amount: amount, converted: amount * 10, rate: 10)
        }
        let vm = ConverterViewModel(
            api: api,
            defaultFrom: Currency(country: "Poland", code: "PLN", name: "Polish zloty"),
            defaultTo: Currency(country: "Ukraine", code: "UAH", name: "Hrivna"),
            defaultAmount: 300
        )

        vm.onAppear()
        await waitUntil({ vm.rateText != "—" })
        XCTAssertEqual(vm.receiveAmount, "3000.00")
        XCTAssertEqual(vm.rateText, "1 PLN = 10.00 UAH")
    }

    // Ensures backward conversion updates the send amount
    @MainActor func test_backward_updatesSend() async {
        let api = MockAPI { from, to, amount in
            if from == "UAH" && to == "PLN" {
                return FXQuote(from: from, to: to, amount: amount, converted: amount / 10, rate: 0.1)
            }
            return FXQuote(from: from, to: to, amount: amount, converted: amount * 10, rate: 10)
        }
        let vm = ConverterViewModel(
            api: api,
            defaultFrom: Currency(country: "Poland", code: "PLN", name: "Polish zloty"),
            defaultTo: Currency(country: "Ukraine", code: "UAH", name: "Hrivna"),
            defaultAmount: 300
        )

        vm.updateReceive("1000")
        try? await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(vm.sendAmount, "100.00")
    }

    // Ensures swapping currencies recalculates amounts
    @MainActor func test_swap_recalculates() async {
        let api = MockAPI { from, to, amount in
            FXQuote(from: from, to: to, amount: amount, converted: amount * 2, rate: 2)
        }
        let vm = ConverterViewModel(
            api: api,
            defaultFrom: Currency(country: "Germany", code: "EUR", name: "Euro"),
            defaultTo: Currency(country: "Great Britain", code: "GBP", name: "Pound"),
            defaultAmount: 5
        )

        vm.onAppear()
        let before = vm.receiveAmount
        vm.swap()
        try? await Task.sleep(nanoseconds: 400_000_000)
        let after = vm.receiveAmount
        XCTAssertNotEqual(before, after)
    }

    // Ensures limit error surfaces in errorText
    @MainActor func test_limitError_surfacesInErrorText() async {
        let api = MockAPI { from, to, amount in
            throw FXAPIError.limitExceeded(max: 1000, currency: from)
        }
        let vm = ConverterViewModel(
            api: api,
            defaultFrom: Currency(country: "Great Britain", code: "GBP", name: "Pound"),
            defaultTo: Currency(country: "Germany", code: "EUR", name: "Euro"),
            defaultAmount: 5
        )

        vm.onAppear()
        await waitUntil({ vm.errorText?.isEmpty == false })
        XCTAssertTrue(vm.errorText?.contains("Max for GBP is 1000") ?? false)
    }
}
