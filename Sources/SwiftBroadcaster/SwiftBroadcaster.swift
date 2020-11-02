//
//  SwiftBroadcaster.swift
//  SwiftBroadcaster
//
//  Created by Carlos on 11/2/20.
//  Copyright © 2020 SwiftBroadcaster. All rights reserved.
//

import Foundation

public class Broadcaster {
    
    fileprivate static var observersDic = [String: Any]()
    
    fileprivate static let notificationQueue = DispatchQueue(label: "com.swift.notification.center.dispatch.queue",
                                                             attributes: .concurrent)

    public static func register<T>(_ protocolType: T.Type, observer: T) {
        let key = "\(protocolType)"
        safeSet(key: key, object: observer as AnyObject)
    }
    
    public static func unregister<T>(_ protocolType: T.Type, observer: T) {
        let key = "\(protocolType)"
        safeRemove(key: key, object: observer as AnyObject)
    }
    
    /// Remove all observers which comform to the protocol
    public static func unregister<T>(_ protocolType: T.Type) {
        let key = "\(protocolType)"
        safeRemove(key: key)
    }
    
    public static func notify<T>(_ protocolType: T.Type, block: (T) -> Void ) {
        
        let key = "\(protocolType)"
        guard let objectSet = safeGetObjectSet(key: key) else {
            return
        }
        
        for observer in objectSet {
            if let observer = observer as? T {
                block(observer)
            }
        }
    }
}

private extension Broadcaster {
    
    static func safeSet(key: String, object: AnyObject) {
        notificationQueue.async(flags: .barrier) {
            if var set = observersDic[key] as? ObserverSet<AnyObject> {
                set.add(object)
                observersDic[key] = set
            } else {
                observersDic[key] = ObserverSet(object)
            }
        }
    }
    
    static func safeRemove(key: String, object: AnyObject) {
        notificationQueue.async(flags: .barrier) {
            if var set = observersDic[key] as? ObserverSet<AnyObject> {
                set.remove(object)
                observersDic[key] = set
            }
        }
    }
    
    static func safeRemove(key: String) {
        notificationQueue.async(flags: .barrier) {
            observersDic.removeValue(forKey: key)
        }
    }
    
    static func safeGetObjectSet(key: String) -> ObserverSet<AnyObject>? {
        var objectSet: ObserverSet<AnyObject>?
        notificationQueue.sync {
            objectSet = observersDic[key] as? ObserverSet<AnyObject>
        }
        return objectSet
    }
    
}
