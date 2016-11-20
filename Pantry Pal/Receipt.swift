//
//  Receipt.swift
//  Pantry Pal
//
//  Created by Josh Burgin on 11/19/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit

struct Item {
    var name : String? = nil
    var price : String? = nil
    
    init(data: NSDictionary) {
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let price = data["price"] as? String {
            self.price = "$\(price)"
        }
    }
}

struct Receipt {
    var store : String? = nil
    var date : String? = nil
    var items = Array<Item>()
    
    init(data: NSDictionary) {
        if let store = data["store"] as? String {
            self.store = store
        }
        
        if let date = data["date"] as? String {
            self.date = date
        }
        
        if let items = data["items"] as? NSArray {
            for item in items {
                if let item = item as? NSDictionary {
                    self.items.append(Item(data: item))
                }
            }
        }
    }
}
