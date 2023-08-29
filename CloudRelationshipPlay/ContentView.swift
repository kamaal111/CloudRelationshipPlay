//
//  ContentView.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 25/08/2023.
//

import SwiftUI
import KamaalUI

struct ContentView: View {
    @Environment(FieldsManager.self) private var fieldsManager

    var body: some View {
        KScrollableForm {
            Button(action: { Task { await fieldsManager.createField() } }) {
                Text("Create field")
            }
            .disabled(fieldsManager.loading)
            if fieldsManager.loading {
                KLoading()
            }
            ForEach(fieldsManager.fields) { field in
                Text(field.id.uuidString)
            }
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
