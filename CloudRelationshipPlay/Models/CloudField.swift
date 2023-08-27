//
//  CloudField.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

struct CloudField: Identifiable, Hashable {
    let id: UUID
    let record: CKRecord
    let trees: [CloudTree]

    static func createRecord() async throws -> CloudField {
        let id = UUID()
        let record = RecordKeys.allCases.reduce(CKRecord(recordType: recordType), { result, key in
            switch key {
            case .id: result[key] = id
            case .trees: break
            }
            return result
        })
        let createdRecord = try await create(record, on: .shared)

        return CloudField(id: id, record: createdRecord, trees: [])
    }
}

extension CloudField: Cloudable {
    static var recordType = "CloudField"

    static func fromRecord(_ record: CKRecord) -> CloudField? {
        let id = UUID(uuidString: record.recordID.recordName)!

        return CloudField(id: id, record: record, trees: [])
    }
}

private enum RecordKeys: String, CaseIterable {
    case id
    case trees
}

extension CKRecord {
    fileprivate subscript(key: RecordKeys) -> Any? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue as? CKRecordValue }
    }
}
