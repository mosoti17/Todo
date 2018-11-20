//
//  Item.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/20/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
