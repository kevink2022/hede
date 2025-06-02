//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/5/24.
//

import Foundation
import Observation
import Assemblages
import Storage
import Models
import Combine
import Domain


@Observable
public final class Repository {
    public let tasks: TaskRepository
    public let goals: GoalRepository
    
    public typealias Tasks = TaskRepository
    public typealias Goals = GoalRepository
    
    public init(
        inMemory: Bool = false
    ) {
        self.tasks = TaskRepository(inMemory: inMemory)
        self.goals = GoalRepository(inMemory: inMemory)
    }
    
    public static let system = disc
    public static let disc = Repository()
    public static let inMemory = Repository(inMemory: true)
}

public final class UserEventLog: Codable {
    public let label: String
    internal let assertions: KeySet<Assertion>

    public var changes: [any Savable] { assertions.values.compactMap { $0 as any Savable } }
    
    internal init(
        label: String
        , assertions: KeySet<Assertion>
    ) {
        self.label = label
        self.assertions = assertions
    }
    
    /// Convert Assertions to a new schema while retianing the ID.
    internal func convert(with conversionScript: (KeySet<Assertion>) -> KeySet<Assertion>) -> UserEventLog {
        .init(
            label: self.label
            , assertions: conversionScript(self.assertions)
        )
    }
}





/*
protocol SystemRepository {
    associatedtype TypeBasis = any Basis
    var basis: TypeBasis { get }
    var transactor: Transactor<UserEventLog, TypeBasis> { get }
    var cancellables: Set<AnyCancellable> { get }
    static var transactorKey: StorageKey { get }
}

extension SystemRepository {
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
    
//    init( transactor: Transactor<UserEventLog, TypeBasis> ) {
//        self.transactor = transactor
//        self.basis = .empty
//        
//        self.transactor.publisher
//            .sink { [weak self] basis in
//                guard let self = self else { return }
//                self.basis = basis
//                
//            }
//            .store(in: &cancellables)
//    }
//    
//    init(
//        inMemory: Bool = false
//    ) {
//        self.init(
//            transactor: Transactor<UserEventLog, TypeBasis>(
//                key: Self.transactorKey
//                , basePost: TypeBasis()
//                , inMemory: inMemory
//                , coreCommit: ({ event, basis in BasisResolver(basis).commit(event.assertions) })
//                , flatten: ({ events in
//                    UserEventLog(
//                        label: "Previous Events"
//                        , assertions: Assertion.flatten(events.map({ $0.assertions }))
//                    )
//                })
//            )
//        )
//    }
    
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
*/
