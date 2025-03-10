//
//  DailyGoalList.swift
//  Models
//
//  Created by Kevin Kelly on 2/26/25.
//

import Foundation
import Domain

/// A list of daily goals represent a day.
public final class DailyGoalList: Codable, Identifiable, Equatable  {
    public let id: Key
    
    /// The IDs of the sections that this list contains
    public let sectionIds: [Key]
    
    /// The name of the list
    public let label: String
    /// Optional description of the list
    public let description: String?
    /// The weekdays the list will appear on
    public let weekdays: [Weekday]
    /// Whether the list is active or archived
    public let active: Bool
    
    public static func == (lhs: DailyGoalList, rhs: DailyGoalList) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , sectionIds: [Key]
        , label: String
        , description: String?
        , weekdays: [Weekday]
        , active: Bool
    ) {
        self.id = id
        self.sectionIds = sectionIds
        self.label = label
        self.description = description
        self.weekdays = weekdays
        self.active = active
    }
    
    public static func new(
        sections: [DailyGoalListSection]
        , label: String
        , description: String?
        , weekdays: [Weekday]
    ) -> DailyGoalList {
        
        DailyGoalList.init(
            id: .new()
            , sectionIds: sections.map { $0.id }
            , label: label
            , description: description
            , weekdays: weekdays
            , active: true
        )
    }
    
    /*
    public func edit(
        sections: [DailyGoalListSection]? = nil
        , label: String? = nil
        , description: String? = nil
        , weekdays: [Weekday]? = nil
    ) -> DailyGoalList {
        
        DailyGoalList.init(
            id: self.id
            , sectionIds: sections.map { $0.id }
            , label: label
            , description: description
            , weekdays: weekdays
            , active: true
        )
    }
    */
}

/// Daily goal lists are made up of sections that can be copied onto other lists.
public final class DailyGoalListSection: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The IDs of the goals that this section contains
    public let goalIds: [Key]
    
    /// The name of the section
    public let label: String
    /// Optional description of the section
    public let description: String?
    /// Whether the section is active or archived
    public let active: Bool
    
    public static func == (lhs: DailyGoalListSection, rhs: DailyGoalListSection) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , goalIds: [Key]
        , label: String
        , description: String?
        , active: Bool
    ) {
        self.id = id
        self.goalIds = goalIds
        self.label = label
        self.description = description
        self.active = active
    }
    
    public static func new(
        goals: [DailyGoal]
        , label: String
        , description: String?
    ) -> DailyGoalListSection {
        
        DailyGoalListSection(
            id: .new()
            , goalIds: goals.map { $0.id }
            , label: label
            , description: description
            , active: true
        )
    }
}
