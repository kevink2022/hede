//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/3/24.
//

import Foundation
import Models
import Assemblages
import Domain

public final class GoalBasis: Basis {
    internal let basis: DataBasis
    
    public var dailyGoals: [DailyGoal] { basis.dailyGoalSet.values }
    public var dailyGoalMap: [Key: DailyGoal] { basis.dailyGoalSet.dictionary }

//    public var dailyGoalResults: [Date: KeySet<DailyGoalResult>] { basis.dailyGoalResultSet }
    public var dailyGoalResultMap: [Key: DailyGoalResult] { basis.dailyGoalResultSet.dictionary }

    public var dailyGoalLists: [DailyGoalList] { basis.dailyGoalListSet.values }
    public var dailyGoalListMap: [Key: DailyGoalList] { basis.dailyGoalListSet.dictionary }

    public var dailyGoalListSections: [DailyGoalListSection] { basis.dailyGoalListSectionSet.values }
    public var dailyGoalListSectionMap: [Key: DailyGoalListSection] { basis.dailyGoalListSectionSet.dictionary }

    public var routines: [Routine] { basis.routineSet.values }
    public var routineMap: [Key: Routine] { basis.routineSet.dictionary }

    public var routineSteps: [RoutineStep] { basis.routineStepSet.values }
    public var routineStepMap: [Key: RoutineStep] { basis.routineStepSet.dictionary }

    public var routineResults: [RoutineResult] { basis.routineResultSet.values }
    public var routineResultMap: [Key: RoutineResult] { basis.routineResultSet.dictionary }

    public var routineStepResults: [RoutineStepResult] { basis.routineStepResultSet.values }
    public var routineStepResultMap: [Key: RoutineStepResult] { basis.routineStepResultSet.dictionary }

    internal init(_ basis: DataBasis) {
        self.basis = basis
    }
    
    internal init(_ basis: MutableBasis) {
        self.basis = DataBasis(basis)
    }
    
    public init() {
        self.basis = .empty
    }
    
    internal static var empty = GoalBasis()
}
