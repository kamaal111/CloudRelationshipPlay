//
//  Cloudable.swift
//  CloudRelationshipPlay
//
//  Created by Kamaal M Farah on 26/08/2023.
//

import CloudKit
import ICloutKit
import Foundation
import KamaalExtensions

protocol Cloudable {
    var record: CKRecord { get }
    static var recordType: String { get }
}

enum CloudableErrors: Error {
    case iCloudDisabledByUser
}

extension Cloudable {
    static func create(_ record: CKRecord, on context: CloudHandler) async throws -> CKRecord {
        try await context.create(record)
    }

    static func list(from context: CloudHandler) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        return try await filter(by: predicate, limit: nil, from: context)
    }

    static func filter(by predicate: NSPredicate,
                       limit: Int? = nil,
                       from context: CloudHandler) async throws -> [CKRecord] {
        let items: [CKRecord]
        do {
            items = try await context.filter(ofType: recordType, by: predicate)
        } catch {
            try handleFetchErrors(error)
            throw error
        }

        let decodedItems = items
        if let limit {
            if decodedItems.count < limit {
                return decodedItems
            }

            return decodedItems
                .prefix(upTo: limit)
                .asArray()
        }

        return decodedItems
    }

    private static func handleFetchErrors(_ error: Error) throws {
        if let accountErrors = error as? ICloutKit.AccountErrors {
            switch accountErrors {
            case .accountStatusNoAccount:
                throw CloudableErrors.iCloudDisabledByUser
            default:
                break
            }
        }
    }
}
