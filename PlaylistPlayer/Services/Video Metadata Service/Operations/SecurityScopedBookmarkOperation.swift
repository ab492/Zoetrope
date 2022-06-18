////
////  SecurityScopedBookmarkOperation.swift
////  PlaylistPlayer
////
////  Created by Andy Brown on 23/02/2021.
////
//
//import Foundation
//
//protocol URLProvider {
//    var url: URL? { get }
//}
//
//final class SecurityScopedBookmarkOperation: Operation {
//
//    private let bookmarkStore: SecurityScopedBookmarkStore
//    private let id: UUID
//    private let securityScopedURL: URL
//
//    private var outputURL: URL?
//
//    /// This callback will be run **on the main thread** when the operation completes.
//    var onComplete: ((URL?) -> Void)?
//
//    init(securityScopedBookmarkStore: SecurityScopedBookmarkStore, id: UUID, securityScopedURL: URL) {
//        self.bookmarkStore = securityScopedBookmarkStore
//        self.id = id
//        self.securityScopedURL = securityScopedURL
//        super.init()
//    }
//
//    override func main() {
//        guard let bookmark = SecurityScopedBookmark(id: id, securityScopedURL: securityScopedURL) else {
//            print("Unable to generate security scoped bookmark")
//            DispatchQueue.main.async { [weak self] in
//                self?.onComplete?(nil)
//            }
//            return
//        }
//
//        bookmarkStore.add(bookmark: bookmark)
//
//        guard let actualURL = bookmarkStore.url(for: id) else {
//            print("Unable to retrieve a valid URL for security scoped bookmark")
//            DispatchQueue.main.async { [weak self] in
//                self?.onComplete?(nil)
//            }
//            return
//        }
//
//        outputURL = actualURL
//
//        if let onComplete = onComplete {
//            DispatchQueue.main.async {
//                onComplete(actualURL)
//            }
//        }
//    }
//}
//
//extension SecurityScopedBookmarkOperation: URLProvider {
//    var url: URL? { return outputURL }
//}
