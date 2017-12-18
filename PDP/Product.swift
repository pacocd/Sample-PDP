//
//  Product.swift
//  PDP
//
//  Created by Paco Chacon de Dios on 18/12/17.
//  Copyright © 2017 Paco Chacon de Dios. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Product: Object {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var totalQuantity: Int = 0
    @objc dynamic var soldQuantity: Int = 0
    @objc dynamic var price: Int = 0
    @objc dynamic var image: Data = Data()

    init(name: String, totalQuantity: Int, price: Int, image: Data) {
        super.init()
        self.name = name
        self.totalQuantity = totalQuantity
        self.price = price
        self.image = image
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    override static func primaryKey() -> String? {
        return "id"
        
    }
    
}
