//
//  UserModel.swift
//  main client
//
//  Created by ivan on 28.10.17.
//  Copyright © 2017 Ivan Romanov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UserModel: Object {
    var uid: String = "000000000000000000000001"
    var login: String = ""
    
    init? (uid: String?, login: String?) {
        guard isObjectId(s: uid), login != nil else {
            return nil
        }
        super.init()
        self.uid = uid!
        self.login = login!
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
            let user = realm.objects(UserModel.self).first
            if user == nil {
                realm.add(self)
                return
            }
            user!.uid = self.uid
            user!.login = self.login
        }
    }
    
    static func load() -> UserModel? {
        let realm = try! Realm()
        let user = realm.objects(self).first
        return user
    }
    
}
