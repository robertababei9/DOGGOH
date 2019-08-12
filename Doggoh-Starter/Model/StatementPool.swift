//
//  StatementPool.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class StatementPool {
    
    var pool: [Statement]
    
    init(data: Dictionary<String, AnyObject>?) {
        pool = [Statement]()
        
        if let statementCollection = data?["questions"] as? [[String: AnyObject]] {
            statementCollection.forEach( {
                if let answer = $0["answer"] as? String,
                    let question = $0["question"] as? String,
                    let options = $0["options"] as? [String]{
                        let newStatement = Statement(question: question, options: options, answer: answer)
                        pool.append(newStatement)
                }
            })
        }
    }
    
    func getStatementPool() -> [Statement]{
        var result = [Statement]()
        if pool.count >  10 {
            var poolCopy = pool
            while result.count < 10 {
                let rndNr = Int.random(in: 0..<poolCopy.count)
                result.append(poolCopy[rndNr])
                poolCopy.remove(at: rndNr)
            }
        }
        return result
    }
    
    
}
