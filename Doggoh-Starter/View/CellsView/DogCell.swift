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
    
    var viewmodel: DogCellViewModel? {
        didSet {
            dogNameLabel.text = viewmodel?.dogName
            if let dogImageData = viewmodel?.dogImageData {
                dogImageView.image = UIImage(data: dogImageData)
            }
            else {
                dogImageView.image = UIImage(named: "no_image")
//                let loadingView = UIView(frame: dogImageView.frame)
//                loadingView.backgroundColor = .clear
//                let ai = UIActivityIndicatorView()
//                ai.center = loadingView.center
//                ai.style = .gray
//                ai.backgroundColor = .red
//                ai.startAnimating()
//                loadingView.addSubview(ai)
//                self.addSubview(loadingView)
            }
        }
    }
    
    func setDogCell(dogRace: String, dogImage: UIImage) {
        dogNameLabel.text = dogRace
        dogImageView.image = dogImage
    }
    
    override func awakeFromNib() {
        let ai = UIActivityIndicatorView()
        ai.center = dogImageView.center
        ai.style = .gray
        ai.backgroundColor = .red
        ai.startAnimating()
    }
}
