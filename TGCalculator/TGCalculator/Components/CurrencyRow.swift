//
//  CurrencyRow.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI
import FXCalculatorKit

private struct FlagView: View {
    let code: String
    var size: CGFloat = 32

    var body: some View {
        Image("flag_\(code)")
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
    }
}
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
