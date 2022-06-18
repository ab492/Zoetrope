//
//  NotificationDispatcher.swift
//  Shoebox
//
//  Created by Andy Brown on 01/11/2021.
//

import Foundation

private class ObserverStore<T> {
    private(set) var observers = WeakObjectSet<T>()

    func add(observer: T) {
        observers.insert(item: observer)
    }
}

final class NotificationDispatcher {
    static let shared = NotificationDispatcher()

    var stores = [String: Any]()

    func register<T>(observer: AnyObject, as observerType: T.Type) {
        guard let observer = observer as? T else {
            return
        }

        let key = String(describing: observerType)

        let store: ObserverStore<T>

        if let existingStore = stores[key] as? ObserverStore<T> {
            store = existingStore
        } else {
            store = ObserverStore<T>()
            stores[key] = store
        }

        store.add(observer: observer)
    }

    public func notify<T>(_ observerType: T.Type, handler: (T) -> Void) {
        let key = String(describing: observerType)

        guard let store = stores[key] as? ObserverStore<T> else {
            return
        }

        store.observers.forEach(handler)
    }
}
