//
//  CloudTree.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

struct CloudTree: Identifiable, Hashable {
    let field: CloudField
    let record: CKRecord

    static func createRecord(on field: CloudField) async throws -> CloudTree {
        let record = RecordKeys.allCases.reduce(CKRecord(recordType: recordType), { result, key in
            switch key {
            case .id: break
            case .field: result[key] = field.reference
            }
            return result
        })
        let createdRecord = try await create(record, on: .shared)

        return CloudTree(field: field, record: createdRecord)
    }
}

extension CloudTree: Cloudable {
    static var recordType = "CloudTree"

    static func fromRecord(_ record: CKRecord) -> CloudTree? {
        fatalError()
    }
}

private enum RecordKeys: String, CaseIterable {
    case id
    case field
}

extension CKRecord {
    fileprivate subscript(key: RecordKeys) -> Any? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue as? CKRecordValue }
    }
}
