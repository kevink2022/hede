//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/5/24.
//

import Foundation
import Observation
import Domain
import Storage
import Models

@Observable
public final class Repository {
    public var basis: DataBasis
    private let transactor: Transactor<UserEventLog, DataBasis>
    
    init(
        transactor: Transactor<UserEventLog, DataBasis> = Transactor<UserEventLog, DataBasis>(
            key: transactorKey
            , basePost: DataBasis()
            , inMemory: true
            , coreCommit: ({ event, basis in BasisResolver(basis).commit(event.assertions) })
            , flatten: ({ events in
                UserEventLog(
                    label: "Previous Events"
                    , assertions:BasisResolver.flatten(events.map({ $0.assertions }))
                )
            })
        )
    ) {
        self.transactor = transactor
        self.basis = .empty
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
    public var taskSources: [AnyTaskSource] { basis.taskSources }
    public var categories: [TaskCategory] { basis.categories }
    public var pauses: [TaskPause] { basis.pauses }
    
    public func tasks(_ ids: [Key]) -> [AnyTask] { ids.compactMap { basis.taskMap[$0] } }
    public func taskSources(_ ids: [Key]) -> [AnyTaskSource] { ids.compactMap { basis.taskSourceMap[$0] } }
    public func categories(_ ids: [Key]) -> [TaskCategory] { ids.compactMap { basis.categoryMap[$0] } }
    public func pauses(_ ids: [Key]) -> [TaskPause] { ids.compactMap { basis.pauseMap[$0] } }
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
}


