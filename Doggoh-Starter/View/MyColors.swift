//
//  MyColors.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 05/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

enum MyColor {
    case myOrange
    
    var color:UIColor {
        switch self {
        case .myOrange:
            return UIColor(red: 241/255, green: 89/255, blue: 32/255, alpha: 2)
        default:
            return .gray
        }
    }
}

class MyColor
