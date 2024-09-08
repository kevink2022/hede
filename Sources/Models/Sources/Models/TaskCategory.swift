//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import Foundation

/// For organizing tasks and sources by category, and applying pauses to them.
///
/// Tasks and sources of `TaskTime` type `.task` will by default use the pauses of their source's category.
/// Other types will not use any pauses by default.
///
/// Sources can override their categories pauses with their own, custom pauses.
public final class TaskCategory: Identifiable, Codable, Equatable {
    public let id: Key
    public let label: String
    public let description: String?
    public let pauses: [Key]?
    
    public init(
        id: Key
        , label: String
        , description: String?
        , pauses: [Key]?
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.pauses = pauses
    }
    
    public static func == (lhs: TaskCategory, rhs: TaskCategory) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.pauses == rhs.pauses
    }
    
    public func edit(
        label: String?
        , description: String?
        , pauses: [Key]?
    ) -> TaskCategory {
        TaskCategory(
            id: self.id
            , label: label ?? self.label
            , description: description.null(or: self.description)
            , pauses: pauses.null(or: self.pauses)
        )
    }
}

/// For pausing and delaying tasks when the user is not able to do them, such as housework when on vacation.
public final class TaskPause: Identifiable, Codable, Equatable {
    public let id: Key
    public let label: String
    public let description: String?
    
    public init(
        id: Key
        , label: String
        , description: String?
    ) {
        self.id = id
        self.label = label
        self.description = description
    }
    
    public static func == (lhs: TaskPause, rhs: TaskPause) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed
        && lhs.label == rhs.label
        && lhs.description == rhs.description
    }
    
    public func edit(
        label: String?
        , description: String?
    ) -> TaskPause {
        TaskPause(
            id: self.id
            , label: label ?? self.label
            , description: description.null(or: self.description)
        )
    }
}
