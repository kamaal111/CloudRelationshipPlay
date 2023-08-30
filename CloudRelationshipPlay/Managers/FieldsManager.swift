//
//  FieldsManager.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 27/08/2023.
//

import CloudKit
import Foundation
import Observation
import KamaalExtensions

@Observable
final class FieldsManager {
    var fields: [CloudField] = []
    var loading = false

    func createTree(on field: CloudField) async {
        await withLoading {
            let tree = try! await CloudTree.createRecord(on: field)
            let updatedTree = CloudField(record: field.record, trees: field.trees.prepended(tree))
            let fieldIndex = fields.findIndex(by: \.id, is: field.id)!
            var newFields = fields
            newFields[fieldIndex] = updatedTree
            await setFields(newFields)
        }
    }

    func createField() async {
        await withLoading {
            let field = try! await CloudField.createRecord()
            await setFields(fields.prepended(field))
        }
    }

    func fetchFields() async {
        await withLoading {
            let records = try! await CloudField.list(from: .shared)
            await setFields(records.map({ record in CloudField.fromRecord(record)! }))
        }
    }

    @MainActor
    private func setFields(_ fields: [CloudField]) {
        self.fields = fields
    }

    @MainActor
    private func setLoading(_ state: Bool) {
        self.loading = state
    }

    private func withLoading<T>(_ completion: () async -> T) async -> T {
        await setLoading(true)
        let result = await completion()
        await setLoading(false)
        return result
    }
}
