//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Domain

public final class BasisResolver {
    
    private let currentBasis: DataBasis
    
    public init(_ currentBasis: DataBasis) {
        self.currentBasis = currentBasis
    }
    
    /// Commit new models to the basis, adding, updating, and deleting them.
    internal func commit(_ assertionSet: KeySet<Assertion>) -> DataBasis {
        var newBasis = MutableBasis(currentBasis)
        
        assertionSet.forEach { assertion in
            switch assertion.assertCode {
            case .delete(let data):
                if let task = newBasis.taskMap[data.id] {
                    newBasis.taskMap[task.id] = nil
                    newBasis.taskSet.remove(task)
                }
                
                if let source = newBasis.taskSourceMap[data.id] {
                    newBasis.taskSourceMap[source.id] = nil
                    newBasis.taskSourceSet.remove(source)
                }
                
                if let category = newBasis.categoryMap[data.id] {
                    newBasis.categoryMap[category.id] = nil
                    newBasis.categorySet.remove(category)
                }
                
                if let pause = newBasis.pauseMap[data.id] {
                    newBasis.pauseMap[pause.id] = nil
                    newBasis.pauseSet.remove(pause)
                }
                
            case .task(let data): 
                newBasis.taskSet.insert(data)
                newBasis.taskMap[data.id] = data
                
            case .source(let data):
                newBasis.taskSourceSet.insert(data)
                newBasis.taskSourceMap[data.id] = data
                
            case .category(let data):
                newBasis.categorySet.insert(data)
                newBasis.categoryMap[data.id] = data
                
            case .pause(let data):
                newBasis.pauseSet.insert(data)
                newBasis.pauseMap[data.id] = data
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
