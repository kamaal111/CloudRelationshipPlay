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

    enum Errors: Error {
        case creationFailure(context: Error)
        case fetchFailure(context: Error)
    }

    func createField() async -> Result<Void, Errors> {
        await withLoading {
            let field: CloudField
            do {
                field = try await CloudField.createRecord()
            } catch {
                return .failure(.creationFailure(context: error))
            }

            await setFields(fields.appended(field))
            return .success(())
        }
    }

    func fetchFields() async -> Result<Void, Errors> {
        await withLoading {
            let fieldRecords: [CKRecord]
            do {
                fieldRecords = try await CloudField.list(from: .shared)
            } catch {
                return .failure(.fetchFailure(context: error))
            }

            await setFields(fieldRecords.map({ record in CloudField.fromRecord(record)! }))
            return .success(())
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
