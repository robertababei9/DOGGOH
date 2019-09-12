//
//  TodayViewController.swift
//  TodayDoggie
//
//  Created by Robert Ababei on 23/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import NotificationCenter

func getSharedFilePath() -> String {
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Doggies")
    let fileURL = containerURL?.appendingPathComponent("testURL.txt")
    
    let path: String = fileURL!.absoluteString.replacingOccurrences(of: "file://", with: "", options: .caseInsensitive, range: nil)
    
    return path
}

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //citeste date din acel fisier
        let url = URL(fileURLWithPath: getSharedFilePath())
        FileObserver(url: url, handler: { (change) in
            DispatchQueue.main.async {
                self.label.text = change
            }
//            print("change = \(change)")
        }).startObserving()
    }
    
    
    func displayImageFromUrl(url: URL) {
        if let data = try? Data(contentsOf: url) {
            let image = UIImage(data: data)
            imageView.image = image
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

class FileObserver {
    let url: URL
    private var previousContents: String = ""
    private var notification: ((String) -> Void)?
    
    init(url: URL, handler: ((String) -> Void)?) {
        self.url = url
        notification = handler
    }
    
    func startObserving() {
        DispatchQueue.global().async {
            while true {
                sleep(5)
                if let data = try? Data(contentsOf: self.url),
                    let text = String(data: data, encoding: .ascii) {
                    if text != self.previousContents {
                        self.previousContents = text
                        self.notification?(text)
                    }
                }
            }
        }
    }
}
