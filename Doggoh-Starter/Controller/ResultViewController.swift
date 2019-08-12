//
//  ResultViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 05/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol ResultDelegate: class {
    func userDidReset()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var retakeQuizBtn: AnswerButton!
    @IBOutlet weak var scoreProgressLabel: UILabel!
    
    var score: Int!
    var maxScore: Int!
    var delegate: ResultDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        updateInterface()
    }
    
    @IBAction func retakeBtnPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newInitialVC = storyboard.instantiateViewController(withIdentifier: "InitialVC")
        tabBarController?.viewControllers![3] = newInitialVC
    }
    
    func setupButtons() {
        retakeQuizBtn.configure(type: .finish)
    }
    
    func updateInterface() {
        if let unwrappedScore = score, let unwrappedMaxScore = maxScore {
             scoreProgressLabel.text = "\(unwrappedScore)/\(unwrappedMaxScore)"
        }
    }

}
