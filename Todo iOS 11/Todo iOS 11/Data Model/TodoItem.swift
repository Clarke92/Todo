//
//  TodoItem.swift
//  Todo iOS 11
//
//  Created by Maximilian Dufter on 26.02.18.
//  Copyright © 2018 Maximilian Dufter. All rights reserved.
//

import Foundation

// Encodables/Decodables must have standard data types
class TodoItem: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
    
}
