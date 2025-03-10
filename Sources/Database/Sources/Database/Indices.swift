//
//  Indices.swift
//  Database
//
//  Created by Kevin Kelly on 2/25/25.
//

import Foundation
import Assemblages

internal protocol BasisSortIndex {
    static func lessThan(lhs: Self, rhs: Self) -> Bool
    static func equalTo(lhs: Self, rhs: Self) -> Bool
}

extension ExternallySortedKeySet where Element: BasisSortIndex {
    internal init(
        set: KeySet<Element> = KeySet<Element>()
    ) {
        self.init(
            lessThan: Element.lessThan
            , equalTo: Element.equalTo
            , set: set
        )
    }
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

internal protocol DateSortedIndex: BasisSortIndex {
    var sortDate: Date { get }
}

extension DateSortedIndex {
    internal static func lessThan(lhs: Self, rhs: Self) -> Bool { lhs.sortDate < rhs.sortDate }
    internal static func equalTo(lhs: Self, rhs: Self) -> Bool { lhs.sortDate == rhs.sortDate }
}


