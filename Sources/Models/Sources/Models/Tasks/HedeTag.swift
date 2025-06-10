//
//  HedeTag.swift
//  Models
//
//  Created by Kevin Kelly on 5/31/25.
//

import Foundation
import Domain
import Assemblages

public protocol TagHierarchy: Identifiable {
    var children: [Self] { get }
}

extension TagHierarchy {
    public func allTags() -> KeySet<Self> {
        var tags: KeySet<Self> = [self]
        for child in children { tags.update(with: child.allTags().values) }
        return tags
    }
    
    public func allTags() -> [Self] { self.allTags().values }
}

public final class HedeTag: Codable, TagHierarchy, Identifiable {
   
    public let id: Key

    public let children: [HedeTag]
    public var label: String { "#\(data)" }
    
    private let data: String
    
    internal init(
        id: Key
        , label: String
        , children: [HedeTag] = []
    ) {
        self.id = id
        self.data = label
        self.children = children
    }
}

extension HedeTag {
    public static func from(_ string: String) -> HedeTag? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        
        for char in trimmed.unicodeScalars {
            if excludedCharacters.contains(char) {
                return nil
            }
        }
        
        return self.init(id: .new(), label: trimmed, children: [])
    }
    
    private static let excludedCharacters = CharacterSet(charactersIn: "!@#$%^&*()+=[]{}|\\;:'\",.<>/?`~")
    private static let tagCharset: Set<Character> = ["#"]
}

// MARK: - Conformance

extension HedeTag: Equatable {
    public static func == (lhs: HedeTag, rhs: HedeTag) -> Bool {
        lhs.id == rhs.id
        && lhs.data == rhs.data
    }
}

extension HedeTag: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension HedeTag: Nullable {
    public static let null = HedeTag(id: .new(), label: "NULL TAG", children: [])
}
