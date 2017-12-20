//
//  QRViewController.swift
//  BonusFeed
//
//  Created by Daria Firsova on 18.12.2017.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var idLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = UserModel.load()?.uid
        guard uid != nil else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
            appDelegate.window?.rootViewController = mainViewController
            return
        }
        idLabel.text = uid
        img = generateQRCode(from: uid!)
    }
    
    func generateQRCode(from s: String) -> UIImageView? {
        let data = s.data(using: String.Encoding.ascii)
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

