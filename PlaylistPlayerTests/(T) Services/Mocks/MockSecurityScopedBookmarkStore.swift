//
//  MockSecurityScopedBookmarkStore.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockSecurityScopedBookmarkStore: SecurityScopedBookmarkStore {
    func cleanupStore(requiredIds: [UUID]) {
        fatalError("Not implemented yet")

    }

    func add(bookmark: SecurityScopedBookmark) {
        fatalError("Not implemented yet")
    }

    var lastRemovedBookmarkId: UUID?
    func removeBookmark(for id: UUID) {
        lastRemovedBookmarkId = id
    }

    func url(for id: UUID) -> URL? {
        fatalError("Not implemented yet")
    }
}
