//
//  Category.swift
//  Todo
//
//  Created by Jackson Pitcher on 7/15/19.
//  Copyright © 2019 Jackson Pitcher. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
