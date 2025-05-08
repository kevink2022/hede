//
//  GoalBasisTests.swift
//  Database
//
//  Created by Kevin Kelly on 3/16/25.
//

import XCTest
@testable import Database
import Assemblages
import Models
import Storage

private typealias T = TestValues

final class GoalBasisTests: XCTestCase {
    
    func testCommit() throws {
        guard let data = TestData.data() else { XCTFail("Could not decode test data."); return }
        let assertions = data.map { $0.data.assertions }
        
//        for index in assertions.indices {
//            print("\(index): \(assertions[index].asJsonString() ?? "NULL")")
//        }
        
        let results = Array(assertions[0..<28])
        let goals = Array(assertions[28...])
        
        let basis_1 = BasisResolver(GoalBasis.empty).commit(Assertion.flatten(goals))
        
        XCTAssertEqual(4, basis_1.dailyGoals.count)
        XCTAssertEqual(2, basis_1.dailyGoalLists.count)
        XCTAssertEqual(2, basis_1.dailyGoalListSections.count)
//        XCTAssertEqual(0, basis_1.dailyGoalResults.count)
        
        var basis = basis_1
        
        for index in results.indices {
            print("\(index) - Assertion:\n\(results[index].asJsonString() ?? "NULL")")
            basis = BasisResolver(basis).commit(results[index])
//            print("\(index) - Basis:\n\(basis.dailyGoalResults.asJsonString() ?? "NULL")")
            
        }
        
        XCTAssertEqual(4, basis.dailyGoals.count)
        XCTAssertEqual(2, basis.dailyGoalLists.count)
        XCTAssertEqual(2, basis.dailyGoalListSections.count)
//        XCTAssertEqual(0, basis.dailyGoalResults.count)
    }
    
    func testFlatten() throws {
        
    }
    
    func test_decodeData() {
        guard let data = TestData.data() else { XCTFail("Could not decode test data."); return }
        print(data.count)
//        print(data[10].asJsonString())
        print("\(data.asJsonString() ?? "NULL")")
    }
}

