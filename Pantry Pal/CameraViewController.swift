//
//  CameraViewController.swift
//  Pantry Pal
//
//  Created by Josh Burgin on 10/11/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        self.captureDevice = AVCaptureDevice.defaultDeviceWithDeviceType(AVCaptureDeviceTypeBuiltInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.Back)

        if (captureDevice != nil) {
            beginSession()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch _ {
            print("Error")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
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
