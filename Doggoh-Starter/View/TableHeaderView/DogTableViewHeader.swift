//
//  DogTableViewHeader.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

class DogTableViewHeader {
    
    private static let paddingLeading: CGFloat = 110
    private static let headerHeight: CGFloat = 16
    
    static func getHeaderInTableView(tableView: UITableView, subBreedCount: Int, breedName: String) -> UIView {
        
        if subBreedCount > 0 {
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight + 80))
            
            let delimiterLineView = UIView(frame: CGRect(x: paddingLeading, y: 0, width: tableView.bounds.width - paddingLeading, height: 3))
            delimiterLineView.backgroundColor = UIColor(red: 240 / 255, green: 244 / 255, blue: 248 / 255, alpha: 1.0)
            myView.addSubview(delimiterLineView)
            
            let label = UILabel(frame: CGRect(x: paddingLeading, y: 20, width: tableView.bounds.width - paddingLeading, height: headerHeight))
            label.text = breedName
            label.backgroundColor = .white
            label.font = UIFont(name: "Montserrat-Bold", size: 16)
            label.textAlignment = .left
            
            myView.addSubview(label)
            return myView
            // header = dilimitator gray line with padding left
        }
        else {
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 3))
            
            let label = UILabel(frame: CGRect(x: paddingLeading, y: 0, width: tableView.bounds.width - paddingLeading, height: 3))
            
            label.backgroundColor = UIColor(red: 240 / 255, green: 244 / 255, blue: 248 / 255, alpha: 1.0)
            
            myView.addSubview(label)
            return myView
        }
    }
    
        
}
