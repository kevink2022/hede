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
                self.basis = basis}
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
    
    private static let transactorKey = StorageKey(namespace: nil, key: "transactor", version: 0)
    
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
    
    public func convertSchema() async {
        let failed = { print("Conversion failed, aborting.") }
        
        let assertionConversionScript: (KeySet<Assertion>) -> KeySet<Assertion> = { assertionSet in
            
            assertionSet.reduce(KeySet<Assertion>()) { newSet, assertion in
                
                let convertedAssertion = {
                    switch assertion.assertCode {
                    case .source(let source): Assertion(HedeScheduler(convert: source))
                    case .task(let task): Assertion(HedeTask(convert: task))
                    default: assertion
                    }
                }()
                
                return newSet.updating(with: convertedAssertion)
            }
        }
        
        let eventConversionScript: (UserEventLog) -> UserEventLog = {
            event in event.convert(with: assertionConversionScript)
        }
        
        do {
            let oldTransactions = await transactor.viewTransactions()
            guard !oldTransactions.isEmpty else { failed(); return }
            
            let convertedTransactions = oldTransactions.map { transaction in
                transaction.convert(with: eventConversionScript)
            }
            
            guard oldTransactions.count == convertedTransactions.count else { failed(); return }
            
            let conversionStore = SimpleStore<[DataTransaction<UserEventLog>]>(
                key: TaskRepository.transactorKey
                , cached: false
                , inMemory: false
            )
            
            // Overwrite the transaction history
            try await conversionStore.save(convertedTransactions)
            
            // Reinitialize
            await transactor.reinitialize()
            
        } catch {
            failed()
        }
    }
}
