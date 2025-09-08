//
//  ContentView.swift
//  TGCalculator
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//

import SwiftUI
import FXCalculatorKit

struct ContentView: View {
    @StateObject private var vm = ConverterViewModel(api: TransferGoFXRatesService())

    var body: some View {
        NavigationStack {
            ConverterScreen(vm: vm)
                .navigationTitle("Calculator")
        }
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    ContentView()
}
