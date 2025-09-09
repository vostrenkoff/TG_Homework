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
    func test_supportedContainsOnlyFour() {
        let codes = Set(SupportedCurrencies.all.map { $0.code })
        XCTAssertEqual(codes, ["PLN","EUR","GBP","UAH"])
        XCTAssertEqual(SupportedCurrencies.all.count, 4)
        }

    func test_searchFiltersByCountryNameAndCode() {
        let all = SupportedCurrencies.all
        XCTAssertTrue(all.contains { $0.country.localizedCaseInsensitiveContains("Poland") })
        XCTAssertTrue(all.contains { $0.name.localizedCaseInsensitiveContains("zloty") })
        XCTAssertTrue(all.contains { $0.code == "UAH" })
    }
}
