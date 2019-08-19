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
    
    let apiClient = DogAPIClient.sharedInstance
    
    var allDogs: [Dog] = [Dog]()
    
    var auxImg: UIImage?
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 86
        
//        if let json = DogRepository.getDataFromJSON(withName: DogRepository.fileNameDogTypes) {
//            let pool = DogPool(dict: json)
//            //allDogs = pool.getDogs()
//        }
        
        apiClient.getAllDogs { result in
            switch result {
            case .success(let allDogs):
                self.allDogs = allDogs
//                self.getImageForDogs()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
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
        if allDogs[section].subBreed.count > 0 {
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight + 80))
            
            let delimiterLineView = UIView(frame: CGRect(x: paddingLeading, y: 0, width: tableView.bounds.width - paddingLeading, height: 3))
            delimiterLineView.backgroundColor = UIColor(red: 240 / 255, green: 244 / 255, blue: 248 / 255, alpha: 1.0)
            myView.addSubview(delimiterLineView)
            
            let label = UILabel(frame: CGRect(x: paddingLeading, y: 20, width: tableView.bounds.width - paddingLeading, height: headerHeight))
            label.text = allDogs[section].breed.uppercased()
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
        return allDogs[section].subBreed.count > 0 ? tableView.rowHeight / 2 : tableView.rowHeight / 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allDogs[section].breed
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there is no dog => keep 1 cell just for race
        return allDogs[section].subBreed.count > 0 ? allDogs[section].subBreed.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogCell
        let rnd = Int.random(in: 0...22)
        //
        if allDogs[indexPath.section].subBreed.count > 0 {
            
            if let cachedImage = imageCache.object(forKey: self.allDogs[indexPath.section].subBreed[indexPath.row] as NSString) {
                cell.setDogCell(dogRace: self.allDogs[indexPath.section].subBreed[indexPath.row] , dogImage: cachedImage)
            }
            else {
                apiClient.getImageBySubBreed(breedName: allDogs[indexPath.section].breed, subBreedName: allDogs[indexPath.section].subBreed[indexPath.row]) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        
                    case .success(let image):
                        //print(image)
                        let imageUrl = image.imageURL
                        do {
                            let data = try Data(contentsOf: URL(string: imageUrl)!)
                            let img = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.imageCache.setObject(img!, forKey: self.allDogs[indexPath.section].subBreed[indexPath.row] as NSString)
                                cell.setDogCell(dogRace: self.allDogs[indexPath.section].subBreed[indexPath.row] , dogImage: img!)
                            }
                        }
                        catch let error{
                            print(error)
                        }
                    }
                }
            }
            cell.dogNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        } else {
            if let cachedImage = imageCache.object(forKey: allDogs[indexPath.section].breed as NSString) {
                cell.setDogCell(dogRace: self.allDogs[indexPath.section].breed.uppercased() , dogImage: cachedImage)
            }
            else {
                apiClient.getImageByBreed(breedName: allDogs[indexPath.section].breed) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        
                    case .success(let image):
                        //print(image)
                        let imageUrl = image.imageURL
                        do {
                            let data = try Data(contentsOf: URL(string: imageUrl)!)
                            let img = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.imageCache.setObject(img!, forKey: self.allDogs[indexPath.section].breed as NSString)
                                cell.setDogCell(dogRace: self.allDogs[indexPath.section].breed.uppercased() , dogImage: img!)
                            }
                        }
                        catch let error{
                            print(error)
                        }
                    }
                }
            }
           // cell.setDogCell(dogRace: allDogs[indexPath.section].breed.uppercased() , dogImage: img!)
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
