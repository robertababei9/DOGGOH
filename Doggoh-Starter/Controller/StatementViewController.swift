//
//  StatementViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol QuizDelegate: class {
    func userDidAnswerQuestion(atIndex index: Int, withCorrectAnswer answer: Bool)
}

class StatementViewController: UIViewController {

    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var questionLabel: UITextView!
    @IBOutlet weak var optionBtnA: AnswerButton!
    @IBOutlet weak var optionBtnB: AnswerButton!
    @IBOutlet weak var optionBtnC: AnswerButton!
    @IBOutlet weak var optionBtnD: AnswerButton!
    @IBOutlet weak var nextQuestionBtn: AnswerButton!
    
    var statement: Statement!
    var itemIndex: Int!
    var totalItems: Int!
    var answerChosed: String!
    
    weak var delegate: QuizDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
        update(withStatement: statement, atIndex: itemIndex, inTotatl: totalItems)
    }

    
    @IBAction func optionClicked(_ sender: UIButton) {
        nextQuestionBtn.isEnabled = true
        nextQuestionBtn.backgroundColor = UIColor.init(red: 241/255, green: 89/255, blue: 32/255, alpha: 1)
    
        let allButtons = [optionBtnA, optionBtnB, optionBtnC, optionBtnD]
        let dictButtons = [optionBtnA: "a", optionBtnB: "b", optionBtnC: "c", optionBtnD: "d",]
        
        for item in allButtons {
            if sender == item {
                item?.didSelect(type: .option)
                answerChosed = dictButtons[item]
            } else {
                item?.didDeselect(type: .option)
            }
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        delegate?.userDidAnswerQuestion(atIndex: itemIndex, withCorrectAnswer: evaluate(statement: statement, answer: answerChosed))
    }
    
    func configure() {
        optionBtnA.configure(type: .option)
        optionBtnB.configure(type: .option)
        optionBtnC.configure(type: .option)
        optionBtnD.configure(type: .option)
        nextQuestionBtn.configure(type: .next)
    }
    
    func update(withStatement statement: Statement, atIndex index: Int, inTotatl total: Int) {
        progressLabel.text = "\(index + 1)/\(total)"
        questionLabel.text = statement.question

        let allButtons = [optionBtnA, optionBtnB, optionBtnC, optionBtnD]
        var i = 0
        for item in allButtons {
            item?.setTitle(statement.options[i], for: .normal)
            i += 1
        }
        
        nextQuestionBtn.isEnabled = false
        nextQuestionBtn.backgroundColor = UIColor(displayP3Red: 237/255, green: 175/255, blue: 148/255, alpha: 0.8)
        
        if index == 9 {
            nextQuestionBtn.setTitle("FINISH", for: .normal)
        }
        
    }
    
    func evaluate(statement: Statement, answer: String) -> Bool {
        return statement.answer == answer
    }
}
