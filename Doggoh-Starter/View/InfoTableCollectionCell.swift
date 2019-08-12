//
//  InfoTableCollectionCell.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 11/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol InfoTableCollectionCellDelegate {
    func makePhotoFullScreen(dogImage: UIImage)
}

class InfoTableCollectionCell: UICollectionViewCell {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var fullScreenButton: UIButton!
    
    var delegate: InfoTableCollectionCellDelegate?
    
    func setImage(image: UIImage) {
        dogImage.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImage.layer.cornerRadius = 22
    }
    
    @IBAction func fullSreenButtonClicked(_ sender: UIButton) {
        if let unwrappedImage = self.dogImage.image {
            print("Image unwrapped successfully")
            delegate?.makePhotoFullScreen(dogImage: unwrappedImage)
            print("IMAGE ========= \(unwrappedImage)")
        }
    }
    
    
}
