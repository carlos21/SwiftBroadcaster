//
//  ObserverSet.swift
//  SwiftBroadcaster
//
//  Created by Carlos Duclos on 11/2/20.
//  Copyright © 2020 SwiftBroadcaster. All rights reserved.
//

import Foundation

struct ObserverSet<T: AnyObject>: Sequence {
    
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
