//
//  DogTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogCell: UITableViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    
    func setDogCell(dogRace: String, dogImage: UIImage) {
        dogNameLabel.text = dogRace
        dogImageView.image = dogImage
    }
}
