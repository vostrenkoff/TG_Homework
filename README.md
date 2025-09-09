# TransferGoFXCalculator (FXCalculatorKit + TGCalculator)

FXCalculatorKit is a Swift package for currency conversion with support for live exchange rates and unit testing.  
It demonstrates MVVM architecture, async/await APIs, and includes test coverage with `XCTest`.  
This project was built as part of an offline coding assignment for TransferGo.

TGCalculator is a iOS-demo app used for demonstration of FXCalculatorKit capabilities.

---

## ✨ Features
- Currency conversion with a pluggable API layer (`FXRatesAPI`).
- MVVM pattern with `ConverterViewModel`.
- Forward and backward conversion (send/receive).
- Swap functionality between currencies.
- Error handling (e.g. exceeding limits).
- Unit tests with mock services.
- Written in Swift with async/await.

This repo contains both the **FXCalculatorKit** Swift package and the **TGCalculator** demo iOS app that integrates the package with a production‑style UI.

---

## 📦 Requirements
- iOS 16.0+ / macOS 13.0+
- Xcode 15+
- Swift 5.9+

---

## 🚀 Installation

Clone the repository and open it in Xcode:

```bash
git clone https://github.com/vostrenkoff/TG_Homework.git
cd TG_Homework
open TransferGoFXCalculator.xcworkspace
```

Or, if you want to use it as a Swift Package, add the following to your `Package.swift` and specify the `FXCalculatorKit` target:

```swift
dependencies: [
    .package(url: "https://github.com/vostrenkoff/TG_Homework.git", branch: "main")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "FXCalculatorKit", package: "TG_Homework")
        ]
    )
]
```

> Note: This repository (TransferGoFXCalculator) contains both the TGCalculator app and the FXCalculatorKit package. If you're adding the package from another project, either reference a standalone FXCalculatorKit repo or add it as a **local package** via Xcode (File → Add Packages… → Add Local...).

### Open the demo app
1. Clone this repo  
2. Open `TransferGoFXCalculator.xcworkspace` in Xcode  
3. Run the `TGCalculator` target

### Use FXCalculatorKit as a package
If you only need the package, you can either:  
- Add the `FXCalculatorKit` folder as a local Swift Package in Xcode  
- Or point to this repo in your `Package.swift` and use the `FXCalculatorKit` target

---

## 🛠 Usage

```swift
import FXCalculatorKit

let api: FXRatesAPI = RealFXRatesService() // your API implementation
let viewModel = ConverterViewModel(api: api,
                                   defaultFrom: Currency(country: "USA", code: "USD", name: "Dollar"),
                                   defaultTo: Currency(country: "Eurozone", code: "EUR", name: "Euro"),
                                   defaultAmount: 100)

await viewModel.onAppear()
print(viewModel.rateText) // "1 USD = 0.92 EUR"
print(viewModel.receiveAmount) // "92.00"
```

Usage inside the TGCalculator app:

```swift
import SwiftUI
import FXCalculatorKit

struct ContentView: View {
    @StateObject private var vm = ConverterViewModel(
        api: RealFXRatesService(),
        defaultFrom: Currency(country: "USA", code: "USD", name: "Dollar"),
        defaultTo: Currency(country: "Eurozone", code: "EUR", name: "Euro"),
        defaultAmount: 100
    )

    var body: some View {
        ConverterScreen(vm: vm)
    }
}
```

---

## 🧪 Running Tests

To run all unit tests:

```bash
xcodebuild test -scheme FXCalculatorKit -destination 'platform=iOS Simulator,name=iPhone 15'
```

Or directly from Xcode using **⌘U**.

---

## 📂 Project Structure

- **FXCalculatorKit/** — Swift Package with logics
  - `Domain`
  - `Models`
  - `Networking`
  - `ViewModels`
  - `FXCalculatorKitTests`
- **TGCalculator/** — demo iOS-app
  - `Components` (AmountField, CurrencyMenu, CurrencyRow, NetworkBanner, RateBadge)
  - `Screens/ConverterScreen`
  - `TGCalculatorApp`
  - `TGCalculatorTests` (Unit tests)
  - `TGCalculatorUITests` (UI tests)
- **TransferGoFXCalculator.xcworkspace** — Workspace

---

## ✅ Example Tests

- **Forward conversion** → verifies that receive amount and rate are updated.  
- **Backward conversion** → verifies that updating receive recalculates send correctly.  
- **Swap** → ensures that swapping currencies triggers recalculation.  
- **Limit error** → checks that API errors (e.g. max exceeded) are surfaced in `errorText`.

---
