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
    let record: CKRecord
    let trees: [CloudTree]

    var id: UUID {
        UUID(uuidString: record.recordID.recordName)!
    }

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

        return CloudField(record: createdRecord, trees: [])
    }
}

extension CloudField: Cloudable {
    static var recordType = "CloudField"

    static func fromRecord(_ record: CKRecord) -> CloudField? {
        return CloudField(record: record, trees: [])
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
