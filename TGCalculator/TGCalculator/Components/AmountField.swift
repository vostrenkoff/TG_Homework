//
//  AmountField.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI

struct AmountField: View {
    @Binding var text: String
    var isSend: Bool = false
    var overrideColor: Color? = nil
    var onChange: (String) -> Void

    var body: some View {
        VStack(alignment: .trailing) {
            TextField("0.00", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 32, weight: .bold))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .foregroundColor(
                    overrideColor ?? (isSend ? Color("TGblue") : .primary)
                )
                .kerning(-0.4)
                .lineSpacing(40 - 32)
                .onChange(of: text) { newValue in
                    var filtered = newValue.replacingOccurrences(of: ",", with: ".")
                    
                    // allow only one dot
                    if let firstDot = filtered.firstIndex(of: ".") {
                        if let lastDot = filtered.lastIndex(of: "."), lastDot != firstDot {
                            // remove extra dots
                            filtered.remove(at: lastDot)
                        }
                    }

                    // allow only two decimal digits
                    if let dotIndex = filtered.firstIndex(of: ".") {
                        let fractionalPart = filtered[filtered.index(after: dotIndex)...]
                        if fractionalPart.count > 2 {
                            filtered = String(filtered[..<filtered.index(dotIndex, offsetBy: 3)])
                        }
                    }

                    // assign back and call callback
                    if filtered != text {
                        text = filtered
                    }
                    onChange(filtered)
                }
        }
        .frame(width: 180)
    }
}
