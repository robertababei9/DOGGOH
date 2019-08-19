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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let charButtonName: [String] = ["QUIET", "CHERFUL", "ACTIVE", "PLAYFUL", "LOUD", "CURIOUS", "VEARY PEACEFUL", "FRIENDLY"]
    private var charButtonCounter = 0
    //dict to see which character button is selected
    private var indexCharBtnSelected = [IndexPath]()
    
    //force unwrap because we will create this view
    private var myView: UIView!
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DogProfileCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DogProfileCollectionCell")
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
////        flowLayout.estimatedItemSize = CGSize(width: 150 , height: 32)
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
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
//        characterButtons.forEach( {
//            $0.configure(type: .profileOption)
//            if let btnLabelText = $0.titleLabel?.text {
//                charBtnSelected[btnLabelText] = false
//            }
//        })
        
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
        breedNameLabel.text = dogBeforeCancel?.breed
        breedNameLabel.alpha = 1
        counterPicker = 0
    }
    
    @objc func doneBtnClicked() {
        selectionButton.setTitle(selectedRow.breed, for: .normal)
        profileImage.image = selectedRow.dogImage
        breedNameLabel.text = selectedRow.breed
        breedNameLabel.alpha = 1
        infoLabel.text = "Some info on \(selectedRow.breed)"
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
}


extension DogProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Component = \(component) --- row = \(row)")
        selectedRow = allDogs[row]
        breedNameLabel.text = allDogs[row].breed
        breedNameLabel.alpha = 0.5
    }
    
    
}

extension DogProfileViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allDogs[row].breed
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDogs.count
    }
}


extension DogProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 35, bottom: 16, right: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexCharBtnSelected.count < 3 {
            let cell = collectionView.cellForItem(at: indexPath) as! DogProfileCollectionCell
            cell.characterButton.didSelect(type: .profileOption)
            indexCharBtnSelected.append(indexPath)
        } else {
            let firstCell = collectionView.cellForItem(at: indexCharBtnSelected[0]) as! DogProfileCollectionCell
            firstCell.characterButton.didDeselect(type: .profileOption)
            indexCharBtnSelected.remove(at: 0)
            
            let actualCell = collectionView.cellForItem(at: indexPath) as! DogProfileCollectionCell
            actualCell.characterButton.didSelect(type: .profileOption)
            indexCharBtnSelected.append(indexPath)
        }
    }

}

extension DogProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.size.width - 35 - 35 - 16 - 16) / 3
        let height: CGFloat = 32

        return CGSize(width: width, height: height)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charButtonName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogProfileCollectionCell", for: indexPath) as! DogProfileCollectionCell
        cell.characterButton.setTitle(charButtonName[indexPath.row], for: .normal)
        cell.configureButton()
        
        return cell
    }
    
    
}
