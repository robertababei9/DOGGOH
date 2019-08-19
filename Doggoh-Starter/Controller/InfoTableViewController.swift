//
//  InfoTableViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 11/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class InfoTableViewController: UIViewController {

    @IBOutlet weak var infoListView: InfoTableView!
    
    
    var dogReceived: Dog?
    var dogTitle: String = ""
    
    var infoDogList: [InfoTableView.Info] = [
        InfoTableView.Info(title: "Temperament", description: "ANGRY"),
        InfoTableView.Info(title: "HEIGHT & WEIGHT", description: "1.75 - 77KG\n 1.70 - 70KG"),
        InfoTableView.Info(title: "ABOUT", description: "BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA")
    ]
    
    var testImage: [UIImage] = [
        UIImage(named: "4")!, UIImage(named: "11")!, UIImage(named: "17")!, UIImage(named: "19")!,
        UIImage(named: "12")!, UIImage(named: "21")!, UIImage(named: "1")!, UIImage(named: "22")!
    ]
    
    var tableHeaderView: UIView!
    var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogTitle = dogReceived?.breed.uppercased() ?? "Nil value"
        tableHeaderView = createViewForHeader()        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = dogTitle
        //        titleLabel.text = dogReceived?.dogRace.uppercased()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        infoListView.displayInfoList(infoArray: infoDogList, withHeader: tableHeaderView)
    }
    
//    @IBAction func backButtonPressed(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
    
    
    func createViewForHeader() -> UIView {
        
        let imageListView: ImageListView = ImageListView(frame:  CGRect(x: 0, y: 0, width: infoListView.frame.width, height: 400))
        
        imageListView.delegate = self
        imageListView.setupWith(imageArray: testImage, title: dogTitle)
        return imageListView
        
        //
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