fileprivate final class TestData {
    static func data() -> [DataTransaction<UserEventLog>]? {
        return try? JSONDecoder().decode([DataTransaction<UserEventLog>].self, from: Self.dataString.data(using: .utf8)!)
    }
    
    static let dataString = """
    [
      {
        "timestamp" : 763522807.792409,
        "id" : "BD300072-273E-4F08-A091-0F5F76970598",
        "data" : {
          "label" : "Logged Goal: Clean Home",
          "assertions" : {
            "storage" : [
              {
                "id" : "985962FF-7B06-466F-BAEC-6ABC1D06D03E"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "date" : 763444800,
                      "recorded" : 763522807.792248,
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "id" : {
                        "id" : "985962FF-7B06-466F-BAEC-6ABC1D06D03E"
                      },
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "label" : "Clean Home"
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "timestamp" : 763522794.491538,
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "1A802D3A-4F23-4112-84BF-B1D2580673B1"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "result" : {
                        "completion" : {
                          "result" : 1,
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "date" : 763444800,
                      "recorded" : 763522794.490715,
                      "id" : {
                        "id" : "1A802D3A-4F23-4112-84BF-B1D2580673B1"
                      },
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "label" : "Exercise"
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "BB8DC494-4BF2-4152-BDBF-4DD6FFC71AE3"
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "8B324EE5-6F78-4C67-B718-DE2A6A1A27CE"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "label" : "Clean Home",
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "recorded" : 763448027.223898,
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "date" : 763444800,
                      "id" : {
                        "id" : "8B324EE5-6F78-4C67-B718-DE2A6A1A27CE"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Clean Home"
        },
        "id" : "8769D724-C3A7-4AD9-B3CE-19EFA1D8784D",
        "timestamp" : 763448027.224117
      },
      {
        "timestamp" : 763448026.869665,
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "AF7B063B-228E-410C-B036-04179775DEA2"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "id" : {
                        "id" : "AF7B063B-228E-410C-B036-04179775DEA2"
                      },
                      "date" : 763444800,
                      "recorded" : 763448026.867939,
                      "label" : "Exercise",
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "CDDB2BFF-C0AC-4216-961A-2B9F685EA168"
      },
      {
        "id" : "EA6D94D3-C671-4177-A305-4D8C7EF3FB68",
        "timestamp" : 763447690.348527,
        "data" : {
          "label" : "Logged Goal: Dev Sprints",
          "assertions" : {
            "storage" : [
              {
                "id" : "820D04C7-DDFD-4059-A10D-C075297E7741"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "id" : {
                        "id" : "820D04C7-DDFD-4059-A10D-C075297E7741"
                      },
                      "result" : {
                        "count" : {
                          "goals" : {
                            "storage" : [
                              2,
                              4
                            ]
                          },
                          "result" : 6
                        }
                      },
                      "dailyGoalId" : {
                        "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                      },
                      "label" : "Dev Sprints",
                      "date" : 763444800,
                      "recorded" : 763447690.348137
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "timestamp" : 763447686.475957,
        "data" : {
          "label" : "Delete",
          "assertions" : {
            "storage" : [
              {
                "id" : "AC489F64-F6B5-4A90-956F-141A93907EBE"
              },
              {
                "assertCode" : {
                  "delete" : {
                    "_0" : {
                      "id" : {
                        "id" : "AC489F64-F6B5-4A90-956F-141A93907EBE"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "B04B600F-8EAA-4742-9D70-9FC9569595D6"
      },
      {
        "timestamp" : 763447686.473341,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "3940C73D-3703-4E13-8FA0-89E6C7F7DC23"
              },
              {
                "assertCode" : {
                  "delete" : {
                    "_0" : {
                      "id" : {
                        "id" : "3940C73D-3703-4E13-8FA0-89E6C7F7DC23"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Delete"
        },
        "id" : "A8B36A50-6DA8-4F8F-9100-0154C4DF4C06"
      },
      {
        "timestamp" : 763447683.795719,
        "id" : "2EBB48EA-42B4-4B83-8036-AFAE1AD66BCF",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "AD73F5A5-17E1-402C-A8F8-D08B03AC2A2E"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "date" : 763444800,
                      "recorded" : 763447683.79555,
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "label" : "Clean Home",
                      "id" : {
                        "id" : "AD73F5A5-17E1-402C-A8F8-D08B03AC2A2E"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Clean Home"
        }
      },
      {
        "timestamp" : 763447683.274877,
        "id" : "A291314C-8B35-475E-BDE3-3D43D5617939",
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "26437007-E3A1-46CF-83D9-7F16590BEDE0"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "label" : "Exercise",
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "recorded" : 763447683.272689,
                      "id" : {
                        "id" : "26437007-E3A1-46CF-83D9-7F16590BEDE0"
                      },
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "6DADB4FF-A44B-4F44-99E8-E10DDCB03216"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "recorded" : 763447475.135574,
                      "label" : "Dev Sprints",
                      "dailyGoalId" : {
                        "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                      },
                      "id" : {
                        "id" : "6DADB4FF-A44B-4F44-99E8-E10DDCB03216"
                      },
                      "result" : {
                        "count" : {
                          "result" : 6,
                          "goals" : {
                            "storage" : [
                              2,
                              4
                            ]
                          }
                        }
                      },
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Dev Sprints"
        },
        "id" : "A518BE42-388D-48EF-92A3-F9F75730B6F2",
        "timestamp" : 763447475.135711
      },
      {
        "timestamp" : 763447471.602408,
        "data" : {
          "label" : "Logged Goal: Clean Home",
          "assertions" : {
            "storage" : [
              {
                "id" : "609825ED-9E92-4EBA-9BF2-81748358E79C"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "recorded" : 763447471.60223,
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 2
                        }
                      },
                      "label" : "Clean Home",
                      "id" : {
                        "id" : "609825ED-9E92-4EBA-9BF2-81748358E79C"
                      },
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "BAA2CA86-6081-46B6-A6B9-CBCBEA8DB19E"
      },
      {
        "data" : {
          "label" : "Logged Goal: Clean Home",
          "assertions" : {
            "storage" : [
              {
                "id" : "4C992B83-5829-4868-BF81-9A816A36271C"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "result" : {
                        "completion" : {
                          "result" : 1,
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "date" : 763444800,
                      "recorded" : 763447471.490911,
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "id" : {
                        "id" : "4C992B83-5829-4868-BF81-9A816A36271C"
                      },
                      "label" : "Clean Home"
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "AA13DDAD-3228-4474-AB27-58B3A34B35FE",
        "timestamp" : 763447471.491057
      },
      {
        "id" : "639EBBEB-8B08-484A-810A-B804ABB232E8",
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "EACC90AE-CB39-4D3D-B787-6180539D681B"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "label" : "Exercise",
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "id" : {
                        "id" : "EACC90AE-CB39-4D3D-B787-6180539D681B"
                      },
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 2
                        }
                      },
                      "date" : 763444800,
                      "recorded" : 763447468.569402
                    }
                  }
                }
              }
            ]
          }
        },
        "timestamp" : 763447468.569567
      },
      {
        "id" : "C9D22579-3125-4AD5-A1CE-90CB49916398",
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "F69A4419-8B60-4D2B-87EA-9121F4D90E6C"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "recorded" : 763447468.092435,
                      "id" : {
                        "id" : "F69A4419-8B60-4D2B-87EA-9121F4D90E6C"
                      },
                      "result" : {
                        "completion" : {
                          "result" : 1,
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "label" : "Exercise",
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          }
        },
        "timestamp" : 763447468.092624
      },
      {
        "id" : "14D336A5-9CEA-4EAF-9FC3-F1AE411333B3",
        "data" : {
          "label" : "Delete",
          "assertions" : {
            "storage" : [
              {
                "id" : "E6B7F079-B2DA-43E2-B651-7C28379833E9"
              },
              {
                "assertCode" : {
                  "delete" : {
                    "_0" : {
                      "id" : {
                        "id" : "E6B7F079-B2DA-43E2-B651-7C28379833E9"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "timestamp" : 763447462.17304
      },
      {
        "id" : "08E8225E-8C14-44BB-98A0-866C7A3A660D",
        "timestamp" : 763447460.485979,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "93380361-8E09-4039-9EEC-475619B9EF73"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "dailyGoalId" : {
                        "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                      },
                      "id" : {
                        "id" : "93380361-8E09-4039-9EEC-475619B9EF73"
                      },
                      "recorded" : 763447460.485865,
                      "result" : {
                        "number" : {
                          "goals" : {
                            "storage" : [
                              6,
                              7,
                              8
                            ]
                          },
                          "result" : 6
                        }
                      },
                      "label" : "Sleep",
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Sleep"
        }
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "1B49C05A-BDCD-42EE-89CF-32F82DA7CF77"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "dailyGoalId" : {
                        "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                      },
                      "id" : {
                        "id" : "1B49C05A-BDCD-42EE-89CF-32F82DA7CF77"
                      },
                      "result" : {
                        "number" : {
                          "result" : 65,
                          "goals" : {
                            "storage" : [
                              6,
                              7,
                              8
                            ]
                          }
                        }
                      },
                      "date" : 763444800,
                      "recorded" : 763447460.065742,
                      "label" : "Sleep"
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Sleep"
        },
        "timestamp" : 763447460.065838,
        "id" : "365EF09E-3666-4C80-9674-74705C52CE92"
      },
      {
        "timestamp" : 763447457.448479,
        "id" : "B46B4746-93BA-461F-AD00-C0456457C788",
        "data" : {
          "label" : "Logged Goal: Sleep",
          "assertions" : {
            "storage" : [
              {
                "id" : "6917965C-6787-43D2-94F4-08CA8F2FF733"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "id" : {
                        "id" : "6917965C-6787-43D2-94F4-08CA8F2FF733"
                      },
                      "recorded" : 763447457.448153,
                      "label" : "Sleep",
                      "date" : 763444800,
                      "result" : {
                        "number" : {
                          "goals" : {
                            "storage" : [
                              6,
                              7,
                              8
                            ]
                          },
                          "result" : 6
                        }
                      },
                      "dailyGoalId" : {
                        "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                      }
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "id" : "59C6F486-5BCD-477C-9665-42E5B3FBD45D",
        "timestamp" : 763447388.707717,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
              },
              {
                "assertCode" : {
                  "dailyGoal" : {
                    "_0" : {
                      "config" : {
                        "count" : {
                          "goals" : {
                            "storage" : [
                              2,
                              4
                            ]
                          }
                        }
                      },
                      "type" : "Positive",
                      "label" : "Dev Sprints",
                      "id" : {
                        "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                      },
                      "active" : true
                    }
                  }
                }
              }
            ]
          },
          "label" : "Edit Goal: Dev Sprints"
        }
      },
      {
        "timestamp" : 763447306.920535,
        "data" : {
          "label" : "Delete",
          "assertions" : {
            "storage" : [
              {
                "id" : "BD68582D-2C4E-402C-88DA-C1798660403B"
              },
              {
                "assertCode" : {
                  "delete" : {
                    "_0" : {
                      "id" : {
                        "id" : "BD68582D-2C4E-402C-88DA-C1798660403B"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "4C9945FF-BDEF-4971-8851-F978E9850F30"
      },
      {
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "D4061006-A7A3-4E93-8CB1-48B2F75C7DA4"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "result" : {
                        "completion" : {
                          "result" : 1,
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "recorded" : 763447302.577257,
                      "id" : {
                        "id" : "D4061006-A7A3-4E93-8CB1-48B2F75C7DA4"
                      },
                      "label" : "Exercise",
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "E95CBBBD-6E8C-4203-8C5F-60C0B7ED47E4",
        "timestamp" : 763447302.57745
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "27347E54-DE93-4D3B-94AE-FB2612267954"
              },
              {
                "assertCode" : {
                  "delete" : {
                    "_0" : {
                      "id" : {
                        "id" : "27347E54-DE93-4D3B-94AE-FB2612267954"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Delete"
        },
        "timestamp" : 763447296.439038,
        "id" : "4045CB88-FF6D-4CED-A9D4-FEF6FDEE9619"
      },
      {
        "timestamp" : 763447286.958911,
        "id" : "9AF16294-6B3E-4360-B96B-3F22F4C17DD6",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "2C9CFAED-50F9-4F49-8DEE-7BFAF28AAFD7"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "id" : {
                        "id" : "2C9CFAED-50F9-4F49-8DEE-7BFAF28AAFD7"
                      },
                      "result" : {
                        "completion" : {
                          "result" : 1,
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "date" : 763444800,
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "label" : "Clean Home",
                      "recorded" : 763447286.956637
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Clean Home"
        }
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "4112F5C9-38DC-43F1-B8FB-BDC878CFD306"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "id" : {
                        "id" : "4112F5C9-38DC-43F1-B8FB-BDC878CFD306"
                      },
                      "label" : "Dev Sprints",
                      "dailyGoalId" : {
                        "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                      },
                      "result" : {
                        "count" : {
                          "result" : 6,
                          "goals" : {
                            "storage" : [
                              2,
                              4
                            ]
                          }
                        }
                      },
                      "date" : 763444800,
                      "recorded" : 763445917.212291
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Dev Sprints"
        },
        "timestamp" : 763445917.21298,
        "id" : "18DB07CB-E352-4603-8301-F83445A324BF"
      },
      {
        "timestamp" : 763445901.227852,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "8BB038EF-AA17-435A-97F3-9FF2B5D6580D"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {

                    "_0" : {
                      "id" : {
                        "id" : "8BB038EF-AA17-435A-97F3-9FF2B5D6580D"
                      },
                      "label" : "Clean Home",
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 2
                        }
                      },
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "date" : 763444800,
                      "recorded" : 763445901.227702
                    }
                  }
                }
              }
            ]
          },
          "label" : "Logged Goal: Clean Home"
        },
        "id" : "BA735B6B-8F1A-47FD-BCCB-027B2859FB24"
      },
      {
        "id" : "8323443B-296D-46C7-B359-DE308CA1C57B",
        "timestamp" : 763445901.079003,
        "data" : {
          "label" : "Logged Goal: Clean Home",
          "assertions" : {
            "storage" : [
              {
                "id" : "4C9B1CC7-3768-44A5-B583-512DC2C165DA"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "id" : {
                        "id" : "4C9B1CC7-3768-44A5-B583-512DC2C165DA"
                      },
                      "label" : "Clean Home",
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "dailyGoalId" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "recorded" : 763445901.078843,
                      "date" : 763444800
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "A674DD27-EC4D-4212-B263-B78894F68CFE"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "label" : "Exercise",
                      "id" : {
                        "id" : "A674DD27-EC4D-4212-B263-B78894F68CFE"
                      },
                      "recorded" : 763445899.1797,
                      "date" : 763444800,
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 2
                        }
                      }
                    }
                  }

                }
              }
            ]
          },
          "label" : "Logged Goal: Exercise"
        },
        "timestamp" : 763445899.179856,
        "id" : "F9607600-4EB8-4DE8-B448-C5EF20AE9E3A"
      },
      {
        "timestamp" : 763445898.454919,
        "data" : {
          "label" : "Logged Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "06158A8E-8E13-42F6-947B-B400448F2E9E"
              },
              {
                "assertCode" : {
                  "dailyGoalResult" : {
                    "_0" : {
                      "result" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          },
                          "result" : 1
                        }
                      },
                      "label" : "Exercise",
                      "date" : 763444800,
                      "dailyGoalId" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      },
                      "recorded" : 763445898.454464,
                      "id" : {
                        "id" : "06158A8E-8E13-42F6-947B-B400448F2E9E"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "00BE491F-EB93-4348-99F3-F1D10BC78908"
      },
      {
        "id" : "7501D992-BC13-4381-886B-4DD4E2D301EA",
        "timestamp" : 763445892.030765,
        "data" : {
          "label" : "Edit Daily List: Daily",
          "assertions" : {
            "storage" : [
              {
                "id" : "98073C89-3F43-4B9F-B892-5E4589F56E8C"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "id" : {
                        "id" : "98073C89-3F43-4B9F-B892-5E4589F56E8C"
                      },
                      "sectionIds" : [
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        },
                        {
                          "id" : "9C27ECB9-6DEE-4603-857B-6C08910EF46C"
                        }
                      ],
                      "active" : true,
                      "label" : "Daily",
                      "weekdays" : [
                        7,
                        6,
                        5,
                        4,
                        3,
                        2,
                        1
                      ]
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "id" : "9137DA54-BC32-4A52-8C25-3F1DB06C0ACE",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
              },
              {
                "assertCode" : {
                  "dailyGoalListSection" : {
                    "_0" : {
                      "goalIds" : [
                        {
                          "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                        },
                        {
                          "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                        },
                        {
                          "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                        }
                      ],
                      "label" : "Health",
                      "active" : true,
                      "id" : {
                        "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Edit Goal Group: Health"
        },
        "timestamp" : 763445642.035767
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
              },
              {
                "assertCode" : {
                  "dailyGoal" : {
                    "_0" : {
                      "type" : "Positive",
                      "config" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "id" : {
                        "id" : "68050712-7F66-4752-838E-CF2CD82EF275"
                      },
                      "label" : "Clean Home",
                      "active" : true
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Goal: Clean Home"
        },
        "id" : "D8329DB1-2C52-4847-AB3D-38A87FBD9688",
        "timestamp" : 763445629.870119
      },
      {
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "0AD4F76C-CF5C-41E7-80ED-DF81E887A21F"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "sectionIds" : [
                        {
                          "id" : "9C27ECB9-6DEE-4603-857B-6C08910EF46C"
                        },
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        }
                      ],
                      "id" : {
                        "id" : "0AD4F76C-CF5C-41E7-80ED-DF81E887A21F"
                      },
                      "weekdays" : [
                        7,
                        6,
                        5,
                        4,
                        3,
                        2,
                        1
                      ],
                      "active" : true,
                      "label" : "Daily"
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Daily List: Daily"
        },
        "timestamp" : 763445532.266137,
        "id" : "936CAD06-8DE0-4ED2-8E04-D1B6A83AE3B6"
      },
      {
        "timestamp" : 763445505.86841,
        "id" : "5D6BAB65-3B97-42B5-93FC-F575C3B25871",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "98073C89-3F43-4B9F-B892-5E4589F56E8C"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "id" : {
                        "id" : "98073C89-3F43-4B9F-B892-5E4589F56E8C"
                      },
                      "active" : true,
                      "sectionIds" : [
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        },
                        {
                          "id" : "9C27ECB9-6DEE-4603-857B-6C08910EF46C"
                        }
                      ],
                      "weekdays" : [

                      ],
                      "label" : "Daily"
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Daily List: Daily"
        }
      },
      {
        "id" : "8B7036F2-7E23-4C5D-967B-DE728788B90E",
        "timestamp" : 763445481.808262,
        "data" : {
          "label" : "Edit Daily List: Work Night",
          "assertions" : {
            "storage" : [
              {
                "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "sectionIds" : [
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        }
                      ],
                      "label" : "Work Night",
                      "active" : true,
                      "weekdays" : [

                      ],
                      "id" : {
                        "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
                      }
                    }
                  }
                }
              }
            ]
          }
        }
      },
      {
        "id" : "129FD47C-80C3-4DD5-B1E9-FFDF01641676",
        "timestamp" : 763445435.96157,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "9C27ECB9-6DEE-4603-857B-6C08910EF46C"
              },
              {
                "assertCode" : {
                  "dailyGoalListSection" : {
                    "_0" : {
                      "id" : {
                        "id" : "9C27ECB9-6DEE-4603-857B-6C08910EF46C"
                      },
                      "label" : "Career",
                      "active" : true,
                      "goalIds" : [
                        {
                          "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                        }
                      ]
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Goal Group: Career"
        }
      },
      {
        "id" : "3C056B1A-6793-478D-805E-2D16BD829873",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "active" : true,
                      "id" : {
                        "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
                      },
                      "weekdays" : [
                        2,
                        1,
                        3,
                        4,
                        5
                      ],
                      "label" : "Work Night",
                      "sectionIds" : [
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        }
                      ]
                    }
                  }
                }
              }
            ]
          },
          "label" : "Edit Daily List: Work Night"
        },
        "timestamp" : 763445370.963365
      },
      {
        "id" : "587DB48E-BC5B-46B3-9DDB-7839C86076D2",
        "data" : {
          "label" : "Create Daily List: Work Night",
          "assertions" : {
            "storage" : [
              {
                "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
              },
              {
                "assertCode" : {
                  "dailyGoalList" : {
                    "_0" : {
                      "label" : "Work Night",
                      "id" : {
                        "id" : "AA3916DF-EB3E-4EB9-8A5E-14CC7F6F306C"
                      },
                      "active" : true,
                      "weekdays" : [

                      ],
                      "sectionIds" : [
                        {
                          "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                        }
                      ]
                    }
                  }
                }
              }
            ]
          }
        },
        "timestamp" : 763445357.748654
      },
      {
        "id" : "EC1B13CE-0D3A-423D-83F1-6261175EF1E6",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
              },
              {
                "assertCode" : {
                  "dailyGoalListSection" : {
                    "_0" : {
                      "active" : true,
                      "label" : "Health",
                      "id" : {
                        "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                      },
                      "goalIds" : [
                        {
                          "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                        },
                        {
                          "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                        }
                      ]
                    }
                  }
                }
              }
            ]
          },
          "label" : "Edit Goal Group: Health"
        },
        "timestamp" : 763430587.948503
      },
      {
        "timestamp" : 763421776.217161,
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
              },
              {
                "assertCode" : {
                  "dailyGoalListSection" : {
                    "_0" : {
                      "active" : true,
                      "goalIds" : [
                        {
                          "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                        },
                        {
                          "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                        }
                      ],
                      "label" : "Health",
                      "id" : {
                        "id" : "046EF0E2-1133-4FCE-9858-DA59C4803BFE"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Goal Group: Health"
        },
        "id" : "A64357D5-88BF-4203-9742-12BC4344D5B8"
      },
      {
        "timestamp" : 763421696.814646,
        "data" : {
          "label" : "Create Goal: Dev Sprints",
          "assertions" : {
            "storage" : [
              {
                "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
              },
              {
                "assertCode" : {
                  "dailyGoal" : {
                    "_0" : {
                      "type" : "Neutral",
                      "label" : "Dev Sprints",
                      "active" : true,
                      "config" : {
                        "count" : {
                          "goals" : {
                            "storage" : [
                              2,
                              4
                            ]
                          }
                        }
                      },
                      "id" : {
                        "id" : "E3C1F262-A8E2-40FC-8F8B-BA896E24325C"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "id" : "A6FBFA31-4ACC-4554-8844-22CE28D60D92"
      },
      {
        "id" : "548D4CEB-6213-44AB-A66E-426D744BE044",
        "data" : {
          "assertions" : {
            "storage" : [
              {
                "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
              },
              {
                "assertCode" : {
                  "dailyGoal" : {
                    "_0" : {
                      "label" : "Sleep",
                      "type" : "Neutral",
                      "active" : true,
                      "config" : {
                        "number" : {
                          "goals" : {
                            "storage" : [
                              6,
                              7,
                              8
                            ]
                          }
                        }
                      },
                      "id" : {
                        "id" : "0D3FDB11-96D7-46E5-8394-5792E60A979D"
                      }
                    }
                  }
                }
              }
            ]
          },
          "label" : "Create Goal: Sleep"
        },
        "timestamp" : 763421593.15143
      },
      {
        "data" : {
          "label" : "Create Goal: Exercise",
          "assertions" : {
            "storage" : [
              {
                "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
              },
              {
                "assertCode" : {
                  "dailyGoal" : {
                    "_0" : {
                      "label" : "Exercise",
                      "type" : "Neutral",
                      "active" : true,
                      "config" : {
                        "completion" : {
                          "steps" : {
                            "linear" : {
                              "steps" : 2
                            }
                          }
                        }
                      },
                      "id" : {
                        "id" : "349E933D-5D22-476C-AF8F-C9F6B9D12B1F"
                      }
                    }
                  }
                }
              }
            ]
          }
        },
        "timestamp" : 763421564.642519,
        "id" : "B5612B1B-2EBD-4B6E-9971-A225516FDC9F"
      }
    ]
    """
}
