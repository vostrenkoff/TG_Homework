//
//  CurrencyMenu.swift
//  
//
//  Created by Artiom Vostrenkov on 08/09/2025.
//


import SwiftUI
import FXCalculatorKit

public struct CurrencyPill: View {
    let code: String

    public var body: some View {
        ZStack {

            
            HStack(spacing: 6) {
                Image("flag_\(code)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                Text(code)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .allowsTightening(true)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 88, height: 32, alignment: .leading) // фикс 88×32
        .contentShape(Rectangle())
        .allowsHitTesting(true)

    }
}

public struct CurrencyMenu: View {
    @Binding var selected: Currency
    @Binding var query: String
    public let all: [Currency]
    public let title: String

    @State private var showPicker = false

    public init(selected: Binding<Currency>, query: Binding<String>, all: [Currency], title: String = "Choose currency") {
        self._selected = selected
        self._query = query
        self.all = all
        self.title = title
    }

    public var body: some View {
        Button { showPicker = true } label: {
            CurrencyPill(code: selected.code)
                .frame(width: 88, height: 32, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color(.systemGray3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    
                    // Large nav title
                    Text("Sending to")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        .lineSpacing(12)
                        .frame(maxWidth: .infinity, alignment: .center)
                    

                    // search field with floating label
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundStyle(.secondary)

                            TextField("", text: $query)
                                .font(.system(size: 18))
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        // floating label that sits on the border line
                        Text("Search")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .background(Color(.systemBackground))
                            .offset(x: 14, y: -8) // align with the stroke
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 26)

                    // Section header
                    HStack {
                        Text("All countries")
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)

                    // List of currencies
                    List {
                        ForEach(filtered, id: \.id) { c in
                            Button {
                                selected = c
                                showPicker = false
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 48, height: 48)

                                        Image("flag_\(c.code)")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(c.country)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(.primary)
                                            .lineSpacing(20 - 14)
                                        HStack(spacing: 6) {
                                            Text(c.name)
                                            Text("•")
                                            Text(c.code)
                                        }
                                        .font(.system(size: 14, weight: .regular))
                                        .lineSpacing(20 - 14)
                                        .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if c == selected {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }

    private var filtered: [Currency] {
        guard !query.isEmpty else { return all }
        return all.filter {
            $0.code.localizedCaseInsensitiveContains(query) ||
            $0.country.localizedCaseInsensitiveContains(query) ||
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
}
