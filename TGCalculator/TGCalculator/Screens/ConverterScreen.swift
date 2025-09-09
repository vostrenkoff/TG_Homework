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
    @State private var showOfflineBanner = false

    var body: some View {
        VStack {
            let sendOverLimit = (vm.errorText?.contains("Max for") ?? false)
            let outlineShape = RoundedRectangle(cornerRadius: 16).inset(by: 0.5)
            ZStack {
                // react to errorText changes for offline
            }
            .onChange(of: vm.errorText) { newValue in
                let offline = newValue?.localizedCaseInsensitiveContains("offline") ?? false
                if offline {
                    withAnimation(.spring()) { showOfflineBanner = true }
                }
            }
            ZStack {
                VStack(spacing: 16) {
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sending from")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                
                                CurrencyMenu(selected: $vm.from, query: $searchFrom, all: vm.currencies)
                            }
                            Spacer()
                            AmountField(
                                text: $vm.sendAmount,
                                isSend: true,
                                overrideColor: sendOverLimit ? Color("TGerrorRed") : nil
                            ) { newValue in
                                if focus == .send { vm.updateSend(newValue) }
                            }
                            .focused($focus, equals: .send)
                        }
                        .frame(maxWidth: .infinity, minHeight: 92, maxHeight: 92)
                        .padding(.horizontal, 12)
                        .frame(height: 92)
                        
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        outlineShape
                            .stroke(Color("TGerrorRed"), lineWidth: 2)
                            .opacity(sendOverLimit ? 1 : 0)
                    )
                    .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 0)
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Receiver gets")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                
                                
                                
                                CurrencyMenu(selected: $vm.to, query: $searchTo, all: vm.currencies)
                            }
                            Spacer()
                            AmountField(
                                text: $vm.receiveAmount,
                                onChange: { newValue in
                                    if focus == .receive { vm.updateReceive(newValue) }
                                }
                            )
                            .focused($focus, equals: .receive)
                        }.frame(maxWidth: .infinity, minHeight: 92, maxHeight: 92)
                            .padding(.horizontal, 12)
                            .frame(height: 92)
                    }

                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 0)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.systemGray6))
                )
                .padding(.horizontal, 20)
                .overlay(alignment: .center) {
                    ZStack {
                        RateBadge(text: vm.rateText)
                            .allowsHitTesting(false)
                            .zIndex(1)

                        Button {
                            vm.swap()
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color("TGblue")))
                        }
                        .buttonStyle(.plain)
                        .offset(x: -124)
                    }
                }

                if let e = vm.errorText {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color("TGerrorRed"))

                        Text(e)
                            .font(.system(size: 16))
                            .foregroundColor(Color("TGerrorRed"))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("TGerrorRed").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
                // No internet banner
                VStack {
                    if showOfflineBanner {
                        NetworkBanner(
                            title: "No network",
                            subtitle: "Check your internet connection",
                            onClose: { withAnimation(.spring()) { showOfflineBanner = false } }
                        )
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(2)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, -20)
            }
        }
        .padding(.top, 30)
    }
}
