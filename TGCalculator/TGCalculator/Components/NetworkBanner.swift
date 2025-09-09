//
//  NetworkBanner.swift
//  TGCalculator
//
//  Created by Artiom Vostrenkov on 09/09/2025.
//

import Foundation
import SwiftUI

public struct NetworkBanner: View {
    var title: String
    var subtitle: String
    var onClose: () -> Void

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle().fill(Color("TGerrorRed")).frame(width: 32, height: 32)
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(UIColor(named: "Label") ?? .label))
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray)
            }.offset(y: -12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 6)
    }
}
