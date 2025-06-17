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

extension IndexSortedKeySet where Element: BasisSortIndex {
    internal init(
        set: KeySet<Element> = KeySet<Element>()
    ) {
        self.init(
            lessThan: Element.lessThan
            /*, equalTo: Element.equalTo*/
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

internal protocol BasisGroupIndex {
    associatedtype IndexType
    static func index(_ element: Self) -> IndexType
}

extension IndexGroupedKeySet where Element: BasisGroupIndex, Index == Element.IndexType {
    internal init() {
        self.init(index: Element.index)
    }
}

internal protocol BasisSortedGroupIndex: Identifiable {
    associatedtype IndexType: Hashable
    static func index(_ element: Self) -> IndexType
    static func lessThan(lhs: Self, rhs: Self) -> Bool
}

extension GroupedIndex where Element: BasisSortedGroupIndex, Index == Element.IndexType, Group == SortedSetIndex<Element> {
    
    internal init() {
        self.init(
            index: Element.index
            , emptyGroup: { SortedSetIndex<Element>(
                lessThan: Element.lessThan
            ) }
        )
    }
}

extension IndexedKeySet where Element: BasisSortedGroupIndex, Index == GroupedIndex<Element, Element.IndexType, SortedSetIndex<Element>> {
    
    internal init() {
        self.init(emptyIndex: { Element.BasisIndex() })
    }
}

extension BasisSortedGroupIndex {
    typealias BasisIndex = GroupedIndex<Self, IndexType, SortedSetIndex<Self>>
    typealias BasisSet = IndexedKeySet<Self, BasisIndex>
}
