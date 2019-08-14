//
//  InfoTableView.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 13/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

class InfoTableView: UIView {
    
    struct Info {
        var title: String = ""
        var description: String = ""
    }
    
    var infoArray: [Info] = []
    var tableView: UITableView
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: frame)
        super.init(frame: frame)
        self.addSubview(tableView)
        setupTableView(tableView: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: .zero)
        super.init(coder: aDecoder)
        self.addSubview(tableView)
        setupTableView(tableView: tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width / 3, bottom: 0, right: 0)
    }
    
    ///
    func displayInfoList(infoArray: [Info], withHeader: UIView) {
        self.infoArray = infoArray
        tableView.reloadData()
        tableView.tableHeaderView = withHeader
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InfoTableCell", bundle: Bundle.main), forCellReuseIdentifier: "InfoTableCell")
        tableView.separatorStyle = .none
    }
    
}

extension InfoTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableCell", for: indexPath) as! InfoTableCell
        
        let title = infoArray[indexPath.section].title
        let myDescription = infoArray[indexPath.section].description
        
        cell.config(title: title, description: myDescription)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width / 3, bottom: 0, right: 0)
        
        return cell
    }
    
}
