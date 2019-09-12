//
//  DogTableViewController.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import Network
import CoreData

class DogTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let apiClient = DogAPIClient.sharedInstance
    let checker: NetworkCheckerProtocol = PathMonitorNetworkCheck()
    
    var viewModel: DogTableViewModel!
    var offlineDogs: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        checkForInternetConnection()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 86

        if checker.internetConnection == false {
            offlineDogs = CoreDataOperations.fetchDogData()
            let allDogs = CoreDataOperations.convertToDogs(fromArray: offlineDogs)
            viewModel = DogTableViewModel(withDogs: allDogs)
            setRowAndSectionUpdater(forViewModel: viewModel)
            
            tableView.reloadData()
        }
        else {
            apiClient.getAllDogs_v2 { allDogs in
                self.viewModel = DogTableViewModel(withDogs: allDogs)
                self.setRowAndSectionUpdater(forViewModel: self.viewModel)
                self.tableView.reloadData()
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
        return viewModel?.getNumberOfDogs() ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let breedName = viewModel.getBreedName(atIndex: section)
        let subBreedCount = viewModel.getSubBreedCountFromDog(atIndex: section)
        
        let headerView = DogTableViewHeader.getHeaderInTableView(tableView: tableView, subBreedCount: subBreedCount, breedName: breedName)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let subBreedCount = viewModel.getSubBreedCountFromDog(atIndex: section)
        return subBreedCount > 0 ? tableView.rowHeight / 2 : tableView.rowHeight / 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getBreedName(atIndex: section)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subBreedCount = viewModel.getSubBreedCountFromDog(atIndex: section)
        return subBreedCount > 0 ? subBreedCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogCell
    
        cell.viewmodel = viewModel.getDogCellViewModel(breedIndex: indexPath.section, subBreedIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dogObject = viewModel.getDogObject(atIndex: indexPath.section)
        performSegue(withIdentifier: "makingTransition", sender: dogObject)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoTableVC = segue.destination as! InfoTableViewController
        infoTableVC.dogReceived = sender as? Dog
    }

}

extension DogTableViewController {
    func setRowAndSectionUpdater(forViewModel viewmodel: DogTableViewModel) {
        viewmodel.updateSection = { indexSection in
            let indexSet = IndexSet(arrayLiteral: indexSection)
            self.tableView.reloadSections(indexSet, with: .none)
        }
        viewmodel.updateRow = { section, row in
            let indexPath = IndexPath(row: row, section: section)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func checkForInternetConnection() {
        checker.internetConnectionHandler = { hasInternet in
            if hasInternet == false {
                DispatchQueue.main.async {
                    self.offlineDogs = CoreDataOperations.fetchDogData()
                    let allDogs = CoreDataOperations.convertToDogs(fromArray: self.offlineDogs)
                    self.viewModel = DogTableViewModel(withDogs: allDogs)
                    self.setRowAndSectionUpdater(forViewModel: self.viewModel)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}
