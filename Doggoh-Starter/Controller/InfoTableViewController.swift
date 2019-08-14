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
        UIImage(named: "4")!, UIImage(named: "18")!, UIImage(named: "9")!, UIImage(named: "20")!,
        UIImage(named: "12")!, UIImage(named: "21")!, UIImage(named: "1")!, UIImage(named: "17")!
    ]
    
    var tableHeaderView: UIView!
    var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogTitle = dogReceived?.dogRace.uppercased() ?? "Nil value"
        tableHeaderView = createViewForHeader()
        pageController = (tableHeaderView.subviews[1] as! UIPageControl)
        
        
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
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: infoListView.frame.width, height: 420))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let myCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: myView.frame.width, height: 350), collectionViewLayout: layout)
        myCollection.backgroundColor = .clear
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(UINib(nibName: "InfoTableCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "InfoTableCollectionCell")
        
        let myPageController = UIPageControl(frame: CGRect(x: 0, y: 360, width: myView.bounds.width, height: 20))
        myPageController.backgroundColor = .gray
        myPageController.numberOfPages = testImage.count
        let page = myCollection.contentOffset.x / myCollection.frame.width
        myPageController.currentPage = Int(page)
        
        let myLabel = UILabel(frame: CGRect(x: 25, y: 400, width: myView.frame.width, height: 20))
        myLabel.text = "Some info on \(dogTitle)"
        myLabel.font = UIFont(name: "Montserrat-Light", size: 18)
        
        
        myView.addSubview(myCollection)
        myView.addSubview(myPageController)
        myView.addSubview(myLabel)

        return myView
    }

}



extension InfoTableViewController: UICollectionViewDelegateFlowLayout {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let collectionFromHeader = tableHeaderView.subviews[0] as! UICollectionView
//        let myX = collectionFromHeader.frame.midX
//        let myY = collectionFromHeader.frame.midY
//        let collectionViewCenterPoint = view.convert(CGPoint(x: myX, y: myY), to: collectionFromHeader)
//        let indexPath = collectionFromHeader.indexPathForItem(at: collectionViewCenterPoint)
//        print(indexPath)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionFromHeader = tableHeaderView.subviews[0] as! UICollectionView
        let myX = collectionFromHeader.frame.midX
        let myY = collectionFromHeader.frame.midY
        let collectionViewCenterPoint = view.convert(CGPoint(x: myX, y: myY), to: collectionFromHeader)
        let indexPath = collectionFromHeader.indexPathForItem(at: collectionViewCenterPoint)
        
        if let unwrappedIndexPath = indexPath {
            pageController.currentPage = unwrappedIndexPath.row
        }
    }
    
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
