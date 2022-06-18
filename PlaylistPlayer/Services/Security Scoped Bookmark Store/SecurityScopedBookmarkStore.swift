////
////  SecurityScopedBookmarkStore.swift
////  PlaylistPlayer
////
////  Created by Andy Brown on 07/02/2021.
////
//
//import Foundation
//
//struct SecurityScopedBookmark: Codable {
//    let id: UUID
//    let data: Data
//
//    init?(id: UUID, securityScopedURL: URL) {
//        self.id = id
//
//        // As per: https://danieltull.co.uk/blog/2018/09/09/wrapping-urls-security-scoped-resource-methods/
//        do {
//            self.data = try securityScopedURL.accessSecurityScopedResource {
//                try $0.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
//            }
//        } catch {
//            return nil
//        }
//    }
//}
//
//protocol SecurityScopedBookmarkStore {
//    func add(bookmark: SecurityScopedBookmark)
//    func removeBookmark(for id: UUID)
//    func url(for id: UUID) -> URL?
//    func cleanupStore(requiredIds: [UUID])
//}
//
///// An object for storing security scoped bookmarks to the files within the filesystem (persisting the user's granted permissions to a given file). **This object is thread safe.**
//class SecurityScopedBookmarkStoreImpl: SecurityScopedBookmarkStore {
//
//    // MARK: - Properties
//
//    private let fileManager = FileManager.default
//    private let newStorageLocation: URL
//
//
//    private let location: URL
//    private var bookmarks = [SecurityScopedBookmark]()
//
//    private let queue = DispatchQueue(label: "com.playlistplayer.securityscopedbookmarkstore", attributes: .concurrent)
//
//    // MARK: - Init
//
//    init(location: URL) {
//        self.location = location
//        self.newStorageLocation = FileManager.default.documentsDirectory.appendingPathComponent("Bookmarks")
//        self.bookmarks = fetchBookmarks()
//    }
//
//    convenience init() {
//        let defaultLocation = FileManager.default.documentsDirectory
//            .appendingPathComponent("SecurityScopedBookmarks")
//            .appendingPathExtension("json")
//        
//        self.init(location: defaultLocation)
//    }
//
//    // MARK: - Public
//
//    // Using a barrier for writing means we wait until running operations are done, execute
//    // the write task, proceed executing tasks. The block will act as a barrier: all other
//    // blocks that were submitted before the barrier will finish and only then will the
//    // barrier block execute. All blocks submitted after the barrier will not start
//    // until the barrier has finished.
//
//    // think async means you can add/remove loads of times at it'll return to the caller. If you then request a URL for one of the bookmarks, that'll block the queue.
//    func add(bookmark: SecurityScopedBookmark) {
//        queue.sync(flags: .barrier) {
//
//            createStorageDirectoryIfRequired()
//
//            try? URL.writeBookmarkData(bookmark.data, to: newStorageLocation.appendingPathComponent(bookmark.id.uuidString))
//
//            self.bookmarks.append(bookmark)
//            self.save()
//        }
//    }
//
//    private func createStorageDirectoryIfRequired() {
//        if fileManager.fileExists(atPath: newStorageLocation.relativePath) == false {
//            try? fileManager.createDirectory(at: newStorageLocation, withIntermediateDirectories: true, attributes: nil)
//        }
//    }
//
//    func removeBookmark(for id: UUID) {
//        queue.sync(flags: .barrier) {
//            self.bookmarks.removeAll(where: { $0.id == id })
//            self.save()
//        }
//    }
//
//    func url(for id: UUID) -> URL? {
//        var url: URL?
//
//        queue.sync {
//
//            let newUrl = newStorageLocation.appendingPathComponent(id.uuidString)
//            let data = try! URL.bookmarkData(withContentsOf: newUrl)
//            print("DATA: \(data)")
//            var isStale = false // TODO: What to do about this stale flag?
//            url = try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale)
//            print("URL:\(url)")
////            if let bookmark = bookmarks.first(where: { $0.id == id }) {
////
////                var isStale = false // TODO: What to do about this stale flag?
////                url = try? URL(resolvingBookmarkData: bookmark.data, bookmarkDataIsStale: &isStale)
////            }
//        }
//        return url
//    }
//
//    func cleanupStore(requiredIds: [UUID]) {
//        queue.sync {
//            let allBookmarksInStore = Set(bookmarks.map { $0.id })
//            let bookmarksToKeep = Set(requiredIds)
//            let bookmarksToDelete = allBookmarksInStore.subtracting(bookmarksToKeep)
//
//            for id in bookmarksToDelete {
//                self.bookmarks.removeAll(where: { $0.id == id })
//            }
//            save()
//        }
//    }
//
//    // MARK: - Private
//
//    private func save() {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(bookmarks) else { return }
//        do {
//            try data.write(to: location)
//        } catch let error {
//            print("Error writing security scoped bookmark to disk: \(error.localizedDescription)")
//        }
//    }
//
//    private func fetchBookmarks() -> [SecurityScopedBookmark] {
//        guard let data = try? Data(contentsOf: location) else { return [] }
//        let decoder = JSONDecoder()
//        do {
//            let bookmarks = try decoder.decode([SecurityScopedBookmark].self, from: data)
//            return bookmarks
//        } catch let error {
//            print("Error fetching security scoped bookmark from disk: \(error.localizedDescription)")
//            return []
//        }
//    }
//}
