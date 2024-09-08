//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Storage

/// Public dummy protocol of what can be saved in the database. Not to be added to anything.
public protocol Savable: Codable, Identifiable, Equatable {
    var id: Key { get }
}

/// Internal implementation of Savable.
internal protocol Assertable: Savable {
    var assertCode: AssertionCode { get }
}

internal enum AssertionCode: Codable, Equatable {
    case delete(DeleteKey)
    
    case task(AnyTask)
    case source(AnyTaskSource)
    case category(TaskCategory)
    case pause(TaskPause)
}

internal final class DeleteKey: Assertable {
   
    internal let id: Key
    internal var assertCode: AssertionCode { .delete(self) }
    
    init(_ id: Key) {
        self.id = id
    }
    
    static func == (lhs: DeleteKey, rhs: DeleteKey) -> Bool {
        lhs.id == rhs.id
    }
}

internal final class Assertion: Assertable {
    static func == (lhs: Assertion, rhs: Assertion) -> Bool {
        lhs.assertCode == rhs.assertCode
    }
    
    internal let data: any Assertable
    internal var assertCode: AssertionCode { data.assertCode }
    internal var id: Key { data.id }
    
    init(_ data: any Assertable) {
        self.data = data
    }
    
    init(_ data: any Savable) {
        self.data = data as! any Assertable
    }
}

extension AnyTask: Assertable {
    var assertCode: AssertionCode { .task(self) }
}

extension AnyTaskSource: Assertable {
    var assertCode: AssertionCode { .source(self) }
}

extension TaskCategory: Assertable {
    var assertCode: AssertionCode { .category(self) }
}

extension TaskPause: Assertable {
    var assertCode: AssertionCode { .pause(self) }
}

extension Assertion {
    internal convenience init(code: AssertionCode) {
        switch code {
        case .delete(let deleteKey): self.init(deleteKey)
        case .task(let anyTask): self.init(anyTask)
        case .source(let anyTaskSource): self.init(anyTaskSource)
        case .category(let taskCategory): self.init(taskCategory)
        case .pause(let taskPause): self.init(taskPause)
        }
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assertCode
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data.assertCode, forKey: .assertCode)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(AssertionCode.self, forKey: .assertCode)
        self.init(code: code)
    }
}







