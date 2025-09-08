//
//  CurrencyMenu.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI
import FXCalculatorKit

struct CurrencyMenu: View {
    @Binding var selected: Currency
    @Binding var query: String
    let all: [Currency]

    var body: some View {
        Menu {
            Section { TextField("Search", text: $query) }
            let filtered = all.filter {
                query.isEmpty ? true :
                ($0.code.localizedCaseInsensitiveContains(query) ||
                 $0.country.localizedCaseInsensitiveContains(query) ||
                 $0.name.localizedCaseInsensitiveContains(query))
            }
            ForEach(filtered) { c in
                Button { selected = c } label: {
                    CurrencyRow(currency: c, isSelected: c == selected)
                }
            }
        } label: {
            HStack {
                FlagView(code: selected.code)
                VStack(alignment: .leading) {
                    Text(selected.country)
                    Text(selected.code).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct FlagView: View {
    let code: String
    var body: some View {
        Image("flag_\(code)")
            .resizable()
            .frame(width: 32, height: 24)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(.quaternary, lineWidth: 1))
    }
}