//
//  ImageType.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 06/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

enum MyImageType {
    case profile
    
}

class ImageType: UIImageView {
    
    func configure() {
        layer.cornerRadius = layer.frame.height / 2
    }
}
