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

    var reference: CKRecord.Reference {
        CKRecord.Reference(record: record, action: .deleteSelf)
    }

    static func createRecord() async throws -> CloudField {
        let record = RecordKeys.allCases.reduce(CKRecord(recordType: recordType), { result, key in
            switch key {
            case .id, .trees: break
            }
            return result
        })
        let createdRecord = try await create(record, on: .shared)

        return CloudField(record: createdRecord, trees: [])
    }

    static func listRecords() async throws -> [CloudField] {
        let cloudHandler: CloudHandler = .shared
        let records = try! await CloudField.list(from: cloudHandler)
        let fields = records.map({ record in CloudField.fromRecord(record)! })
        let references = fields.map(\.reference)
        let treesPredicate = NSPredicate(format: "field in %@", references)
        let treeRecords = try! await CloudTree.filter(by: treesPredicate, from: cloudHandler)
        let treeRecordsMappedByFieldID = Dictionary(grouping: treeRecords, by: { record in
            let reference = record["field"] as! CKRecord.Reference
            let field = fields.find(by: \.reference, is: reference)!
            return field.id
        })
        return fields
            .map({ field in
                let trees = treeRecordsMappedByFieldID[field.id]?
                    .map({ record in CloudTree(field: field, record: record) }) ?? []
                return CloudField(record: field.record, trees: trees)
            })
    }
}

extension CloudField: Cloudable {
    static var recordType = "CloudField"

    static func fromRecord(_ record: CKRecord) -> CloudField? {
        CloudField(record: record, trees: [])
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
