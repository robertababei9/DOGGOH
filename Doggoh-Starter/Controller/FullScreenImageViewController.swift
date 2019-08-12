//
//  FullScreenImageViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 12/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var dogImageView: UIImageView!
    
    var theImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.image = theImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dogImageView.layer.cornerRadius = 22
        
    }
    @IBAction func resizeButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
