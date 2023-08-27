//
//  CloudHandler.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import ICloutKit
import Foundation
import KamaalExtensions

class CloudHandler {
    static let shared = CloudHandler()

    private let iCloutKit = ICloutKit(
        containerID: "iCloud.com.io.kamaal.SavingToTheCloud",
        databaseType: .private
    )

    func create(_ record: CKRecord) async throws -> CKRecord {
        let createdRecord = try await iCloutKit.save(record)
        assert(createdRecord != nil)
        return createdRecord ?? record
    }

    func list(ofType objectType: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        return try await filter(ofType: objectType, by: predicate)
    }

    func filter(ofType objectType: String, by predicate: NSPredicate) async throws -> [CKRecord] {
        let items = try await iCloutKit.fetch(ofType: objectType, by: predicate)
        let (_, nonDuplicatesRecords) = try await deleteDuplicateOrDefectedRecords(items)

        return nonDuplicatesRecords
    }

    private func deleteDuplicateOrDefectedRecords(_ records: [CKRecord]) async throws
        -> (deletedRecords: [CKRecord], nonDuplicatesRecords: [CKRecord]) {
        var recordsMappedByID: [String: CKRecord] = [:]
        var recordsToDelete: [CKRecord] = []
        records.forEach { item in
            if let recordToDelete = recordsMappedByID[item.recordID.recordName] {
                recordsToDelete = recordsToDelete.appended(recordToDelete)
            } else {
                recordsMappedByID[item.recordID.recordName] = item
            }
        }

        let deletedItems = try await batchDelete(recordsToDelete)
        return (deletedItems, recordsMappedByID.values.asArray())
    }

    @discardableResult
    func batchDelete(_ records: [CKRecord]) async throws -> [CKRecord] {
        try await iCloutKit.deleteMultiple(records)
    }
}
