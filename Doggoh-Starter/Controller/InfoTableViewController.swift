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
    
    let apiClient = DogAPIClient.sharedInstance
    var activityIndicator = UIActivityIndicatorView()
    
    var dogReceived: Dog?
    var dogTitle: String = ""
    
    var infoDogList: [InfoTableView.Info] = [
        InfoTableView.Info(title: "Temperament", description: "ANGRY"),
        InfoTableView.Info(title: "HEIGHT & WEIGHT", description: "1.75 - 77KG\n 1.70 - 70KG"),
        InfoTableView.Info(title: "ABOUT", description: "BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA BLA")
    ]
    
//    var testImage: [UIImage] = [
//        UIImage(named: "4")!, UIImage(named: "11")!, UIImage(named: "17")!, UIImage(named: "19")!,
//        UIImage(named: "12")!, UIImage(named: "21")!, UIImage(named: "1")!, UIImage(named: "22")!
//    ]
    
    var testImage: [UIImage] = []
    
    var tableHeaderView: UIView!
    var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogTitle = dogReceived?.breed.uppercased() ?? "Nil value"
//        tableHeaderView = createViewForHeader()
        configActivityIndicator()
        
        // LOADING UNTIL DATA IS RETRIVED
        let whiteView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        view.insertSubview(whiteView, belowSubview: activityIndicator)
        showActivityIndicatory()
        ///
        
        apiClient.getRandomImagesByBreed(breedName: dogReceived?.breed ?? "Shiba", nrOfImages: 10) { result in
            switch result {
            case .success(let images):
                let imagesUrl = images.randomDogImages
                DispatchQueue.main.async {
                    for url in imagesUrl {
                        do {
                            let data = try Data(contentsOf: URL(string: url)!)
                            self.testImage.append(UIImage(data: data)!)
                        }
                        catch let error {
                            print(error)
                        }
                    }
                    self.tableHeaderView = self.createViewForHeader()
                    self.infoListView.displayInfoList(infoArray: self.infoDogList, withHeader: self.tableHeaderView)
                    whiteView.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = dogTitle
        //        titleLabel.text = dogReceived?.dogRace.uppercased()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
//        infoListView.displayInfoList(infoArray: infoDogList, withHeader: tableHeaderView)
    }
    
    
    func createViewForHeader() -> UIView {
        
        let imageListView: ImageListView = ImageListView(frame:  CGRect(x: 0, y: 0, width: infoListView.frame.width, height: 400))
        
        imageListView.delegate = self
        imageListView.setupWith(imageArray: testImage, title: dogTitle)
        return imageListView
        
        //
    }
    
    private func configActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
//        view.bringSubviewToFront(activityIndicator)
    }
    
    private func showActivityIndicatory() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicatory() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
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
