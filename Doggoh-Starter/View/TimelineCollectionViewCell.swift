//
//  TimelineCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    
    var dog: Dog! {
        didSet {
            dogNameLabel.text = dog.dogRace
        }
    }
    
    func setDogImage(dogImage: UIImage) {
        dogImageView.image = dogImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImageView.layer.cornerRadius = 22
        dogNameLabel.textColor = .white
        dogNameLabel.font = UIFont(name: "Montserrat-Bold", size: 14)
    }

}
