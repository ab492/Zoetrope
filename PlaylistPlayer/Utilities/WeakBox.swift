//
//  WeakBox.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 05/03/2021.
//

import Foundation

//https://forums.swift.org/t/using-class-constrained-protocol-as-anyobject/13988
struct WeakBox<T> {
    private weak var _value: AnyObject?

    var value: T?   {
        _value as? T
    }

    init(_ value: T) {
        self._value = value as AnyObject
    }
}
