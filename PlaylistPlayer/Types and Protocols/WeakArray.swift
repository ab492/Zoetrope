//
//  NotificationDispatcher.swift
//  Shoebox
//
//  Created by Andy Brown on 30/10/2021.
//
// swiftlint:disable force_cast

import Foundation

private struct WeakBox {
    private weak var _object: AnyObject?

    init(object: AnyObject) {
        _object = object
    }

    var object: AnyObject? {
        _object
    }
}

struct WeakArray<T> {

    private var wrappedItems = [WeakBox]()

    var unwrappedItems: [T] {
        wrappedItems.compactMap { $0.object as? T }
    }

    var count: Int {
        unwrappedItems.count
    }

    // MARK: - Init

    init(_ items: T...) {
        guard let itemsAsAnyObjects = items as [AnyObject]? else {
            fatalError("WeakArray only works with types conforming to AnyObject")
        }
        self.wrappedItems = itemsAsAnyObjects.map { WeakBox(object: $0) }
    }

    init(_ items: [T]) {
        guard let itemsAsAnyObjects = items as [AnyObject]? else {
            fatalError("WeakArray only works with types conforming to AnyObject")
        }
        self.wrappedItems = itemsAsAnyObjects.map { WeakBox(object: $0) }
    }

    mutating func append(_ item: T) {
        removeDeallocatedItems()

        guard let anyObject = item as AnyObject? else {
            fatalError("WeakArray only works with types conforming to AnyObject")
        }

        wrappedItems.append(WeakBox(object: anyObject))
    }

    func contains(object: T) -> Bool {
        contains(where: { ($0 as AnyObject) === (object as AnyObject) })
    }

    mutating func removeAll(where shouldRemove: (T) -> Bool) {
        wrappedItems = wrappedItems
            .compactMap { $0.object }
            .filter { shouldRemove($0 as! T) == false }
            .map { WeakBox(object: $0) }
    }

    mutating func remove(object: T) {
        removeAll(where: { ($0 as AnyObject) === (object as AnyObject) })
    }

    mutating func removeAll() {
        wrappedItems.removeAll()
    }

    private mutating func removeDeallocatedItems() {
        wrappedItems = wrappedItems.filter({ $0.object != nil })
    }
}

// MARK: - ExpressibleByArrayLiteral

extension WeakArray: ExpressibleByArrayLiteral {
    init(arrayLiteral items: T...) {
        guard let itemsAsAnyObjects = items as [AnyObject]? else {
            fatalError("WeakArray only works with types conforming to AnyObject")
        }
        self.wrappedItems = itemsAsAnyObjects.map { WeakBox(object: $0) }
    }
}

// MARK: - Sequence

extension WeakArray: Sequence {
    func makeIterator() -> IndexingIterator<[T]> {
        unwrappedItems.makeIterator()
    }
}

// MARK: - RandomAccessCollection

extension WeakArray: RandomAccessCollection {

    typealias Index = Int
    typealias Element = T

    var startIndex: Index {
        unwrappedItems.startIndex
    }

    var endIndex: Index {
        unwrappedItems.endIndex
    }

    subscript(index: Index) -> Element {
        unwrappedItems[index]
    }

    func index(after i: Index) -> Index {
        unwrappedItems.index(after: i)
    }

    func index(before i: WeakArray<T>.Index) -> WeakArray<T>.Index {
        unwrappedItems.index(before: i)
    }
 }
