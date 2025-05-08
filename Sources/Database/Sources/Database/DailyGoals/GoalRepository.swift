//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/5/24.
//

import Foundation
import Combine
import Models
import Storage
import Domain
import Assemblages

@Observable
public final class GoalRepository {
    internal var basis: GoalBasis
    private let transactor: Transactor<UserEventLog, GoalBasis>
    private var cancellables: Set<AnyCancellable> = []
    
    internal init( transactor: Transactor<UserEventLog, GoalBasis> ) {
        self.transactor = transactor
        self.basis = .empty
        
        self.transactor.publisher
            .sink { [weak self] basis in
                guard let self = self else { return }
                self.basis = basis
            }
            .store(in: &cancellables)
    }
    
    public convenience init(
        inMemory: Bool = false
    ) {
        self.init(
            transactor: Transactor<UserEventLog, GoalBasis>(
                key: GoalRepository.transactorKey
                , basePost: GoalBasis()
                , inMemory: inMemory
                , coreCommit: ({ event, basis in BasisResolver(basis).commit(event.assertions) })
                , flatten: ({ events in
                    UserEventLog(
                        label: "Previous Events"
                        , assertions: Assertion.flatten(events.map({ $0.assertions }))
                    )
                })
            )
        )
    }
    
    private static let transactorKey = StorageKey(namespace: "goals", key: "transactor", version: 0)
    
    public func save(_ models: [any Savable], message: String? = nil) async {
        let assertions = models.compactMap { Assertion($0) }
        
        let log = UserEventLog(
            label: message ?? "Save"
            , assertions: KeySet().inserting(assertions)
        )
        
        await transactor.commit(transaction: log)
    }
    
    public func delete(_ models: [any Savable], message: String? = nil) async {
        let assertions = models.compactMap { Assertion(DeleteKey($0.id)) }
        
        let log = UserEventLog(
            label: message ?? "Delete"
            , assertions: KeySet().inserting(assertions)
        )
        
        await transactor.commit(transaction: log)
    }
    
    public func getTransactions() async -> [DataTransaction<UserEventLog>] {
        return await transactor.viewTransactions()
    }
    
    public func rollbackTo(after transaction: DataTransaction<UserEventLog>) async {
        await transactor.rollbackTo(after: transaction)
    }
    
    public func rollbackTo(before transaction: DataTransaction<UserEventLog>) async {
        await transactor.rollbackTo(before: transaction)
    }
    
    public var dailyGoals: [DailyGoal] { basis.dailyGoals }
    public func dailyGoals(_ ids: [Key]) -> [DailyGoal] { ids.compactMap { basis.dailyGoalMap[$0] } }

//    public var dailyGoalResults: [DailyGoalResult] { basis.dailyGoalResults }
    public func dailyGoalResults(_ ids: [Key]) -> [DailyGoalResult] { ids.compactMap { basis.dailyGoalResultMap[$0] } }

    public var dailyGoalLists: [DailyGoalList] { basis.dailyGoalLists }
    public func dailyGoalLists(_ ids: [Key]) -> [DailyGoalList] { ids.compactMap { basis.dailyGoalListMap[$0] } }

    public var dailyGoalListSections: [DailyGoalListSection] { basis.dailyGoalListSections }
    public func dailyGoalListSections(_ ids: [Key]) -> [DailyGoalListSection] { ids.compactMap { basis.dailyGoalListSectionMap[$0] } }

    public var routines: [Routine] { basis.routines }
    public func routines(_ ids: [Key]) -> [Routine] { ids.compactMap { basis.routineMap[$0] } }

    public var routineSteps: [RoutineStep] { basis.routineSteps }
    public func routineSteps(_ ids: [Key]) -> [RoutineStep] { ids.compactMap { basis.routineStepMap[$0] } }

    public var routineResults: [RoutineResult] { basis.routineResults }
    public func routineResults(_ ids: [Key]) -> [RoutineResult] { ids.compactMap { basis.routineResultMap[$0] } }

    public var routineStepResults: [RoutineStepResult] { basis.routineStepResults }
    public func routineStepResults(_ ids: [Key]) -> [RoutineStepResult] { ids.compactMap { basis.routineStepResultMap[$0] } }
}
