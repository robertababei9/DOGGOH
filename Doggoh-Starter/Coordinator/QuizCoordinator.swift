//
//  QuizCoordinator.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 05/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol QuizFlowDelegate: class {
    func willStartQuiz(insideNavigationController: UINavigationController)
    func didFinishQuiz(resultVC: UIViewController)
}

class QuizCoordinator {
    
    private var statements: [Statement]
    private var currentStatementIndex: Int = 0
    private var score: Int = 0
    internal var navigationController: UINavigationController? = nil
    
    weak var flowDelegate: QuizFlowDelegate?
    
    init(statements: [Statement]) {
        self.statements = statements
    }
    
    func startQuiz() {
        if let firstStatement = statements.first,
            let firstQuizVC = getQuizViewController(forStatement: firstStatement, withIndex: 0, inTotal: statements.count) {
            navigationController = UINavigationController(rootViewController: firstQuizVC)
            navigationController?.navigationBar.isHidden = true
            currentStatementIndex = 0
            flowDelegate?.willStartQuiz(insideNavigationController: navigationController!)
        }
    }
    
    func getQuizViewController(forStatement statement: Statement, withIndex index: Int, inTotal total: Int) -> StatementViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "StatementVC") as? StatementViewController
        newViewController?.statement = statement
        newViewController?.itemIndex = index
        newViewController?.totalItems = total
        newViewController?.delegate = self
        return newViewController
    }   
    
    func getResultViewController(withScore score: Int) -> ResultViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        newViewController?.score = score
        newViewController?.maxScore = statements.count
        newViewController?.delegate = self
        return newViewController
    }
}

extension QuizCoordinator: QuizDelegate {
    func userDidAnswerQuestion(atIndex index: Int, withCorrectAnswer answer: Bool) {
        score += answer ? 1 : 0
        if currentStatementIndex < statements.count - 1 {
            currentStatementIndex += 1
            if let newQuizzVC = getQuizViewController(forStatement: statements[currentStatementIndex], withIndex: currentStatementIndex, inTotal: statements.count) {
                navigationController?.pushViewController(newQuizzVC, animated: true)
                print("Score = \(score)")
            }
        }
        else {
            score += answer ? 1 : 0
            if let resultVC = getResultViewController(withScore: score) {
                navigationController?.dismiss(animated: true, completion: nil)
                flowDelegate?.didFinishQuiz(resultVC: resultVC)
            }
            print("Reached the end of the quiz !!!!!!!!!!")
            print("Score = \(score)")
        }
    }
}

extension QuizCoordinator: ResultDelegate {
    func userDidReset() {
        
    }
}
