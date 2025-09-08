//
//  CurrencyRow.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI
import FXCalculatorKit

struct CurrencyRow: View {
    let currency: Currency
    let isSelected: Bool
    var body: some View {
        HStack {
            FlagView(code: currency.code)
            VStack(alignment: .leading) {
                Text(currency.country)
                Text("\(currency.name) (\(currency.code))").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if isSelected { Image(systemName: "checkmark") }
        }
        .padding(.vertical, 4)
    }
}