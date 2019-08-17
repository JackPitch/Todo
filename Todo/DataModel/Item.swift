//
//  Item.swift
//  Todo
//
//  Created by Jackson Pitcher on 7/15/19.
//  Copyright © 2019 Jackson Pitcher. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
