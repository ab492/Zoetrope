//
//  URL-SecurityScoped.swift
//  Quickfire
//
//  Created by Andy Brown on 29/12/2020.
//

import Foundation

extension URL {
    func accessSecurityScopedResource<Value>(_ accessor: (URL) throws -> Value) rethrows -> Value {
        let didStartAccessing = startAccessingSecurityScopedResource()

        defer {
            if didStartAccessing { stopAccessingSecurityScopedResource() }
        }
        return try accessor(self)
    }
}
