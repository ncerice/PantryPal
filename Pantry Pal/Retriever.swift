//
//  Retriever.swift
//  Pantry Pal
//
//  Created by Josh Burgin on 11/19/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit
import Foundation

class Retriever: NSObject {
    
    static let url = "https://pantrypal.burgin.io/api/"
    
    class func getToken(next: (String?) -> ()) {
        let tokenUrl = NSURL(string: url + "token")
        let request = NSMutableURLRequest(URL: tokenUrl!)
        request.HTTPMethod = "GET"
        
        runRequst(request) { data in
            if let dictionary = data as? NSDictionary {
                if let token = dictionary["token"] as? String {
                    next(token)
                }
            }
        }
    }
    
    class func removeLastReceipt() {
        let prefs = NSUserDefaults.standardUserDefaults()
        if let token = prefs.stringForKey("token") {
            let pantryURL = NSURL(string: url + "shift?token=" + token)
            let request = NSMutableURLRequest(URL: pantryURL!)
            request.HTTPMethod = "GET"
            runRequst(request) { data in }
        }
    }
    
    class func getPantry(next: (Array<Receipt>) -> ()) {
        let prefs = NSUserDefaults.standardUserDefaults()
        if let token = prefs.stringForKey("token") {
            let pantryURL = NSURL(string: url + "pantry?token=" + token)
            let request = NSMutableURLRequest(URL: pantryURL!)
            request.HTTPMethod = "GET"
            runRequst(request) { data in
                next(generateReceipts(data))
            }
        }
    }
    
    class func getReceipt(filepath : String, next: (Array<Receipt>) -> ()) {
        let prefs = NSUserDefaults.standardUserDefaults()
        print(filepath)
        
        
        if let token = prefs.stringForKey("token") {
            let pantryUrl = NSURL(string: url + "receipt?token=" + token)
            let request = NSMutableURLRequest(URL: pantryUrl!)
            request.HTTPMethod = "POST"
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; charset=utf8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let image = UIImage(contentsOfFile: filepath)
            let imageData = UIImageJPEGRepresentation(image!, 0.76)
            
            let fname = NSURL(fileURLWithPath: filepath).lastPathComponent!
            let mimetype = "image/jpeg"
            
            let body = NSMutableData()
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"receipt\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData!)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            request.HTTPBody = body;
            
            
            runRequst(request) { data in
                next(generateReceipts(data))
            }
            
        } else {
            next(generateReceipts(nil))
        }
    }
    
    class func generateReceipts(data: AnyObject?) -> Array<Receipt> {
        var generatedReceipts = Array<Receipt>()
        
    
        if let receipts = data as? NSArray {
            for receipt in receipts {
                if let receipt = receipt as? NSDictionary {
                    generatedReceipts.append(Receipt(data: receipt))
                }
            }
        }
        
        return generatedReceipts;
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    class func runRequst(request: NSMutableURLRequest,next: (AnyObject?) -> ()) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if (error != nil) {
                return next(nil)
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            
            let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: [])
            next(json)
        }
        
        task.resume()
    }
}
