//
//  DogProfileCollectionCell.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 13/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogProfileCollectionCell: UICollectionViewCell {

    @IBOutlet weak var characterButton: AnswerButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureButton() {
        characterButton.configure(type: .profileOption)
//        backgroundColor = .red
//        characterButton.layer.cornerRadius = characterButton.layer.frame.height / 2
//        characterButton.clipsToBounds = true
//        clipsToBounds = true
    }

}
