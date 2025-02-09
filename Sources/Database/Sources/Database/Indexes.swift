//
//  Indexes.swift
//  Database
//
//  Created by Kevin Kelly on 12/21/24.
//

import Foundation
import Models
import Assemblages

internal protocol BasisSortIndex {
    static func lessThan(lhs: Self, rhs: Self) -> Bool
    static func equalTo(lhs: Self, rhs: Self) -> Bool
}

internal protocol StringSortedIndex: BasisSortIndex {
    var label: String { get }
}

extension StringSortedIndex {
    internal static func lessThan(lhs: Self, rhs: Self) -> Bool {
        lhs.label.compare(rhs.label, options: .caseInsensitive) == .orderedAscending
    }
    internal static func equalTo(lhs: Self, rhs: Self) -> Bool { lhs.label == rhs.label }
}

extension AnyTask: BasisSortIndex {
    internal static func lessThan(lhs: AnyTask, rhs: AnyTask) -> Bool { lhs.sortDate < rhs.sortDate }
    internal static func equalTo(lhs: AnyTask, rhs: AnyTask) -> Bool { lhs.sortDate == rhs.sortDate }
}

extension AnyTaskSource: StringSortedIndex { }
extension TaskCategory: StringSortedIndex { }
extension TaskPause: StringSortedIndex { }

extension ExternallySortedKeySet where Element == AnyTask {
    internal init(
        set: KeySet<AnyTask> = KeySet<AnyTask>()
    ) {
        self.init(
            lessThan: AnyTask.lessThan
            , equalTo: AnyTask.equalTo
            , set: set
        )
    }
}

extension ExternallySortedKeySet where Element == AnyTaskSource {
    internal init(
        set: KeySet<AnyTaskSource> = KeySet<AnyTaskSource>()
    ) {
        self.init(
            lessThan: AnyTaskSource.lessThan
            , equalTo: AnyTaskSource.equalTo
            , set: set
        )
    }
}

extension ExternallySortedKeySet where Element == TaskCategory {
    internal init(
        set: KeySet<TaskCategory> = KeySet<TaskCategory>()
    ) {
        self.init(
            lessThan: TaskCategory.lessThan
            , equalTo: TaskCategory.equalTo
            , set: set
        )
    }
}

extension ExternallySortedKeySet where Element == TaskPause {
    internal init(
        set: KeySet<TaskPause> = KeySet<TaskPause>()
    ) {
        self.init(
            lessThan: TaskPause.lessThan
            , equalTo: TaskPause.equalTo
            , set: set
        )
    }
}
