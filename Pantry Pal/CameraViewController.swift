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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraViewController: IPDFCameraViewController!
    
    @IBOutlet weak var focusIndicator: UIImageView!
    
    @IBOutlet weak var flashToggleButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    
    private var isFlashEnabled = false
    
    @IBAction func captureButtonPressed(sender: AnyObject) {
        cameraViewController.captureImageWithCompletionHander { (imageFilePath) in
            self.disableCaptureButton()
            let activityView = ProgressHUD(text: "Processing")
            activityView.show()
            activityView.center = self.view.center
            self.view.addSubview(activityView)
            
            //TODO: use delegation to set scrollviewcontroller offset to self.view.frame.size.width
        
            Retriever.getReceipt(imageFilePath) { receipts in
                // receipts is an array of scanned receipts
                print(receipts)
                self.displayConfirmationPopup(receipts, activityView: activityView)
            }
        }
    }
    private func displayConfirmationPopup(receipts: [Receipt], activityView: ProgressHUD) {
        let alertMessage = "We recognized \(receipts[0].items.count) items on the receipt. Is this correct?"
        let alert = UIAlertController(title: "Confirm", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor(red: 48/255, green: 205/255, blue: 154/255, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            print("Confirm button pressed")
            NSNotificationCenter.defaultCenter().postNotificationName("newReceiptData", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("scrollToPantry", object: nil)
            self.enableCaptureButton()
            activityView.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Retake", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Retake button pressed")
            if receipts[0].items.count != 0 {
                Retriever.removeLastReceipt()
            }
            self.enableCaptureButton()
            activityView.removeFromSuperview()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func flashTogglePressed(sender: AnyObject) {
        //247, 194, 40
        cameraViewController.enableTorch = !isFlashEnabled
        isFlashEnabled = !isFlashEnabled
        if isFlashEnabled {
            flashToggleButton.selected = true
            flashToggleButton.setTitle("Flash On", forState: UIControlState.Selected)
            flashToggleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            flashToggleButton.backgroundColor = UIColor(red: 48/255, green: 205/255, blue: 154/255, alpha: 1.0)
        } else {
            flashToggleButton.selected = false
            flashToggleButton.setTitle("Flash Off", forState: UIControlState.Normal)
            flashToggleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            flashToggleButton.backgroundColor = UIColor.clearColor()
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
    
    private func disableCaptureButton() {
        captureButton.userInteractionEnabled = false
        let origImage = UIImage(named: "capture_button");
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        captureButton.setImage(tintedImage, forState: .Normal)
        captureButton.tintColor = UIColor.grayColor()
    }
    
    private func enableCaptureButton() {
        captureButton.userInteractionEnabled = true
        captureButton.setImage(UIImage(named: "capture_button"), forState: .Normal)
        captureButton.tintColor = UIColor.clearColor()
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
