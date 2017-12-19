//
//  common.swift
//  main client
//
//  Created by Admin on 31.10.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

let OBJECT_ID_LENGTH = 24

func isObjectId(s: String?) -> Bool {
    guard s != nil, s!.count == OBJECT_ID_LENGTH else {
        return false
    }
    for letter in s! {
        if !(letter >= "a" && letter <= "f" || letter >= "0" && letter <= "9") {
            return false
        }
    }
    return true
}

func cleanRealm() {
    let realm = try! Realm()
    realm.deleteAll()
}
