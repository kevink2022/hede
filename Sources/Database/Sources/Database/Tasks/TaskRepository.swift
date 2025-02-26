//
//  TaskRepository.swift
//  Database
//
//  Created by Kevin Kelly on 2/25/25.
//
import Foundation
import Observation
import Assemblages
import Storage
import Models
import Combine
import Domain

@Observable
public final class TaskRepository {
    internal var basis: TaskBasis
    private let transactor: Transactor<UserEventLog, TaskBasis>
    private var cancellables: Set<AnyCancellable> = []
    
    internal init( transactor: Transactor<UserEventLog, TaskBasis> ) {
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
            transactor: Transactor<UserEventLog, TaskBasis>(
                key: TaskRepository.transactorKey
                , basePost: TaskBasis()
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
    
    private static let transactorKey = StorageKey(namespace: "repository", key: "transactor", version: 0)
    
    public func save(_ models: [any Savable], message: String? = nil) async {
        let assertions = models.compactMap { Assertion($0) }
        
        let log = UserEventLog(
            label: message ?? "Save"
            , assertions: KeySet().inserting(contentsOf: assertions)
        )
        
        await transactor.commit(transaction: log)
    }
    
    public func delete(_ models: [any Savable], message: String? = nil) async {
        let assertions = models.compactMap { Assertion(DeleteKey($0.id)) }
        
        let log = UserEventLog(
            label: message ?? "Delete"
            , assertions: KeySet().inserting(contentsOf: assertions)
        )
        
        await transactor.commit(transaction: log)
    }
    
    // TODO: Need to verify this updates when the basis changes, I'd think the vars do, but I'm certain the funcs dont.
    public var tasks: [AnyTask] { basis.tasks }
    public var openTasks: [AnyTask] { basis.tasks.filter { $0.isOpen } }
    public var taskSources: [AnyTaskSource] { basis.taskSources }
    public var categories: [TaskCategory] { basis.categories }
    public var pauses: [TaskPause] { basis.pauses }
    
    public func tasks(_ ids: [Key]) -> [AnyTask] { ids.compactMap { basis.taskMap[$0] } }
    public func taskSources(_ ids: [Key]) -> [AnyTaskSource] { ids.compactMap { basis.taskSourceMap[$0] } }
    public func categories(_ ids: [Key]) -> [TaskCategory] { ids.compactMap { basis.categoryMap[$0] } }
    public func pauses(_ ids: [Key]) -> [TaskPause] { ids.compactMap { basis.pauseMap[$0] } }
    
    public var toDoTasks: [ToDoSource] { basis.taskSources.compactMap { $0.data as? ToDoSource } }
    public var recurringTasks: [RecurringSource] { basis.taskSources.compactMap { $0.data as? RecurringSource } }
    
    public var toDoSources: [ToDoSource] { basis.taskSources.compactMap { $0.data as? ToDoSource } }
    public var recurringSources: [RecurringSource] { basis.taskSources.compactMap { $0.data as? RecurringSource } }
}

/// Transactions
extension TaskRepository {
    public func getTransactions() async -> [DataTransaction<UserEventLog>] {
        return await transactor.viewTransactions()
    }
    
    public func rollbackTo(after transaction: DataTransaction<UserEventLog>) async {
        await transactor.rollbackTo(after: transaction)
    }
    
    public func rollbackTo(before transaction: DataTransaction<UserEventLog>) async {
        await transactor.rollbackTo(before: transaction)
    }
}

extension TaskRepository {
    public typealias AnyTaskByDate = [(key: String, tasks: [AnyTask])]
    public var tasksByDate: AnyTaskByDate { tasks.groupByDate() }
    public var openTasksByDate: AnyTaskByDate { openTasks.groupByDate() }
}

