//
//  ThreadSafeValue.swift
//  
//
//  Created by Andrei Krotov on 17/09/2023.
//

import Foundation

public final class ThreadSafeValue<ObjectType> {

    // MARK: - Public properties

    public var value: ObjectType {
        get { queue.sync { _value } }
        set(newValue) { queue.async(flags: .barrier) { [weak self] in self?._value = newValue } }
    }

    // MARK: - Private properties

    private var _value: ObjectType
    private let queue = DispatchQueue(label: "com.lolaspeak.\(ObjectType.self)", attributes: .concurrent)

    // MARK: - Init

    public init(value: ObjectType) {
        _value = value
    }
}
