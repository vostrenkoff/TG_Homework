//
//  RateBadge.swift
//  TGCalculator
//
//  Created by Artiom Vostrenkov on 09/09/2025.
//

import Foundation
import SwiftUI

public struct RateBadge: View {
    let text: String
    public var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Capsule().fill(Color.black.opacity(0.9)))
            .frame(height: 18)
    }
}
