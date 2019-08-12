//
//  AnswerButton.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum AnswerButtonType {
    case option
    case profileOption
    case next, begin, finish
    
    var width: CGFloat {
        switch self {
        case .option:
            return 152.5
        default:
            return 175
        }
    }
    
    var height: CGFloat {
        switch self {
        case .option:
            return 48
        case .profileOption:
            return 32
        default:
            return 50
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .option:
            return 2
        default:
            return 0
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .option:
            return UIColor.lightGray.cgColor
        default:
            return UIColor.red.cgColor
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .option:
            return UIColor.white
        case .profileOption:
            return UIColor(red: 229 / 255, green: 230 / 255, blue: 236 / 255, alpha: 1)
        default:
            return UIColor(red: 241 / 255, green: 89 / 255, blue: 32 / 255, alpha: 1)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .option:
            return UIColor.black
        case .profileOption:
            return UIColor(red: 181 / 255, green: 184 / 255, blue: 199 / 255, alpha: 1)
        default:
            return UIColor.white
        }
    }
}

class AnswerButton: UIButton {
    
    func configure(type: AnswerButtonType) {
        switch type {
        case .option, .begin:
            layer.cornerRadius = layer.frame.height / 2
            layer.frame.size = CGSize(width: type.width, height: type.height)
        default:
            layer.cornerRadius = 14
            layer.borderWidth = type.borderWidth
        }
        
        layer.borderColor = type.borderColor
        backgroundColor = type.bgColor
        setTitleColor(type.textColor, for: .normal)
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
    }
    
    func didSelect(type: AnswerButtonType) {
        switch type {
        case .option:
            backgroundColor = .lightGray
            setTitleColor(UIColor(red: 241/255, green: 89/255, blue: 32/255, alpha: 1), for: .normal)
        default:
            backgroundColor = UIColor(red: 244 / 255, green: 112 / 255, blue: 62 / 255, alpha: 1)
            setTitleColor(.white, for: .normal)
        }
    }
    
    func didDeselect(type: AnswerButtonType) {
            backgroundColor = type.bgColor
            setTitleColor(type.textColor, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        var superSize = super.intrinsicContentSize
        superSize.width += 20
        return superSize
    }

}
