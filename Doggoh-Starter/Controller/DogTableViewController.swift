//
//  DogTableViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allDogs: [Dog] = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 86
        
        if let json = DogRepository.getDataFromJSON(withName: DogRepository.fileNameDogTypes) {
            let pool = DogPool(dict: json)
            allDogs = pool.getDogs()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}



extension DogTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDogs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let paddingLeading: CGFloat = 110
        let headerHeight: CGFloat = 16
        
        // header = UIView ( Label ( race of the dog) ) + leading padding
        // ARATA INGROZITOR
        // ARATA INGROZITOR
        // ARATA INGROZITOR
        if allDogs[section].dogs.count > 0 {
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight + 80))
            
            let delimiterLineView = UIView(frame: CGRect(x: paddingLeading, y: 0, width: tableView.bounds.width - paddingLeading, height: 3))
            delimiterLineView.backgroundColor = UIColor(red: 240 / 255, green: 244 / 255, blue: 248 / 255, alpha: 1.0)
            myView.addSubview(delimiterLineView)
            
            let label = UILabel(frame: CGRect(x: paddingLeading, y: 20, width: tableView.bounds.width - paddingLeading, height: headerHeight))
            label.text = allDogs[section].dogRace.uppercased()
            label.backgroundColor = .white
            label.font = UIFont(name: "Montserrat-Bold", size: 16)
            label.textAlignment = .left
            
            myView.addSubview(label)
            return myView
        // header = dilimitator gray line with padding left
        } else {
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 3))
            
            let label = UILabel(frame: CGRect(x: paddingLeading, y: 0, width: tableView.bounds.width - paddingLeading, height: 3))
//            label.frame.size = CGSize(width: tableView.bounds.width, height: 3)
            label.backgroundColor = UIColor(red: 240 / 255, green: 244 / 255, blue: 248 / 255, alpha: 1.0)
            
            myView.addSubview(label)
            return myView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return allDogs[section].dogs.count > 0 ? tableView.rowHeight / 2 : tableView.rowHeight / 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allDogs[section].dogRace
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there is no dog => keep 1 cell just for race
        return allDogs[section].dogs.count > 0 ? allDogs[section].dogs.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogCell
        let rnd = Int.random(in: 0...22)
        
        //
        if allDogs[indexPath.section].dogs.count > 0 {
            cell.setDogCell(dogRace: allDogs[indexPath.section].dogs[indexPath.row] , dogImage: UIImage(named: "\(rnd)")!)
            cell.dogNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        } else {
            cell.setDogCell(dogRace: allDogs[indexPath.section].dogRace.uppercased() , dogImage: UIImage(named: "\(rnd)")!)
            cell.dogNameLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "makingTransition", sender: allDogs[indexPath.section])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoTableVC = segue.destination as! InfoTableViewController
        infoTableVC.dogReceived = sender as? Dog
    }

    
    
}
