//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import XCTest
@testable import Models

fileprivate typealias T = TestValues

final class ToDoTests: XCTestCase {
    
    func test_create() throws {
        let sut = ToDoSource.create(
            label: T.testLabel
            , description: T.testDescription
            , time: .reminder(T.time)
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let initialTask = sut.initialTask
        
        XCTAssertEqual(T.testLabel, source.label)
        XCTAssertEqual(T.testDescription, source.description)
        XCTAssertEqual(nil, source.category)
        XCTAssertEqual(nil, source.pauses)
        XCTAssertEqual(initialTask.id, source.task)
        
        XCTAssertEqual(source.id, initialTask.source)
        XCTAssertEqual(T.testLabel, initialTask.label)
        XCTAssertEqual(.reminder(T.time), initialTask.scheduled)
        XCTAssertEqual(nil, initialTask.completed)
    }
    
    func test_edit() throws {
        let time = T.time
        
        let sut = ToDoSource.create(
            label: T.testLabel
            , description: T.testDescription
            , time: .reminder(time)
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let task = sut.initialTask
        
        let editedSource_1 = source.edit(
            label: T.testLabel_2
            , description: T.testDescription_2
            , category: T.category
            , pauses: T.pauses
        )
        
        let editedTask_1 = task.edit(
            label: T.testLabel_2
            , scheduled: .deadline(T.time_2)
            , completed: T.time_3
        )
        
        XCTAssertEqual(T.testLabel_2, editedSource_1.label)
        XCTAssertEqual(T.testDescription_2, editedSource_1.description)
        XCTAssertEqual(T.category, editedSource_1.category)
        XCTAssertEqual(T.pauses, editedSource_1.pauses)
        XCTAssertEqual(task.id, editedSource_1.task)
        
        XCTAssertEqual(source.id, editedTask_1.source)
        XCTAssertEqual(T.testLabel_2, editedTask_1.label)
        XCTAssertEqual(.deadline(T.time_2), editedTask_1.scheduled)
        XCTAssertEqual(T.time_3, editedTask_1.completed)
        
        let editedSource_2 = source.edit(
            label: T.testLabel
            , description: ""
            , category: .null
            , pauses: []
        )
        
        let editedTask_2 = task.edit(
            label: T.testLabel
            , scheduled: .deadline(T.time_3)
            , completed: .null
        )
        
        XCTAssertEqual(T.testLabel, editedSource_2.label)
        XCTAssertEqual(nil, editedSource_2.description)
        XCTAssertEqual(nil, editedSource_2.category)
        XCTAssertEqual(nil, editedSource_2.pauses)
        XCTAssertEqual(task.id, editedSource_2.task)
        
        XCTAssertEqual(source.id, editedTask_2.source)
        XCTAssertEqual(T.testLabel, editedTask_2.label)
        XCTAssertEqual(.deadline(T.time_3), editedTask_2.scheduled)
        XCTAssertEqual(nil, editedTask_2.completed)
    }
    
    func test_complete() throws {
        let sut = ToDoSource.create(
            label: T.testLabel
            , description: T.testDescription
            , time: .reminder(T.time)
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let task = sut.initialTask
        
        XCTAssertEqual(nil, task.completed)
        
        let completeTime = T.time.adding(.hours(1))!
        let completedTask = task.complete(date: completeTime)
        
        let newTask = source.generateNewTask(from: completedTask)
        
        XCTAssertEqual(completeTime, completedTask.completed)
        XCTAssertEqual(nil, newTask)
    }
    
    func test_deactivate() throws {
        let sut = ToDoSource.create(
            label: T.testLabel
            , description: T.testDescription
            , time: .reminder(T.time)
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        
        XCTAssertEqual(nil, source.deactivated)
        
        let deactivated = source.deactivate(date: T.time_2)
        
        XCTAssertEqual(T.time_2, deactivated.deactivated)
        
        let doubleDeactivated = deactivated.deactivate(date: T.time_3)
        
        // Shouldn't update
        XCTAssertEqual(T.time_2, doubleDeactivated.deactivated)
        
        let activated = deactivated.activate()
        
        XCTAssertEqual(nil, activated.deactivated)
    }
}
