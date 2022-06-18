//
//  WeakObjectSet.swift
//  Shoebox
//
//  Created by Andy Brown on 30/10/2021.
//

import Foundation

struct WeakObjectSet<T> {
    private var weakArray = WeakArray<T>()

    var count: Int {
        weakArray.count
    }

    mutating func insert(item: T) {
        guard weakArray.contains(object: item) == false else { return }
        weakArray.append(item)
    }

    mutating func remove(item: T) {
        weakArray.remove(object: item)
    }

    mutating func removeAll() {
        weakArray.removeAll()
    }

}

extension WeakObjectSet: Sequence {
    func makeIterator() -> IndexingIterator<[T]> {
        weakArray.makeIterator()
    }
}
