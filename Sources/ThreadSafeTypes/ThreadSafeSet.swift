//
//  ThreadSafeSet.swift
//  
//
//  Created by Andrei Krotov on 17/09/2023.
//

import Foundation

public final class ThreadSafeSet<ObjectType: Hashable> {

    // MARK: - Public properties

    public var value: Set<ObjectType> {
        var result = Set<ObjectType>()
        dispatchQueue.sync { [weak self] in
            result = self?.threadUnsafeSet ?? result
        }
        return result
    }

    // MARK: - Private properties

    private var threadUnsafeSet = Set<ObjectType>()
    private let dispatchQueue = DispatchQueue(label: "com.thread-safe-set.\(ObjectType.self)", attributes: .concurrent)

    // MARK: - Public methods

    public func insert(_ object: ObjectType) {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.threadUnsafeSet.insert(object)
        }
    }

    public func remove(_ object: ObjectType) {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.threadUnsafeSet.remove(object)
        }
    }
}
