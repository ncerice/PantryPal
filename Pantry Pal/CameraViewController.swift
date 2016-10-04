import UIKit
import SwiftOCR

class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftOCRTest()
    }
    
    func swiftOCRTest() {
        let sampleImage = OCRImage(named: "SampleReceipt")
        let swiftOCRInstance = SwiftOCR()
        swiftOCRInstance.recognize(sampleImage!) {recognizedString in
            print(recognizedString)
            print(swiftOCRInstance.currentOCRRecognizedBlobs)
        }        
    }
}
