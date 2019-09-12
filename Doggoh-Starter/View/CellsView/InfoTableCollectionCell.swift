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
    
    @IBOutlet weak var contentWidthCn: NSLayoutConstraint!
    @IBOutlet weak var contentHeightCn: NSLayoutConstraint!
    
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
            delegate?.makePhotoFullScreen(dogImage: unwrappedImage)
        }
    }
    
    func scaleContent(nr: CGFloat) {
        let scaledWidth = nr * bounds.width
        let scaledHeight = nr * bounds.height
        
        contentWidthCn.constant = -scaledWidth
        contentHeightCn.constant = -scaledHeight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentWidthCn.constant = 0
        contentHeightCn.constant = 0
    }
    
    
}
