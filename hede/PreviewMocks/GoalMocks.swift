//
//  GoalMocks.swift
//  hede
//
//  Created by Kevin Kelly on 3/3/25.
//

import Foundation
import Models
import Assemblages

extension PreviewMocks {
    static let cleanApartment = DailyGoal.new(
        label: "Apartment Clean"
        , description:
        """
        Whether or not the apartment is clean at the end of the day.
        
        0.5 - Not a total mess.
        1 - Clean enough someone could visit.
        """
        , config: .completion(steps: .linear(steps: 2))
        , type: .positive
    )
    
    static let screenTime = DailyGoal.new(
        label: "Screen Time"
        , description:
        """
        Screen time on phone/tablet
        
        2hr - Ideal Goal
        4hr - Should be the maximum.
        
        Music doesn't count. Work doesn't count.
        """
        , config: .count(goals: SortedSet<Int>(contentsOf: [240, 120]))
        , type: .negative
    )
    
    static let exercise = DailyGoal.new(
        label: "Exercise"
        , description:
        """
        Whether or not I exercised that day.
        
        0.5 - Something small, walk, some push-ups, etc.
        1 - 30m dedicated to exercise.
        """
        , config: .completion(steps: .linear(steps: 2))
        , type: .positive
    )
    
    static let devSprints = DailyGoal.new(
        label: "Dev Sprints"
        , description:
        """
        The number of 30m focused development 'sprints' I do.
        
        2 - 1hr, the minimum.
        4 - 2hr, specifically on free weekends.
        """
        , config: .count(goals: SortedSet<Int>(contentsOf: [2, 4]))
        , type: .positive
    )
    
    static let sleep = DailyGoal.new(
        label: "Sleep"
        , description:
        """
        The number of hours of sleep I get. 
        
        8 - Ideal goal.
        7 - What I aim for.
        6 - Should be the minimum.
        """
        , config: .number(goals: SortedSet<Double>(contentsOf: [6, 7, 8]))
        , type: .positive
    )
    
    static let goals: [DailyGoal] = [
        cleanApartment
        , exercise
        , devSprints
        , screenTime
        , sleep
    ]
    
    static let habits = DailyGoalListSection.new(
        goals: goals
        , label: "Daily Habits"
        , description: nil
    )
    
    static let sections: [DailyGoalListSection] = [
        habits
    ]
    
//    static let lists = DailyGoalList.new(
//        sections: sections
//        , label: <#T##String#>
//        , description: <#T##String?#>
//        , weekdays: <#T##[Weekday]#>
//    )
}
