//
//  ConverterViewModelTests.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import XCTest
@testable import FXCalculatorKit

final class ConverterViewModelTests: XCTestCase {
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
}
