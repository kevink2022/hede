//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/7/24.
//

import XCTest
@testable import Database
import Domain
import Models

private typealias T = TestValues

final class BasisResolverTests: XCTestCase {
    
    func testCommit() throws {
        
        let assertionSet = KeySet<Assertion>().inserting(contentsOf: T.testAssertions)
        
        // Add to empty
        let basis_1 = BasisResolver(DataBasis.empty).commit(assertionSet)
        
        XCTAssertEqual(1, basis_1.tasks.count)
        XCTAssertEqual(1, basis_1.taskSources.count)
        XCTAssertEqual(1, basis_1.categories.count)
        XCTAssertEqual(1, basis_1.pauses.count)
        
        XCTAssertEqual(T.task, basis_1.taskMap[T.task.id])
        XCTAssertEqual(T.taskSource, basis_1.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(T.category, basis_1.categoryMap[T.category.id])
        XCTAssertEqual(T.pause, basis_1.pauseMap[T.pause.id])
        
        let assertionSet_2 = KeySet<Assertion>().inserting(contentsOf: T.testAssertions_2)
        
        // Add more new
        let basis_2 = BasisResolver(basis_1).commit(assertionSet_2)
        
        XCTAssertEqual(2, basis_2.tasks.count)
        XCTAssertEqual(2, basis_2.taskSources.count)
        XCTAssertEqual(2, basis_2.categories.count)
        XCTAssertEqual(2, basis_2.pauses.count)
        
        XCTAssertEqual(T.task, basis_2.taskMap[T.task.id])
        XCTAssertEqual(T.taskSource, basis_2.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(T.category, basis_2.categoryMap[T.category.id])
        XCTAssertEqual(T.pause, basis_2.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_2.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_2.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_2.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_2.pauseMap[T.pause_2.id])
        
        let assertionSet_edits = KeySet<Assertion>().inserting(contentsOf: T.testAssertionsEdited)
        
        // Edit
        let basis_3 = BasisResolver(basis_2).commit(assertionSet_edits)
        
        XCTAssertEqual(2, basis_3.tasks.count)
        XCTAssertEqual(2, basis_3.taskSources.count)
        XCTAssertEqual(2, basis_3.categories.count)
        XCTAssertEqual(2, basis_3.pauses.count)
        
        XCTAssertEqual(T.taskEdited, basis_3.taskMap[T.task.id])
        XCTAssertEqual(T.taskSourceEdited, basis_3.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(T.categoryEdited, basis_3.categoryMap[T.category.id])
        XCTAssertEqual(T.pauseEdited, basis_3.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_3.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_3.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_3.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_3.pauseMap[T.pause_2.id])
        
        let deleteTask = Assertion(DeleteKey(T.task.id))
        let deleteTaskSource = Assertion(DeleteKey(T.taskSource.id))
        let deleteCategory = Assertion(DeleteKey(T.category.id))
        let deletePause = Assertion(DeleteKey(T.pause.id))
        
        let deletes = [
            deleteTask
            , deleteTaskSource
            , deleteCategory
            , deletePause
        ]
        
        let assertionSet_deletes = KeySet<Assertion>().inserting(contentsOf: deletes)
        
        let basis_4 = BasisResolver(basis_3).commit(assertionSet_deletes)
        
        XCTAssertEqual(1, basis_4.tasks.count)
        XCTAssertEqual(1, basis_4.taskSources.count)
        XCTAssertEqual(1, basis_4.categories.count)
        XCTAssertEqual(1, basis_4.pauses.count)
        
        XCTAssertEqual(nil, basis_4.taskMap[T.task.id])
        XCTAssertEqual(nil, basis_4.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(nil, basis_4.categoryMap[T.category.id])
        XCTAssertEqual(nil, basis_4.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_4.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_4.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_4.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_4.pauseMap[T.pause_2.id])
    }
    
    func testFlatten() throws {
        
        let assertionSet = KeySet<Assertion>().inserting(contentsOf: T.testAssertions)
        let assertionSet_2 = KeySet<Assertion>().inserting(contentsOf: T.testAssertions_2)
        
        let flattened_2 = BasisResolver.flatten([
            assertionSet
            , assertionSet_2
        ])
        
        // Add more new
        let basis_2 = BasisResolver(DataBasis()).commit(flattened_2)
        
        XCTAssertEqual(9, flattened_2.count)
        
        XCTAssertEqual(2, basis_2.tasks.count)
        XCTAssertEqual(2, basis_2.taskSources.count)
        XCTAssertEqual(2, basis_2.categories.count)
        XCTAssertEqual(2, basis_2.pauses.count)
        
        XCTAssertEqual(T.task, basis_2.taskMap[T.task.id])
        XCTAssertEqual(T.taskSource, basis_2.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(T.category, basis_2.categoryMap[T.category.id])
        XCTAssertEqual(T.pause, basis_2.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_2.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_2.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_2.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_2.pauseMap[T.pause_2.id])
        
        let assertionSet_edits = KeySet<Assertion>().inserting(contentsOf: T.testAssertionsEdited)
        
        let flattened_3 = BasisResolver.flatten([
            assertionSet
            , assertionSet_2
            , assertionSet_edits
        ])
        
        // Edit
        let basis_3 = BasisResolver(DataBasis()).commit(flattened_3)
        
        XCTAssertEqual(9, flattened_3.count)
        
        XCTAssertEqual(2, basis_3.tasks.count)
        XCTAssertEqual(2, basis_3.taskSources.count)
        XCTAssertEqual(2, basis_3.categories.count)
        XCTAssertEqual(2, basis_3.pauses.count)
        
        XCTAssertEqual(T.taskEdited, basis_3.taskMap[T.task.id])
        XCTAssertEqual(T.taskSourceEdited, basis_3.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(T.categoryEdited, basis_3.categoryMap[T.category.id])
        XCTAssertEqual(T.pauseEdited, basis_3.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_3.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_3.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_3.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_3.pauseMap[T.pause_2.id])
        
        let deleteTask = Assertion(DeleteKey(T.task.id))
        let deleteTaskSource = Assertion(DeleteKey(T.taskSource.id))
        let deleteCategory = Assertion(DeleteKey(T.category.id))
        let deletePause = Assertion(DeleteKey(T.pause.id))
        
        let deletes = [
            deleteTask
            , deleteTaskSource
            , deleteCategory
            , deletePause
        ]
        
        let assertionSet_deletes = KeySet<Assertion>().inserting(contentsOf: deletes)
        
        let flattened_4 = BasisResolver.flatten([
            assertionSet
            , assertionSet_2
            , assertionSet_edits
            , assertionSet_deletes
        ])
        
        // Edit
        let basis_4 = BasisResolver(DataBasis()).commit(flattened_4)
        
        XCTAssertEqual(9, flattened_4.count)
        
        XCTAssertEqual(1, basis_4.tasks.count)
        XCTAssertEqual(1, basis_4.taskSources.count)
        XCTAssertEqual(1, basis_4.categories.count)
        XCTAssertEqual(1, basis_4.pauses.count)
        
        XCTAssertEqual(nil, basis_4.taskMap[T.task.id])
        XCTAssertEqual(nil, basis_4.taskSourceMap[T.taskSource.id])
        XCTAssertEqual(nil, basis_4.categoryMap[T.category.id])
        XCTAssertEqual(nil, basis_4.pauseMap[T.pause.id])
        XCTAssertEqual(T.task_2, basis_4.taskMap[T.task_2.id])
        XCTAssertEqual(T.taskSource_2, basis_4.taskSourceMap[T.taskSource_2.id])
        XCTAssertEqual(T.category_2, basis_4.categoryMap[T.category_2.id])
        XCTAssertEqual(T.pause_2, basis_4.pauseMap[T.pause_2.id])
    }
    
}
