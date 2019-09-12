//
//  TimelineViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import Network
import CoreData


protocol NetworkCheckerProtocol: class {
    var internetConnection: Bool { get }
    var internetConnectionHandler: ((Bool) -> Void)? { get set }
    
}


class PathMonitorNetworkCheck: NetworkCheckerProtocol {
    
    var internetConnection: Bool = false
    var internetConnectionHandler: ((Bool) -> Void)?
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.internetConnection = true
                print("internetConnection = \(self?.internetConnection)")
//                self?.internetConnectionHandler?(true)
            }
            else {
                self?.internetConnection = false
                print("internetConnection = \(self?.internetConnection)")
                self?.internetConnectionHandler?(false)
            }
            
            
        }
        monitor.start(queue: queue)
    }
    
}


class TimelineViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    let checker: NetworkCheckerProtocol = PathMonitorNetworkCheck()
    
    
    private let apiClient = DogAPIClient.sharedInstance
    
    private let edgeInset: CGFloat = 16
    private var layout: PinterestLayout?
    
    private var viewModel: TimelineViewModel!
    private var allDogs = [Dog]()
    private var offlineAllDogs: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkForInternetConnection()
        addGradientView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TimelineCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TimelineCollectionViewCell")
        
        layout = collectionView.collectionViewLayout as? PinterestLayout
        layout?.delegate = self
        
        if checker.internetConnection == false {
            self.offlineAllDogs = CoreDataOperations.fetchDogData()
            self.allDogs = CoreDataOperations.convertToDogs(fromArray: self.offlineAllDogs)
            self.viewModel = TimelineViewModel(withDogs: self.allDogs)
        }
        else {
            apiClient.getAllDogs_v2 { allDogs in
                self.viewModel = TimelineViewModel(withDogs: allDogs)
                self.viewModel.reloadRow = { indexRow in
                    let indexPath = IndexPath(row: indexRow, section: 0)
                    self.collectionView.reloadItems(at: [indexPath])
                }
                self.collectionView.reloadData()
            }
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getDogsCount() ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionViewCell", for: indexPath) as! TimelineCollectionViewCell
        
        cell.viewModel = viewModel?.getDogViewModel(withIndex: indexPath.row)
        
        return cell
    }
}


extension TimelineViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let rnd = Int.random(in: 260...360)
        return CGFloat(rnd)
        
    }
}

extension TimelineViewController {
    
    func checkForInternetConnection() {
        checker.internetConnectionHandler = { hasInternet in
            if hasInternet == false {
                DispatchQueue.main.async {
                    self.offlineAllDogs = CoreDataOperations.fetchDogData()
                    self.allDogs = CoreDataOperations.convertToDogs(fromArray: self.offlineAllDogs)
                    self.viewModel = TimelineViewModel(withDogs: self.allDogs)
                    // cache must be cleared. idk why. fk custom layout
                    self.layout?.cache.removeAll()
                    self.layout?.contentHeight = 0
                    self.collectionView.reloadData()
                
                }
            }
            else {
                //TODO: Something when the internet connection comes back
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
