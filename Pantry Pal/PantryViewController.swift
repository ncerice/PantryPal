//
//  PantryViewController.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/15/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PantryViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentReceipts = [Receipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        searchBar.returnKeyType = UIReturnKeyType.Done
        let tap = UITapGestureRecognizer(target: self, action: #selector(PantryViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.setupNotifications()
        getReceipts()
        // Do any additional setup after loading the view.
        //TODO: make Retriever function to get receipts based on token, without passing image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getReceipts()
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
                //self.tableView.reloadData()
                UIView.transitionWithView(self.tableView, duration: 0.35, options: .TransitionCrossDissolve, animations:
                    {() -> Void in
                        self.tableView.reloadData()
                    }, completion: nil);
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("CustomHeader") as! CustomHeaderCell
        headerCell.storeDateLabel.text = currentReceipts[section].date
        headerCell.storeNameLabel.text = currentReceipts[section].store
        //headerCell.backgroundColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 0.5)
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58.0
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome"
        return NSAttributedString(string: str)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Swipe to the camera screen to scan your first receipt!"
        return NSAttributedString(string: str)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let img = UIImage(CIImage: CIImage(image: UIImage(named: "ShoppingCartIconEmptyData")!)!, scale: 5.0, orientation: UIImageOrientation.Down)
        return img
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -30.0
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
}
