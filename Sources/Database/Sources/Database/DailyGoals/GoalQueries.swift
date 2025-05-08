//
//  GoalQueries.swift
//  Database
//
//  Created by Kevin Kelly on 3/2/25.
//

import Foundation
import Models

fileprivate let goalRepo = Repository.system.goals

extension DailyGoal {
    /*public var dailyGoalResults: [DailyGoalResult] { goalRepo.basis.basis.dailyGoalResultSet.dictionary.values.filter { $0.dailyGoalId == self.id } } this would be better as another group. */
    public var sections: [DailyGoalListSection] { goalRepo.dailyGoalListSections.filter { $0.goalIds.contains(self.id) } }
    public var lists: [DailyGoalList] { goalRepo.dailyGoalLists.filter { $0.dailyGoals.map({ $0.id } ).contains(self.id) } }
    
    public func result(on date: Date) -> DailyGoalResult? {
        guard let results = goalRepo.basis.basis.dailyGoalResultSet[date]?.values else { return nil }
        return results.first(where: { $0.dailyGoalId == self.id })
    }
}

extension DailyGoalResult {
    public var dailyGoal: DailyGoal { goalRepo.dailyGoals([self.dailyGoalId]).first ?? DailyGoal.null }
}

extension DailyGoalList {
    public var sections: [DailyGoalListSection] { goalRepo.dailyGoalListSections(self.sectionIds) }
    public var dailyGoals: [DailyGoal] { sections.reduce([DailyGoal]()) { goals, section  in goals + section.dailyGoals } }
}

extension DailyGoalListSection {
    public var dailyGoals: [DailyGoal] { goalRepo.dailyGoals(self.goalIds) }
    public var lists: [DailyGoalList] { goalRepo.dailyGoalLists.filter { $0.sectionIds.contains(self.id) } }
}

extension Routine {
    public var routineSteps: [RoutineStep] { goalRepo.routineSteps.filter { $0.routineId == self.id } }
    public var results: [RoutineResult] { goalRepo.routineResults.filter { $0.routineId == self.id }}
}

extension RoutineStep {
    public var routine: Routine { goalRepo.routines([self.routineId]).first ?? .null }
    public var stepResults: [RoutineStepResult] { goalRepo.routineStepResults.filter { $0.routineStepId == self.id } }
    public var results: [RoutineResult] { self.routine.results }
}

extension RoutineResult {
    public var routine: Routine { goalRepo.routines([self.routineId]).first ?? .null }
    public var stepResults: [RoutineStep] { goalRepo.routineSteps(self.stepResultIds) }
}

