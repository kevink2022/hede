//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Assemblages

public final class BasisResolver {
    
    private let currentBasis: DataBasis
    
    public init(_ currentBasis: DataBasis) {
        self.currentBasis = currentBasis
    }
    
    /// Commit new models to the basis, adding, updating, and deleting them.
    internal func commit(_ assertionSet: KeySet<Assertion>) -> DataBasis {
        let newBasis = MutableBasis(currentBasis)
        
        assertionSet.forEach { assertion in
            switch assertion.assertCode {
            case .delete(let data):
                if let task = newBasis.taskSet[data.id] {
                    newBasis.taskSet.remove(task)
                }
                
                if let source = newBasis.taskSourceSet[data.id] {
                    newBasis.taskSourceSet.remove(source)
                }
                
                if let category = newBasis.categorySet[data.id] {
                    newBasis.categorySet.remove(category)
                }
                
                if let pause = newBasis.pauseSet[data.id] {
                    newBasis.pauseSet.remove(pause)
                }
                
            case .task(let data): 
                newBasis.taskSet.insert(data)
                
            case .source(let data):
                newBasis.taskSourceSet.insert(data)
                
            case .category(let data):
                newBasis.categorySet.insert(data)
                
            case .pause(let data):
                newBasis.pauseSet.insert(data)
            }
        }
        
        return DataBasis(newBasis)
    }
    
    /// Flatten an array of assertion keysets into a single one. Earlier indexes represent earlier assertions
    internal static func flatten(_ assertionSets: [KeySet<Assertion>]) -> KeySet<Assertion> {
        let count = assertionSets.count
        guard count != 0 else { return KeySet() }
        if count == 1 { return assertionSets.first! }
        
        let middle = count/2
        
        let older = flatten(Array(assertionSets.prefix(middle)))
        let newer = flatten(Array(assertionSets.suffix(from: middle)))
    
        return union(older: older, newer: newer)
    }
    
    /// Combine two key sets of assertion.
    private static func union(older: KeySet<Assertion>, newer: KeySet<Assertion>) -> KeySet<Assertion> {
        
        var merged = KeySet<Assertion>()
        
        older.forEach { olderAssertion in
            if let newerAssertion = newer[olderAssertion] {
                merged.insert(newerAssertion)
            } else {
                merged.insert(olderAssertion)
            }
        }
        
        newer.forEach { rightAssertion in
            if !merged.contains(rightAssertion) {
                merged.insert(rightAssertion)
            }
        }
        
        return merged
    }
}
