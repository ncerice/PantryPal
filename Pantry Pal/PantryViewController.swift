//
//  PantryViewController.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/15/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PantryViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var currentReceipts = [Receipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        setupNotifications()
        getReceipts()
        // Do any additional setup after loading the view.
        //TODO: make Retriever function to get receipts based on token, without passing image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveReceiptData(_:)), name: "newReceiptData", object: nil)
    }
    
    func receiveReceiptData(notification: NSNotification) {
        getReceipts()
    }
    
    func getReceipts() {
        Retriever.getPantry { (receipts) in
            self.currentReceipts = receipts
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentReceipts[section].items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.currentReceipts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Item")! as! PantryTableViewCell
        let item = currentReceipts[indexPath.section].items[indexPath.row]
        cell.itemNameLabel.text = item.name
        cell.itemPriceLabel.text = item.price
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerString = currentReceipts[section].store
        let headerDate = currentReceipts[section].date
        return headerString! + "                                                " + headerDate!
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome"
        return NSAttributedString(string: str)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Swipe to the left to scan your first receipt!"
        return NSAttributedString(string: str)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let img = UIImage(CIImage: CIImage(image: UIImage(named: "ShoppingCartIconEmptyData")!)!, scale: 5.0, orientation: UIImageOrientation.Down)
        return img
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
}
