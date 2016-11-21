//
//  ScrollViewController.swift
//  Pantry Pal
//
//  Created by Josh Burgin on 11/19/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageOverlay: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if prefs.stringForKey("token") == nil {
            setToken();
        }
        
        initViews();
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var rect = pageOverlay.frame
        rect.origin.x = scrollView.contentOffset.x/2
        pageOverlay.frame = rect
    }
    
    func initViews() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let cameraView = storyBoard.instantiateViewControllerWithIdentifier("CameraView")
        let pantryView = storyBoard.instantiateViewControllerWithIdentifier("PantryView")
        
        self.addChildViewController(cameraView)
        self.scrollView.addSubview(cameraView.view)
        cameraView.didMoveToParentViewController(self)
        
        self.addChildViewController(pantryView)
        self.scrollView.addSubview(pantryView.view)
        pantryView.didMoveToParentViewController(self)
        
        var pantryFrame = pantryView.view.frame
        pantryFrame.origin.x = self.view.frame.size.width
        pantryView.view.frame = pantryFrame
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 20)
    }
 
    func setToken() {
        Retriever.getToken() { token in
            if let token = token {
                let prefs = NSUserDefaults.standardUserDefaults()
                prefs.setValue(token, forKey: "token")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
