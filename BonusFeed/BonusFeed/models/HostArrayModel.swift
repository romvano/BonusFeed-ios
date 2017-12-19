//
//  HostArrayModel.swift
//  main client
//
//  Created by Admin on 03.11.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class HostArrayModel: Object {
    var hostArray = List<HostModel>()
    
    init (arr: List<HostModel>) {
        super.init()
        for el in arr {
            self.hostArray.append(el)
        }
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    func saveLocally() {
        let realm = try! Realm()
        try! realm.write {
            let ham = realm.objects(HostArrayModel.self).first
            if ham == nil {
                realm.add(self)
                return
            }
            ham!.hostArray = self.hostArray
        }
    }
    
    static func load() -> List<HostModel>? {
        let realm = try! Realm()
        let hostList = realm.objects(self).first?.hostArray
        return hostList
    }
    
}
