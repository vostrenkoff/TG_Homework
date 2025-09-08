//
//  ConverterScreen.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI
import FXCalculatorKit

struct ConverterScreen: View {
    @ObservedObject var vm: ConverterViewModel
    @State private var searchFrom = ""
    @State private var searchTo = ""
    @FocusState private var focus: FocusField?

    var body: some View {
        VStack(spacing: 16) {
            GroupBox {
                HStack {
                    CurrencyMenu(selected: $vm.from, query: $searchFrom, all: vm.currencies)
                    Spacer()
                    AmountField(title: "Send", text: $vm.sendAmount) { newValue in
                        if focus == .send {
                            vm.updateSend(newValue)     // fixed - updates only when user types
                        }
                    }
                    .focused($focus, equals: .send)
                }
            }
            HStack {
                Text(vm.rateText).font(.headline)
                Spacer()
                Button { vm.swap() } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .imageScale(.large)
                        .rotationEffect(.degrees(90))
                        .padding(8)
                }.buttonStyle(.bordered)
            }
            GroupBox {
                HStack {
                    CurrencyMenu(selected: $vm.to, query: $searchTo, all: vm.currencies)
                    Spacer()
                    AmountField(title: "Receive", text: $vm.receiveAmount) { newValue in
                        if focus == .receive {
                            vm.updateReceive(newValue)      // fixed - updates only when user types
                        }
                    }
                    .focused($focus, equals: .receive)
                }
            }
            if let e = vm.errorText { Text(e).foregroundStyle(.red) }
            Spacer()
        }
        .padding(20)
    }
}
