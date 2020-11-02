//
//  WeakObject.swift
//  SwiftBroadcaster
//
//  Created by Carlos on 11/2/20.
//  Copyright © 2020 SwiftBroadcaster. All rights reserved.
//

import Foundation

struct Observer<T: AnyObject>: Equatable, Hashable {
    
    private let identifier: ObjectIdentifier
    
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
        self.identifier = ObjectIdentifier(object)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    static func == (lhs: Observer<T>, rhs: Observer<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
