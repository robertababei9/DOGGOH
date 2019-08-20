//
//  TimelineViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    let apiClient = DogAPIClient.sharedInstance
    var imageCache = NSCache<NSString, UIImage>()
    
    let edgeInset: CGFloat = 16
    
    var allDogs = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientView()

//        if let json = DogRepository.getDataFromJSON(withName: DogRepository.fileNameDogTypes) {
//            let pool = DogPool(dict: json)
////            allDogs = pool.getDogs()
        
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TimelineCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TimelineCollectionViewCell")
            
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        //geting dogs from url
        apiClient.getAllDogs { result in
            switch result {
            case .success(let allDogs):
                self.allDogs = allDogs
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func addGradientView() {
        gradientView.frame.size.width = view.frame.size.width
        let gradientHeight = gradientView.frame.origin.y + gradientView.frame.size.height - collectionView.frame.origin.y
        collectionView.contentInset = UIEdgeInsets(top: gradientHeight, left: edgeInset, bottom: 0, right: edgeInset)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.84).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        gradient.locations =  [0.0, 1.0]
        gradient.frame = gradientView.bounds
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}

extension TimelineViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edgeInset, bottom: 0, right: edgeInset)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let width: CGFloat = (collectionView.bounds.size.width - edgeInset - edgeInset - 8) / 2
//        let height: CGFloat = 250
//        return CGSize(width: width, height: height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section = \(indexPath.section) ---- row = \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionViewCell", for: indexPath) as! TimelineCollectionViewCell
        
        let dog = Dog(dogRace: allDogs[indexPath.row].breed, dogs: allDogs[indexPath.row].subBreed)
        cell.dog = dog
        
        if let cachedImage = imageCache.object(forKey: allDogs[indexPath.row].breed as NSString) {
            cell.setDogImage(dogImage: cachedImage)
        }
        else {
            apiClient.getImageByBreed(breedName: allDogs[indexPath.row].breed) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    let imageUrl = image.imageURL
                    do {
                        let data = try Data(contentsOf: URL(string: imageUrl)!)
                        DispatchQueue.main.async {
                            let img = UIImage(data: data)
                            cell.setDogImage(dogImage: img!)
                            self.imageCache.setObject(img!, forKey: self.allDogs[indexPath.row].breed as NSString)
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
        }
        
        return cell
    }
}



extension TimelineViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return allDogs[indexPath.item].dogImage!.size.height
    }
}
