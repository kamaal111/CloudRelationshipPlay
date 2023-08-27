//
//  CloudTree.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import Foundation
import KamaalExtensions

struct CloudTree: Identifiable {
    let id: UUID
    let field: CloudField
    let record: CKRecord
}

extension CloudTree: Cloudable {
    static var recordType = "CloudTree"
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
