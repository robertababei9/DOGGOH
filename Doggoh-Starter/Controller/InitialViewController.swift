//
//  ViewController.swift
//  Doggoh-Starter
//
//  Created by Razvan Apostol on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var beginButton: AnswerButton!
    
    var score: Int = 0
    var coordinator: QuizCoordinator!
    var myTabBarControler: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtons()
    }
    
    func setupButtons() {
        beginButton.configure(type: .begin)
    }
    
    
    @IBAction func beginButtonPressed(_ sender: UIButton) {
        if let json = DogRepository.getDataFromJSON(withName: DogRepository.fileName) {
            let pool = StatementPool(data: json)
            let statements = pool.getStatementPool()
            coordinator = QuizCoordinator(statements: statements)
            coordinator.flowDelegate = self
            coordinator.startQuiz()
        }
    }
    
}

extension InitialViewController: QuizFlowDelegate {
    
    func willStartQuiz(insideNavigationController: UINavigationController) {
        present(insideNavigationController, animated: true, completion: nil)
    }
    
    func didFinishQuiz(resultVC: UIViewController) {
        if let _ = tabBarController?.viewControllers {
            tabBarController?.viewControllers![3] = resultVC
        }
        self.tabBarController?.selectedIndex = 3
        
        
    }
}


