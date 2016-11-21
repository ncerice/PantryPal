//
//  PantryViewController.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/15/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit

class PantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currentReceipts = [Receipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNotifications()
        // Do any additional setup after loading the view.
        //TODO: make Retriever function to get receipts based on token, without passing image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveReceiptData(_:)), name: "newReceiptData", object: nil)
    }
    
    func receiveReceiptData(notification: NSNotification) {
//        if let receiptData = notification.userInfo?["data"] as? [Receipt] {
//            currentReceipts = receiptData
//            tableView.reloadData()
//        }
        //let newReceipts = notification.objectF
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Item")! as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Store name - Date"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
}
