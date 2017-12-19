//
//  HostModel.swift
//  main client
//
//  Created by Admin on 02.11.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class HostModel: Object {
    var uid: String = "000000000000000000000001"
    var title: String = ""
    @objc dynamic var descr: String? = nil
    @objc dynamic var address: String? = nil
    var latitude = RealmOptional<Float64>()
    var longitude = RealmOptional<Float64>()
    @objc dynamic var offer: String? = nil
    @objc dynamic var timeOpen: Date? = nil
    @objc dynamic var timeClose: Date? = nil
    @objc dynamic var profileImage: String? = nil
    @objc dynamic var points: Float = 0
    @objc dynamic var loyalityType: Int = 1
    @objc dynamic var loyalityParam: Int = 10
    
    init? (uid: String?, title: String?, description: String?, address: String?,
           latitude: Float64?, longitude: Float64?, offer: String?,
           timeOpen: Date?, timeClose: Date?, profileImage: NSURL?,
           points: Float?, loyalityType: Int?, loyalityParam: Int?) {
        guard isObjectId(s: uid), title != nil, points != nil, loyalityType != nil, loyalityParam != nil else {
            return nil
        }
        super.init()
        self.uid = uid!
        self.title = title!
        self.descr = description
        self.address = address
        self.latitude = RealmOptional<Float64>(latitude)
        self.longitude = RealmOptional<Float64>(longitude)
        self.offer = offer
        self.timeOpen = timeOpen
        self.timeClose = timeClose
        self.profileImage = profileImage?.absoluteString
        self.points = points!
        self.loyalityType = loyalityType!
        self.loyalityParam = loyalityParam!
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    func saveLocally() {
        let realm = try! Realm()
        let host = realm.objects(HostModel.self).filter("uid == \(self.uid)").first
        try! realm.write {
            if host == nil {
                realm.add(self)
                return
            }
            host!.title = self.title
            host!.descr = self.descr
            host!.address = self.address
            host!.latitude = self.latitude
            host!.longitude = self.longitude
            host!.offer = self.offer
            host!.timeOpen = self.timeOpen
            host!.timeClose = self.timeClose
            host!.profileImage = self.profileImage
            host!.points = self.points
            host!.loyalityType = self.loyalityType
            host!.loyalityParam = self.loyalityParam
        }
    }
    
    static func load(uid: String) -> HostModel? {
        guard isObjectId(s: uid) else {
            return nil
        }
        let realm = try! Realm()
        let host = realm.objects(self).filter("uid == \(uid)").first
        return host
    }

}
