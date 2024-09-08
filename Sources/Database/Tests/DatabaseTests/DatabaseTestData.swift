import XCTest
@testable import Database
import Models

internal final class TestValues {
    
    static let mar_1_2001 = Date(timeIntervalSince1970: 983404800)
    static let feb_1_2001 = Date(timeIntervalSince1970: 980985600)
    static let apr_1_2001 = Date(timeIntervalSince1970: 986083200)
    
    static let task = AnyTask(ToDoSource.create(
        label: "Test Task"
        , description: nil
        , time: .task(mar_1_2001)
        , category: nil
        , pauses: nil
    ).initialTask)
    
    static let taskSource = AnyTaskSource(ToDoSource.create(
        label: "Test Task"
        , description: nil
        , time: .task(mar_1_2001)
        , category: nil
        , pauses: nil
    ).source)
    
    static let category = TaskCategory(
        id: Key.new()
        , label: "Test Category"
        , description: nil
        , pauses: nil
    )
    
    static let pause = TaskPause(
        id: Key.new()
        , label: "Test Pause"
        , description: nil
    )
    
    static let delete = DeleteKey(Key.new())
    
    static let taskAssertion = Assertion(task)
    static let sourceAssertion = Assertion(taskSource)
    static let categoryAssertion = Assertion(category)
    static let pauseAssertion = Assertion(pause)
    static let deleteAssertion = Assertion(delete)
    
    static let testAssertions = [
        taskAssertion
        , sourceAssertion
        , categoryAssertion
        , pauseAssertion
        , deleteAssertion
    ]
    
    static let taskEdited = AnyTask((task.task as! ToDoTask).edit(
        label: "Test Task Edited"
        , scheduled: nil
        , completed: apr_1_2001
    ))
    
    static let taskSourceEdited = AnyTaskSource((taskSource.task as! ToDoSource).edit(
        label: "Task Source Edited"
        , description: nil
        , category: nil
        , pauses: nil
    ))
    
    static let categoryEdited = category.edit(
        label: "Category Edited"
        , description: nil
        , pauses: nil
    )
    
    static let pauseEdited = pause.edit(
        label: "Pause Edited"
        , description: nil
    )
    
    static let taskAssertionEdited = Assertion(taskEdited)
    static let sourceAssertionEdited = Assertion(taskSourceEdited)
    static let categoryAssertionEdited = Assertion(categoryEdited)
    static let pauseAssertionEdited = Assertion(pauseEdited)
    
    static let testAssertionsEdited = [
        taskAssertionEdited
        , sourceAssertionEdited
        , categoryAssertionEdited
        , pauseAssertionEdited
    ]
    
    
    static let task_2 = AnyTask(ToDoSource.create(
        label: "Test Task 2"
        , description: nil
        , time: .task(Date.now)
        , category: nil
        , pauses: nil
    ).initialTask)
    
    static let taskSource_2 = AnyTaskSource(ToDoSource.create(
        label: "Test Task 2"
        , description: nil
        , time: .task(Date.now)
        , category: nil
        , pauses: nil
    ).source)
    
    static let category_2 = TaskCategory(
        id: Key.new()
        , label: "Test Category 2"
        , description: nil
        , pauses: nil
    )
    
    static let pause_2 = TaskPause(
        id: Key.new()
        , label: "Test Pause 2"
        , description: nil
    )
    
    static let taskAssertion_2 = Assertion(task_2)
    static let sourceAssertion_2 = Assertion(taskSource_2)
    static let categoryAssertion_2 = Assertion(category_2)
    static let pauseAssertion_2 = Assertion(pause_2)
    
    static let testAssertions_2 = [
        taskAssertion_2
        , sourceAssertion_2
        , categoryAssertion_2
        , pauseAssertion_2
    ]
}
