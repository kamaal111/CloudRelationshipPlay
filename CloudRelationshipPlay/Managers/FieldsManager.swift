//
//  FieldsManager.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 27/08/2023.
//

import CloudKit
import Foundation
import Observation

@Observable
final class FieldsManager {
    var fields: [CloudField] = []

    func createField() async {
        
    }

    func fetchFields() async {
        Task {
//            let fieldRecords: [CKRecord]
//            do {
//                fieldRecords = try await CloudField.list(from: .shared)
//            } catch {
//                print("error", error)
//                return
//            }
//            print(fieldRecords)
        }
    }
}
