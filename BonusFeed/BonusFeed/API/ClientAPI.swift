//
//  ClientAPI.swift
//  main client
//
//  Created by Admin on 02.11.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Realm
import RealmSwift

class ClientAPI {
    private let CLIENT_URL = API.BASE_URL + "client/"
    
    var url: String {
        return CLIENT_URL
    }
    
    private func _parseHost(data: NSDictionary?) -> HostModel? {
        guard data != nil else {
            return nil
        }
        let hostUid = data?.object(forKey: "host_id") as? String
        let title = data?.object(forKey: "title") as? String
        let description = data?.object(forKey: "description") as? String
        let offer = data?.object(forKey: "offer") as? String
        let address = data?.object(forKey: "address") as? String
        let latitude = data?.object(forKey: "latitude") as? Float64
        let longitude = data?.object(forKey: "longitude") as? Float64
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mm"
        var timeOpen: Date?
        var timeClose: Date?
        if let time = data?.object(forKey: "time_open") as? String {
            timeOpen = dateFormatter.date(from: time)
        }
        if let time = data?.object(forKey: "time_close") as? String {
            timeClose = dateFormatter.date(from: time)
        }
        
        var profileImage: NSURL?
        if let url = data?.object(forKey: "profile_image") as? String {
            profileImage = NSURL(string: url)
        }
        let loyalityType = data?.object(forKey: "loyality_type") as? Int
        let loyalityParam = data?.object(forKey: "loyality_param") as? Int
        let points = data?.object(forKey: "points") as? Float
        
        return HostModel(uid: hostUid, title: title, description: description, address: address,
                  latitude: latitude, longitude: longitude, offer: offer, timeOpen: timeOpen,
                  timeClose: timeClose, profileImage: profileImage, points: points,
                  loyalityType: loyalityType, loyalityParam: loyalityParam)
    }
    
    func getHost(hostUid: String, onResult: @escaping(Int?, HostModel?) -> Void) {
        /*
         * Returns:
         *     (nil, nil) if request failed
         *     (200, HostModel) if ok
         *     (200, nil) if host cannot be parsed
         *     (404, nil) if no such host in db
         *     (401, nil) if user not authed
         */
        
        let params: Parameters = [
            "host_id": hostUid
        ]
        Alamofire.request(CLIENT_URL + "get_host/", method: .get, parameters: params).responseJSON { response in
            guard response.result.error == nil else {
                onResult(nil, nil)
                return
            }
            
            let code = response.response?.statusCode
            guard code == API.OK else {
                onResult(response.response!.statusCode, nil)
                return
            }
            let data = response.result.value as? NSDictionary
            
            let host = self._parseHost(data: data)
            host?.saveLocally()
            onResult(code, host)
        }
    }
    
    func listHosts(onResult: @escaping(Int?, List<HostModel>?) -> Void) {
        /*
         * Returns:
         *     (nil, nil) if request failed
         *     (200, List<HostModel>) if ok - List can be empty
         *     (200, nil) if response cannot be parsed
         *     (401, nil) if user not authed
         */
        Alamofire.request(CLIENT_URL + "list_hosts/", method: .get).responseJSON { response in
            guard response.result.error == nil else {
                onResult(nil, nil)
                return
            }
            
            let code = response.response?.statusCode
            guard code == API.OK else {
                onResult(code, nil)
                return
            }
            
            let list = response.result.value as? NSArray
            guard list != nil else {
                onResult(code, nil)
                return
            }
            
            let hosts = List<HostModel>()
            for el in list! {
                let data = el as? NSDictionary
                if let host = self._parseHost(data: data) {
                    hosts.append(host)
                }
            }
            let ham = HostArrayModel(arr: hosts)
            ham.saveLocally()
            onResult(code, hosts)
        }
    }
    
    func getClientInfo(onResult: @escaping(Int?, UserModel?) -> Void) {
        /*
         * Returns:
         *     (nil, nil) if request failed
         *     (200, UserModel) if ok
         *     (200, nil) if response cannot be parsed
         *     (401, nil) if user not authed
         */
        Alamofire.request(CLIENT_URL + "get_info/", method: .get).responseJSON { response in
            guard response.result.error == nil else {
                onResult(nil, nil)
                return
            }
            
            let code = response.response?.statusCode
            guard code == API.OK else {
                onResult(response.response!.statusCode, nil)
                return
            }
            
            let data = response.result.value as? NSDictionary
            let user_uid = data?.object(forKey: "identificator") as? String
            let login = data?.object(forKey: "name") as? String
            let user = UserModel(uid: user_uid, login: login)
            user?.saveLocally()
            onResult(code, user)
        }
    }

    func getHostLogo(hostUid: String, onResult: @escaping(Int?, Image?) -> Void) {
        /*
         * Returns:
         *     (nil, nil) if request failed
         *     (200, Image) if ok - List can be empty
         *     (200, nil) if response cannot be parsed
         *     (404, nil) if no such image
         */
        let url = URLRequest(url: URL(string: CLIENT_URL + "media/" + hostUid)!)
        Alamofire.request(url).responseImage { response in
            guard response.result.error == nil else {
                onResult(nil, nil)
                return
            }
            
            let code = response.response?.statusCode
            guard code == API.OK else {
                onResult(code, nil)
                return
            }
            
            guard let image = response.result.value else {
                onResult(code, nil)
                return
            }
            
            let cache = AutoPurgingImageCache(
                memoryCapacity: 100_000_000,
                preferredMemoryUsageAfterPurge: 60_000_000
            )
            cache.add(image, for: url)
            onResult(code, image)
        }
    }
}
