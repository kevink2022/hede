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
public final class TaskCategory: Identifiable, Codable {
    public let id: Key
    public let label: String
    public let description: String?
    public let pauses: [Key]?
}

/// For pausing and delaying tasks when the user is not able to do them, such as housework when on vacation.
public final class TaskPause: Identifiable, Codable {
    public let id: Key
    public let label: String
    public let description: String?
}
