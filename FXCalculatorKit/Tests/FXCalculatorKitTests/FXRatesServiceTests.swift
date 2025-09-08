//
//  FXRatesServiceTests.swift
//  FXCalculatorKit
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import XCTest
@testable import FXCalculatorKit

final class FXRatesServiceTests: XCTestCase {
    func testLimitProviderValues() {
        let l = HardcodedLimitsProvider()
        XCTAssertEqual(l.maxAmount(for: "PLN"), 20_000)
        XCTAssertEqual(l.maxAmount(for: "EUR"), 5_000)
        XCTAssertEqual(l.maxAmount(for: "GBP"), 1_000)
        XCTAssertEqual(l.maxAmount(for: "UAH"), 50_000)
    }
}