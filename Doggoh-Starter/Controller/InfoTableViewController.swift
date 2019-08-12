//
//  InfoTableViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 11/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class InfoTableViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dogReceived: Dog?
    var infoDog: [DogInfoCell] = [
        DogInfoCell(descriptionTitle: "Temperament", description: "ANGRY"),
        DogInfoCell(descriptionTitle: "HEIGHT & WEIGHT", description: "1.75 - 77KG\n 1.70 - 70KG"),
        DogInfoCell(descriptionTitle: "ABOUT", description: "BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA")
    ]
    var testImage: [UIImage] = [
        UIImage(named: "4")!, UIImage(named: "18")!, UIImage(named: "9")!, UIImage(named: "20")!,
        UIImage(named: "12")!, UIImage(named: "21")!, UIImage(named: "1")!, UIImage(named: "17")!
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InfoTableCell", bundle: Bundle.main), forCellReuseIdentifier: "InfoTableCell")
        tableView.frame.size.width = view.frame.size.width

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = dogReceived?.dogRace.uppercased()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width / 3, bottom: 0, right: 0)
        tableView.tableHeaderView = createViewForHeader()
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func createViewForHeader() -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 400))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let myCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: myView.frame.width, height: 350), collectionViewLayout: layout)
        myCollection.backgroundColor = .clear
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(UINib(nibName: "InfoTableCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "InfoTableCollectionCell")
        
        let myLabel = UILabel(frame: CGRect(x: 25, y: 360, width: myView.frame.width, height: 20))
        myLabel.text = "Some info on \(titleLabel.text ?? "hacked")"
        myLabel.font = UIFont(name: "Montserrat-Light", size: 18)
        
        
        myView.addSubview(myCollection)
        myView.addSubview(myLabel)
        return myView
    }

}

extension InfoTableViewController: UITableViewDelegate {
    
}

extension InfoTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoDog.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableCell", for: indexPath) as! InfoTableCell
        
        let myTitle = infoDog[indexPath.section].descriptionTitle
        let myDescription = infoDog[indexPath.section].description
        
        cell.config(title: myTitle, description: myDescription)
        
        return cell
    }
    
}



extension InfoTableViewController: UICollectionViewDelegateFlowLayout {

}

extension InfoTableViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rndHeight: CGFloat = CGFloat(Int.random(in: 300...350))
        return CGSize(width: 230, height: rndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoTableCollectionCell", for: indexPath) as! InfoTableCollectionCell
        cell.setImage(image: testImage[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension InfoTableViewController: InfoTableCollectionCellDelegate {
    func makePhotoFullScreen(dogImage: UIImage) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        fullScreenVC.theImage = dogImage
        navigationController?.pushViewController(fullScreenVC, animated: true)
    }
}
