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

struct WeakObjectSet<T: AnyObject>: Sequence {
    
    var objects: Set<Observer<T>>
    
    init() {
        self.objects = Set<Observer<T>>([])
    }
    
    init(_ object: T) {
        self.objects = Set<Observer<T>>([Observer(object)])
    }
    
    init(_ objects: [T]) {
        self.objects = Set<Observer<T>>(objects.map { Observer($0) })
    }
    
    var allObjects: [T] {
        return objects.compactMap { $0.object }
    }
    
    func contains(_ object: T) -> Bool {
        return self.objects.contains(Observer(object))
    }
    
    mutating func add(_ object: T) {
        if self.contains(object) {
            self.remove(object)
        }
        self.objects.insert(Observer(object))
    }
    
    mutating func add(_ objects: [T]) {
        objects.forEach { self.add($0) }
    }
    
    mutating func remove(_ object: T) {
        self.objects.remove(Observer<T>(object))
    }
    
    mutating func remove(_ objects: [T]) {
        objects.forEach { self.remove($0) }
    }
    
    func makeIterator() -> AnyIterator<T> {
        let objects = self.allObjects
        var index = 0
        return AnyIterator {
            defer { index += 1 }
            return index < objects.count ? objects[index] : nil
        }
    }
}
