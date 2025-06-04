//
//  Untitled.swift
//  Database
//
//  Created by Kevin Kelly on 2/25/25.
//

import Foundation
import Models
import Assemblages
import Domain

public final class TaskBasis: Basis {
    internal let basis: DataBasis
    
    public var hedeTasks: [HedeTask] { basis.hedeTaskSet.values }
    public var hedeTaskMap: [Key: HedeTask] { basis.hedeTaskSet.dictionary }
    
    public var hedeSchedulers: [HedeScheduler] { basis.hedeSchedulerSet.values }
    public var hedeSchedulerMap: [Key: HedeScheduler]  { basis.hedeSchedulerSet.dictionary }
    
    public var hedeTags: [HedeTag] { basis.hedeTagSet.values }
    public var hedeTagsMap: [Key: HedeTag] { basis.hedeTagSet.dictionary }
    
    internal init(_ basis: DataBasis) { self.basis = basis }
    internal init(_ basis: MutableBasis) { self.basis = DataBasis(basis) }
    public init() { self.basis = .empty }
    
    internal static var empty = TaskBasis()
}
