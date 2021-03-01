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

/// An object for storing security scoped bookmarks to the files within the filesystem (persisting the user's granted permissions to a given file). **This object is thread safe.**
class SecurityScopedBookmarkStoreImpl: SecurityScopedBookmarkStore {

    // MARK: - Properties

    private let location: URL
    private var bookmarks = [SecurityScopedBookmark]()

    private let queue = DispatchQueue(label: "com.playlistplayer.securityscopedbookmarkstore", attributes: .concurrent)

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

    // Using a barrier for writing means we wait until running operations are done, execute
    // the write task, proceed executing tasks. The block will act as a barrier: all other
    // blocks that were submitted before the barrier will finish and only then will the
    // barrier block execute. All blocks submitted after the barrier will not start
    // until the barrier has finished.


    // think async means you can add/remove loads of times at it'll return to the caller. If you then request a URL for one of the bookmarks, that'll block the queue.
    func add(bookmark: SecurityScopedBookmark) {
        queue.sync(flags: .barrier) {
            self.bookmarks.append(bookmark)
            self.save()
        }
    }

    func removeBookmark(for id: UUID) {
        queue.sync(flags: .barrier) {
            self.bookmarks.removeAll(where: { $0.id == id })
            self.save()
        }
    }

    func url(for id: UUID) -> URL? {
        var url: URL?


        queue.sync {
            if let bookmark = bookmarks.first(where: { $0.id == id }) {

                var isStale = false // TODO: What to do about this stale flag?
                url = try? URL(resolvingBookmarkData: bookmark.data, bookmarkDataIsStale: &isStale)
            }
        }
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
