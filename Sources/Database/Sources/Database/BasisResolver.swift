//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Assemblages

internal final class BasisResolver<T: Basis> {
    
    private let currentBasis: DataBasis
    
    internal init(_ currentBasis: T) {
        self.currentBasis = currentBasis.basis
    }
    
    /// Commit new models to the basis, adding, updating, and deleting them.
    internal func commit(_ assertionSet: KeySet<Assertion>) -> T {
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
                
                // delete dailyGoal
                
                // delete dailyGoalResult
                
            case .task(let data): 
                newBasis.taskSet.insert(data)
                
            case .source(let data):
                newBasis.taskSourceSet.insert(data)
                
            case .category(let data):
                newBasis.categorySet.insert(data)
                
            case .pause(let data):
                newBasis.pauseSet.insert(data)
            
            case .dailyGoal(_), .dailyGoalResult(_): break
            }
        }
        
        return T(newBasis)
    }
}
