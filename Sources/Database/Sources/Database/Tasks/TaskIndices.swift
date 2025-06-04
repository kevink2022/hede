//
//  Indexes.swift
//  Database
//
//  Created by Kevin Kelly on 12/21/24.
//

import Foundation
import Models
import Assemblages

extension HedeScheduler: StringSortedIndex { }
extension HedeTask: DateSortedIndex { }
extension HedeTag: StringSortedIndex { }
