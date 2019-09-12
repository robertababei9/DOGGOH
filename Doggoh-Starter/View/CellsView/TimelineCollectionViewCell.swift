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
            dogNameLabel.text = dog.breed
        }
    }
    
    var viewModel: TimelineCellViewModel! {
        didSet {
            dogNameLabel.text = viewModel.dogName
            if let dogImageData = viewModel.dogImageData {
                dogImageView.image = UIImage(data: dogImageData)
            }
            else {
                dogImageView.image = UIImage(named: "no_image")
                
            }
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
