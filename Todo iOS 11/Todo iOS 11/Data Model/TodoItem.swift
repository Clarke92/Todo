//
//  TodoItem.swift
//  Todo iOS 11
//
//  Created by Maximilian Dufter on 26.02.18.
//  Copyright © 2018 Maximilian Dufter. All rights reserved.
//

import Foundation

// Encodables must have standard data types
class TodoItem: Encodable {
    var title: String = ""
    var done: Bool = false
    
    
}
