//
//  NewCameraViewController.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/5/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraViewController: IPDFCameraViewController!
    
    @IBOutlet weak var focusIndicator: UIImageView!
    
    @IBOutlet weak var flashToggleButton: UIButton!
    
    
    private var isFlashEnabled = false
    
    @IBAction func captureButtonPressed(sender: AnyObject) {
        cameraViewController.captureImageWithCompletionHander { (imageFilePath) in
            let captureImageView = UIImageView(image: UIImage(contentsOfFile: imageFilePath))
            captureImageView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
            captureImageView.frame = CGRectOffset(self.view.bounds, 0, -self.view.bounds.size.height)
            captureImageView.alpha = 1.0;
            captureImageView.contentMode = UIViewContentMode.ScaleAspectFit
            captureImageView.userInteractionEnabled = true
            //self.view.addSubview(captureImageView)
            
            //TODO: add popup with loading spinner while getting receipts
            //TODO: Confirm or deny popup based on # of receipts
            //TODO: use delegation to set scrollviewcontroller offset to self.view.frame.size.width
            
            Retriever.getPantry(imageFilePath) { receipts in
                // receipts is an array of scanned receipts
                //TODO: Add received receipts to wherever we are storing them locally
            }
            
            captureImageView.frame = self.view.bounds
        }
    }
    
    @IBAction func flashTogglePressed(sender: AnyObject) {
        //247, 194, 40
        cameraViewController.enableTorch = !isFlashEnabled
        isFlashEnabled = !isFlashEnabled
        if isFlashEnabled {
            flashToggleButton.selected = true
            flashToggleButton.setTitle("Flash On", forState: UIControlState.Selected)
            flashToggleButton.setTitleColor(UIColor(red: 247/255, green: 194/255, blue: 40/255, alpha: 1.0), forState: UIControlState.Selected)
        } else {
            flashToggleButton.selected = false
            flashToggleButton.setTitle("Flash Off", forState: UIControlState.Normal)
            flashToggleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func focusGesture(sender: AnyObject) {
        if sender.state == UIGestureRecognizerState.Recognized {
            let location = sender.locationInView(self.cameraViewController)
            focusIndicatorAnimateToPoint(location);
            cameraViewController.focusAtPoint(location, completionHandler: {
                self.focusIndicatorAnimateToPoint(location)
            })
            
            
        }
    }
    
    func focusIndicatorAnimateToPoint(location: CGPoint) {
        focusIndicator.center = location
        focusIndicator.alpha = 0.0
        focusIndicator.hidden = false
        
        UIView.animateWithDuration(0.4) {
            self.focusIndicator.alpha = 1.0
        }
        UIView.animateWithDuration(0.4) {
            self.focusIndicator.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewController.setupCameraView()
        cameraViewController.enableBorderDetection = true
        cameraViewController.cameraViewType = IPDFCameraViewType.Normal
        updateTitleLabel()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraViewController.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTitleLabel() {
        titleLabel.text = "Place Receipt Below"
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
