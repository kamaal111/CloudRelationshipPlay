//
//  CloudField.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

struct CloudField: Identifiable {
    let id: UUID
    let record: CKRecord
    let trees: [CloudTree]
}

extension CloudField: Cloudable {
    static var recordType = "CloudField"
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
