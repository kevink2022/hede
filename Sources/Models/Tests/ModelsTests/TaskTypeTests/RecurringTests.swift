//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import XCTest
import Domain
@testable import Models

fileprivate typealias T = TestValues

final class RecurringTests: XCTestCase {
    
    func test_create_noInitial() throws {
        let dateSnapshot = Date.now
        
        let sut = RecurringSource.create(
            label: T.testLabel
            , description: T.testDescription
            , taskType: .reminder
            , recurranceType: .fromScheduled
            , spacing: .weeks(1)
            , lastCompleted: nil
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let initialTask = sut.initialTask
        
        XCTAssertEqual(T.testLabel, source.label)
        XCTAssertEqual(T.testDescription, source.description)
        XCTAssertEqual(nil, source.category)
        XCTAssertEqual(nil, source.pauses)
        XCTAssertEqual(.fromScheduled, source.type)
        XCTAssertEqual(.weeks(1), source.spacing)
        
        XCTAssertEqual(source.id, initialTask.source)
        XCTAssertEqual(T.testLabel, initialTask.label)
        //XCTAssert(dateSnapshot.adding(.weeks(1))! <= initialTask.scheduled.start)
        XCTAssertEqual(nil, initialTask.completed)
    }
    
    func test_create_withInitial() throws {
        let sut = RecurringSource.create(
            label: T.testLabel
            , description: T.testDescription
            , taskType: .reminder
            , recurranceType: .fromScheduled
            , spacing: .weeks(1)
            , lastCompleted: T.time
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let initialTask = sut.initialTask
        
        XCTAssertEqual(T.testLabel, source.label)
        XCTAssertEqual(T.testDescription, source.description)
        XCTAssertEqual(nil, source.category)
        XCTAssertEqual(nil, source.pauses)
        XCTAssertEqual(.fromScheduled, source.type)
        XCTAssertEqual(.weeks(1), source.spacing)
        
        XCTAssertEqual(source.id, initialTask.source)
        XCTAssertEqual(T.testLabel, initialTask.label)
        XCTAssertEqual(T.time.adding(.weeks(1)), initialTask.scheduled.start)
        XCTAssertEqual(nil, initialTask.completed)
    }
    
    func test_edit() throws {
        let sut = RecurringSource.create(
            label: T.testLabel
            , description: T.testDescription
            , taskType: .reminder
            , recurranceType: .fromScheduled
            , spacing: .weeks(1)
            , lastCompleted: T.time
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let task = sut.initialTask
        
        let (editedSource_1, editedTask_1) = source.edit(
            label: T.testLabel_2
            , description: T.testDescription_2
            , category: T.category
            , pauses: T.pauses
            , taskType: .deadline
            , type: .fromComplete
            , spacing: .days(10)
            , lastTask: task
        )
 
        
        XCTAssertEqual(T.testLabel_2, editedSource_1.label)
        XCTAssertEqual(T.testDescription_2, editedSource_1.description)
        XCTAssertEqual(T.category, editedSource_1.category)
        XCTAssertEqual(T.pauses, editedSource_1.pauses)
        XCTAssertEqual(.fromComplete, editedSource_1.type)
        XCTAssertEqual(.days(10), editedSource_1.spacing)
        
        XCTAssertEqual(source.id, editedTask_1.source)
        XCTAssertEqual(T.testLabel_2, editedTask_1.label)
//        XCTAssertEqual(.deadline(T.time_2), editedTask_1.scheduled)
//        XCTAssertEqual(T.time_3, editedTask_1.completed)
        
        let (editedSource_2, editedTask_2) = source.edit(
            label: T.testLabel
            , description: ""
            , category: .null
            , pauses: nil
            , taskType: nil
            , type: .fromComplete
            , spacing: nil
            , lastTask: task
        )

        XCTAssertEqual(T.testLabel, editedSource_2.label)
        XCTAssertEqual(nil, editedSource_2.description)
        XCTAssertEqual(nil, editedSource_2.category)
        XCTAssertEqual(nil, editedSource_2.pauses)
        XCTAssertEqual(.fromComplete, editedSource_1.type)
        XCTAssertEqual(.days(10), editedSource_1.spacing)
        
        XCTAssertEqual(source.id, editedTask_2.source)
        XCTAssertEqual(T.testLabel, editedTask_2.label)
//        XCTAssertEqual(.deadline(T.time_3), editedTask_2.scheduled)
        XCTAssertEqual(nil, editedTask_2.completed)
    }
    
    func test_complete() throws {
        let sut = RecurringSource.create(
            label: T.testLabel
            , description: T.testDescription
            , taskType: .task
            , recurranceType: .fromComplete
            , spacing: .weeks(1)
            , lastCompleted: T.time
            , category: nil
            , pauses: nil
        )
        
        let source = sut.source
        let task = sut.initialTask
        
        XCTAssertEqual(nil, task.completed)
        
        let completeTime = T.time_2
        let expectedNewStart = T.time_2.adding(.weeks(1))!
        let completedTask = task.complete(date: completeTime)
        
        guard let newTask = source.generateNewTask(from: completedTask) else {
            XCTFail("New Task wasn't generated")
            return
        }
        
        XCTAssertEqual(completeTime, completedTask.completed)
        
        XCTAssertEqual(expectedNewStart, newTask.scheduled.start)
        XCTAssertEqual(.task(expectedNewStart), newTask.scheduled)
        XCTAssertEqual(source.id, newTask.source)
        XCTAssertEqual(T.testLabel, newTask.label)
        XCTAssertEqual(nil, newTask.completed)
    }
    
    func test_deactivate() throws {
        let sut = RecurringSource.create(
            label: T.testLabel
            , description: T.testDescription
            , taskType: .task
            , recurranceType: .fromScheduled
            , spacing: .weeks(1)
            , lastCompleted: T.time
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
    
    func testDecodeOldSchema() {
        guard let sources = try? JSONDecoder().decode([AnyTaskSource].self, from: sourcesOldSchema) else {
            XCTFail("Failed to decode"); return
        }
        
        XCTAssertEqual(sources.count, 6)
    }
    
    // Temporary old schema using
    let sourcesOldSchema: Data = """
        [
          {
            "code" : {
              "toDo" : {
                "_0" : {
                  "label" : "Buy Beer for Game",
                  "description" : "Pat likes coors.",
                  "task" : {
                    "id" : "E828B9C3-42FF-424E-BB0F-BE2BDA0C1907"
                  },
                  "id" : {
                    "id" : "1AC45D22-C26E-4E15-B3D4-9BD10FC23851"
                  }
                }
              }
            }
          },
          {
            "code" : {
              "toDo" : {
                "_0" : {
                  "description" : "He would be too smart to say yes.",
                  "task" : {
                    "id" : "A0B41373-33CF-4882-9A1E-310FA112098B"
                  },
                  "label" : "Text Michael about new creami flavor.",
                  "id" : {
                    "id" : "843A4E82-0D57-4210-BEE6-79F332D7D9BB"
                  }
                }
              }
            }
          },
          {
            "code" : {
              "toDo" : {
                "_0" : {
                  "task" : {
                    "id" : "0938E484-D4BC-4AA5-95C1-4856CBB7CE5E"
                  },
                  "description" : "Stonls",
                  "label" : "Call with Aaron",
                  "id" : {
                    "id" : "E6961804-F2D2-496B-BD5E-00402438EAA2"
                  }
                }
              }
            }
          },
          {
            "code" : {
              "recurring" : {
                "_0" : {
                  "id" : {
                    "id" : "CA3EDCB7-8983-413D-AB5D-5150AF255529"
                  },
                  "type" : {
                    "fromComplete" : {

                    }
                  },
                  "description" : "Practice Patterns",
                  "label" : "Do Leetcode problem",
                  "spacing" : {
                    "weeks" : {
                      "_0" : 1
                    }
                  }
                }
              }
            }
          },
          {
            "code" : {
              "recurring" : {
                "_0" : {
                  "spacing" : {
                    "weeks" : {
                      "_0" : 2
                    }
                  },
                  "id" : {
                    "id" : "B6019744-9C8D-4A63-BEB0-A933523C55D7"
                  },
                  "label" : "Wash Sheets",
                  "type" : {
                    "fromComplete" : {

                    }
                  }
                }
              }
            }
          },
          {
            "code" : {
              "recurring" : {
                "_0" : {
                  "spacing" : {
                    "months" : {
                      "_0" : 1
                    }
                  },
                  "type" : {
                    "fromScheduled" : {

                    }
                  },
                  "label" : "Pay Rent",
                  "id" : {
                    "id" : "5E0D7E4C-E005-4F48-AC4A-67BFDAF81830"
                  }
                }
              }
            }
          }
        ]
        """.data(using: .utf8)!
}
