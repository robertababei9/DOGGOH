//
//  DogProfileViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 06/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogProfileViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet var ageButtons: [AnswerButton]!
    @IBOutlet var genderButtons: [AnswerButton]!
    @IBOutlet var characterButtons: [AnswerButton]!
    
    //force unwrap because we will made this view
    var myView: UIView!
    
    //dict to see which character button is selected
    private var charBtnSelected = [String?: Bool]()
    private var allDogs: [Dog] = [Dog]()
    
    private var counterPicker: Int = 0
    private var selectedRow: Dog = Dog(dogRace: "Wilkinson", dogs: [])
    var dogBeforeCancel: Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initializing all dogs
        if let json = DogRepository.getDataFromJSON(withName: DogRepository.fileNameDogTypes) {
            let pool = DogPool(dict: json)
            allDogs = pool.getDogs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
        ageButtons[0].layer.bounds.size = CGSize(width: 50, height: 32)
        
    }
    
    func configure() {
        ageButtons.forEach( {
            $0.configure(type: .profileOption)
        })
        genderButtons.forEach( {
            $0.configure(type: .profileOption)
        })
        characterButtons.forEach( {
            $0.configure(type: .profileOption)
            if let btnLabelText = $0.titleLabel?.text {
                charBtnSelected[btnLabelText] = false
            }
        })
        
        selectionButton.layer.cornerRadius = 15
        selectionButton.titleEdgeInsets = UIEdgeInsets(top: 1, left: -50, bottom: 1, right: 1)
        profileImage.layer.cornerRadius = 16
        selectionView.layer.cornerRadius = 22
    }
    @IBAction func selectionButtonClicked(_ sender: Any) {
        //we use counterPicker to be sure that only one view will be displayed
        //when the button is pressed
        if counterPicker == 0 {
            let pickerHeight: CGFloat = 250
            let toolBarHeight: CGFloat = 40
            dogBeforeCancel = selectedRow
            
            myView = UIView(frame: CGRect(x: 0 , y: view.bounds.height - pickerHeight, width: view.bounds.width, height: pickerHeight))
            myView.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
            myView.alpha = 0.93
            
            let breedPicker = UIPickerView(frame: CGRect(x: 0, y: toolBarHeight, width: myView.bounds.width, height: pickerHeight - toolBarHeight))
            breedPicker.delegate = self
            breedPicker.dataSource = self
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: myView.bounds.width, height: toolBarHeight))
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicked))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
            
            let finalPosition = selectionView.frame.maxY - (view.frame.height - myView.frame.height)
            scrollView.setContentOffset(CGPoint(x: 0, y: finalPosition), animated: true)
            
            myView.addSubview(toolbar)
            myView.addSubview(breedPicker)
            self.view.addSubview(myView)
            counterPicker += 1
        }
        
    }
    
    @objc func cancelBtnClicked() {
        myView.removeFromSuperview()
        breedNameLabel.text = dogBeforeCancel?.dogRace
        breedNameLabel.alpha = 1
        counterPicker = 0
    }
    
    @objc func doneBtnClicked() {
        selectionButton.setTitle(selectedRow.dogRace, for: .normal)
        profileImage.image = selectedRow.dogImage
        breedNameLabel.text = selectedRow.dogRace
        breedNameLabel.alpha = 1
        infoLabel.text = "Some info on \(selectedRow.dogRace)"
        myView.removeFromSuperview()
        counterPicker = 0
        
        //go up to see the changes
        let finalPosition = selectionView.frame.maxY - (view.frame.height - myView.frame.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: finalPosition), animated: true)
    }
    
    @IBAction func ageButtonClicked(_ sender: AnswerButton) {
        for button in ageButtons {
            if sender == button {
                button.didSelect(type: .profileOption)
            } else {
                button.didDeselect(type: .profileOption)
            }
        }
    }
    
    @IBAction func genderButtonClicked(_ sender: AnswerButton) {
        for button in genderButtons {
            if sender == button {
                button.didSelect(type: .profileOption)
            } else {
                button.didDeselect(type: .profileOption)
            }
        }
    }
    
    @IBAction func characterButtonClicked(_ sender: AnswerButton) {
        for button in characterButtons {
            if sender == button {
                if charBtnSelected[sender.titleLabel?.text] == false {
                    button.didSelect(type: .profileOption)
                    charBtnSelected[sender.titleLabel?.text]?.toggle()
                } else {
                    button.didDeselect(type: .profileOption)
                    charBtnSelected[sender.titleLabel?.text]?.toggle()
                }
            }
        }
    }
}


extension DogProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Component = \(component) --- row = \(row)")
        selectedRow = allDogs[row]
        breedNameLabel.text = allDogs[row].dogRace
        breedNameLabel.alpha = 0.5
    }
    
    
}

extension DogProfileViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allDogs[row].dogRace
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDogs.count
    }
    
    
    
}
