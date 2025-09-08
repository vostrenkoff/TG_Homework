//
//  AmountField.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI

struct AmountField: View {
    let title: String
    @Binding var text: String
    var onChange: (String) -> Void

    var body: some View {
        VStack(alignment: .trailing) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            TextField("0.00", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.title)
                .onChange(of: text) { onChange($0) }
        }
        .frame(width: 180)
    }
}