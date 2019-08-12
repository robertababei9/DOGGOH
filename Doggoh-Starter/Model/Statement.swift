//
//  Statement.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class Statement {
    var question: String
    var options: [String]
    var answer: String
    
    init(question: String, options: [String], answer: String) {
        self.answer = answer
        self.options = options
        self.question = question
    }
}
