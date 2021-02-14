//
//  SecurityScopedBookmarkStore.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/02/2021.
//

import Foundation

struct SecurityScopedBookmark: Codable {
    let id: UUID
    let data: Data

    init?(id: UUID, securityScopedURL: URL) {
        self.id = id

        // As per: https://danieltull.co.uk/blog/2018/09/09/wrapping-urls-security-scoped-resource-methods/
        do {
            self.data = try securityScopedURL.accessSecurityScopedResource {
                try $0.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            }
        } catch {
            return nil
        }
    }
}

protocol SecurityScopedBookmarkStore {
    func add(bookmark: SecurityScopedBookmark)
    func removeBookmark(for id: UUID)
    func url(for id: UUID) -> URL?
}

/// An object for storing security scoped bookmarks to the files within the filesystem (persisting the user's granted permissions to a given file).
class SecurityScopedBookmarkStoreImpl: SecurityScopedBookmarkStore {

    // MARK: - Properties

    private let location: URL
    private var bookmarks = [SecurityScopedBookmark]()

    // MARK: - Init

    init(location: URL) {
        self.location = location
        self.bookmarks = fetchBookmarks()
    }

    convenience init() {
        let defaultLocation = FileManager.default.documentsDirectory
            .appendingPathComponent("SecurityScopedBookmarks")
            .appendingPathExtension("json")
        self.init(location: defaultLocation)
    }

    // MARK: - Public

    func add(bookmark: SecurityScopedBookmark) {
        bookmarks.append(bookmark)
        save()
    }

    func removeBookmark(for id: UUID) {
        bookmarks.removeAll(where: { $0.id == id })
        save()
    }

    func url(for id: UUID) -> URL? {
        guard let bookmark = bookmarks.first(where: { $0.id == id }) else { return nil }

        var isStale = false // TODO: What to do about this stale flag?
        guard let url = try? URL(resolvingBookmarkData: bookmark.data, bookmarkDataIsStale: &isStale) else { return nil }
        return url
    }
    
    private func save() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(bookmarks) else { return }
        do {
            try data.write(to: location)
        } catch let error {
            print("Error writing security scoped bookmark to disk: \(error.localizedDescription)")
        }
    }

    private func fetchBookmarks() -> [SecurityScopedBookmark] {
        guard let data = try? Data(contentsOf: location) else { return [] }
        let decoder = JSONDecoder()
        do {
            let bookmarks = try decoder.decode([SecurityScopedBookmark].self, from: data)
            return bookmarks
        } catch let error {
            print("Error fetching security scoped bookmark from disk: \(error.localizedDescription)")
            return []
        }
    }
}
