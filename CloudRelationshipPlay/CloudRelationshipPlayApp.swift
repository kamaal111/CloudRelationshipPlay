//
//  CloudRelationshipPlayApp.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 25/08/2023.
//

import SwiftUI

@main
struct CloudRelationshipPlayApp: App {
    @State private var fieldsManager = FieldsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(fieldsManager)
        }
    }
}
