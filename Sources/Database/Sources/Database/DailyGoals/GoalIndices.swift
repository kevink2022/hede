//
//  Indexes.swift
//  Database
//
//  Created by Kevin Kelly on 12/21/24.
//

import Foundation
import Models
import Assemblages

extension DailyGoal: StringSortedIndex { }
//extension DailyGoalResult: DateSortedIndex { var sortDate: Date {self.date} }
extension DailyGoalList: StringSortedIndex { }
extension DailyGoalListSection: StringSortedIndex { }
extension Routine: StringSortedIndex { }
extension RoutineStep: StringSortedIndex { }
extension RoutineResult: DateSortedIndex { var sortDate: Date {self.date} }
extension RoutineStepResult: DateSortedIndex { var sortDate: Date {self.recorded} }

extension DailyGoalResult: BasisGroupIndex {
    typealias IndexType = Date
    static func index(_ element: DailyGoalResult) -> Date { element.date }
}

