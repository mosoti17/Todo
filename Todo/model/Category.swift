//
//  Category.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/20/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
   @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
