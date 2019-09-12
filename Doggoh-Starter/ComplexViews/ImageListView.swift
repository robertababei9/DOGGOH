//
//  ImageListView.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 14/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

class ImageListView: UIView {
    
    let collectionView: UICollectionView
    var myLabel: UILabel?
    var myPageController: UIPageControl?
    var testImage: [UIImage] = []
    var delegate: InfoTableCollectionCellDelegate?
    
    func setupWith(imageArray: [UIImage], title: String) {
        myLabel?.text = "Some info on \(title)"
        testImage = imageArray
        myPageController?.numberOfPages = testImage.count
        collectionView.reloadData()
    }
    
    
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        addSubview(collectionView)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
        addSubview(collectionView)
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 320)
        print("Layout subViews")
        myPageController?.frame = CGRect(x: 0, y: 330, width: self.bounds.width, height: 20)
        myLabel?.frame = CGRect(x: 20, y: 360, width: self.bounds.width, height: 20)
//        backgroundColor = .blue
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 320)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InfoTableCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "InfoTableCollectionCell")
        
        myPageController = UIPageControl(frame: .zero)
        myPageController?.numberOfPages = testImage.count
        myPageController?.pageIndicatorTintColor = .lightGray
        myPageController?.currentPageIndicatorTintColor = .black
        
        myLabel = UILabel(frame: .zero)
        myLabel?.font = UIFont(name: "Montserrat-Light", size: 18)

        addSubview(myPageController!)
        addSubview(myLabel!)
        
    }
    
    func reloadDataForCollection(with newImages: [UIImage]) {
        testImage = newImages
        myPageController?.numberOfPages = testImage.count
        collectionView.reloadData()
    }
    
}

extension ImageListView: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionFromHeader = collectionView
        let myX = collectionFromHeader.frame.midX
        let myY = collectionFromHeader.frame.midY
        let collectionViewCenterPoint = self.convert(CGPoint(x: myX, y: myY), to: collectionFromHeader)
        let indexPath = collectionFromHeader.indexPathForItem(at: collectionViewCenterPoint)
        
        if let unwrappedIndexPath = indexPath {
            
            if unwrappedIndexPath.row - 1 >= 0 {
                let newIndexpath = IndexPath(row: unwrappedIndexPath.row - 1, section: unwrappedIndexPath.section)
                let cell = collectionFromHeader.cellForItem(at: newIndexpath) as? InfoTableCollectionCell
                cell?.scaleContent(nr: 0.1)
            }
            
            if unwrappedIndexPath.row + 1 < testImage.count{
                let newIndexpath = IndexPath(row: unwrappedIndexPath.row + 1, section: unwrappedIndexPath.section)
                let cell = collectionFromHeader.cellForItem(at: newIndexpath) as? InfoTableCollectionCell
                cell?.scaleContent(nr: 0.1)
            }
            
            myPageController?.currentPage = unwrappedIndexPath.row
            let cell = collectionFromHeader.cellForItem(at: unwrappedIndexPath) as! InfoTableCollectionCell
            cell.scaleContent(nr: 0)
        }
    }
    
}

extension ImageListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let rndHeight: CGFloat = CGFloat(Int.random(in: 300...350))
        return CGSize(width: 230, height: 310)
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
        cell.delegate = self.delegate
        
        return cell
    }
}
