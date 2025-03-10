//
//  Goals+Nullable.swift
//  Models
//
//  Created by Kevin Kelly on 3/2/25.
//

import Foundation
import Domain

/// Whether to make the null values active or now
fileprivate var nullActive = true

/// These prevents circular references
fileprivate let routineNullId = Key.new()
fileprivate let routineStepNullId = Key.new()
fileprivate let routineResultNullId = Key.new()

extension DailyGoal: Nullable {
    public static let null = DailyGoal(
        id: .new()
        , label: "NULL DAILY GOAL"
        , description: "NULL DAILY GOAL"
        , config: .completion(steps: .linear(steps: 1))
        , type: .neutral
        , active: nullActive
    )
}

extension DailyGoalResult: Nullable {
    public static let null = DailyGoalResult(
        id: .new()
        , dailyGoalId: DailyGoal.null.id
        , label: "NULL DAILY GOAL RESULT"
        , result: .completion(steps: .linear(steps: 1), result: 1)
        , date: .now
        , recorded: .now
    )
}

extension DailyGoalList: Nullable {
    public static let null = DailyGoalList(
        id: .new()
        , sectionIds: [DailyGoalListSection.null.id]
        , label: "NULL DAILY GOAL LIST"
        , description: "NULL DAILY GOAL LIST"
        , weekdays: []
        , active: nullActive
    )
}

extension DailyGoalListSection: Nullable {
    public static let null = DailyGoalListSection(
        id: .new()
        , goalIds: [DailyGoal.null.id]
        , label: "NULL DAILY GOAL LIST SECTION"
        , description: "NULL DAILY GOAL LIST SECTION"
        , active: nullActive
    )
}

extension Routine: Nullable {
    public static let null = Routine(
        id: routineNullId
        , stepIds: [routineStepNullId]
        , label: "NULL ROUTINE"
        , description: "NULL ROUTINE"
    )
}

extension RoutineStep: Nullable {
    public static let null = RoutineStep(
        id: .new()
        , routineId: routineNullId
        , label: "NULL ROUTINE STEP"
        , description: "NULL ROUTINE STEP"
        , index: 0
        , timer: .up
    )
}

extension RoutineResult: Nullable {
    public static let null = RoutineResult(
        id: routineResultNullId
        , routineId: routineNullId
        , stepResultIds: [RoutineStepResult.null.id]
        , label: "NULL ROUTINE RESULT"
        , date: .now
        , recorded: .now
    )
}

extension RoutineStepResult: Nullable {
    public static let null = RoutineStepResult(
        id: .new()
        , routineStepId: routineStepNullId
        , routineResultId: routineResultNullId
        , label: "NULL ROUTINE STEP RESULT"
        , recorded: .now
        , index: 0
    )
}
