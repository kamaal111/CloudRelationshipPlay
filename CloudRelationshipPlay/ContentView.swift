//
//  ContentView.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 25/08/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(FieldsManager.self) private var fieldsManager

    var body: some View {
        VStack {
            Text("Hello there!")
        }
        .padding()
        .onAppear(perform: {
            Task { await fieldsManager.fetchFields() }
        })
    }
}

#Preview {
    ContentView()
}
