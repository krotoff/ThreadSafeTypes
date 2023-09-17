//
//  ThreadSafeArray.swift
//  
//
//  Created by Andrei Krotov on 17/09/2023.
//

import Foundation

public final class ThreadSafeArray<ObjectType: Equatable> {

    // MARK: - Public properties

    public var value: [ObjectType] {
        get { queue.sync { _value } }
        set(newValue) { queue.async(flags: .barrier) { [weak self] in self?._value = newValue } }
    }

    // MARK: - Private properties

    private var _value: [ObjectType]
    private let queue = DispatchQueue(label: "com.lolaspeak.\(ObjectType.self)", attributes: .concurrent)

    // MARK: - Init

    public init(value: [ObjectType]) {
        _value = value
    }

    // MARK: - Public methods

    public func merge(with array: [ObjectType], isUnique: Bool) {
        var saved = value
        array.forEach {
            if !isUnique || !saved.contains($0) {
                saved.append($0)
            }
        }
        value = saved
    }
}

