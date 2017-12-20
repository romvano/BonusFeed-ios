//
//  RegistrationViewController.swift
//  BonusFeed
//
//  Created by Admin on 20.12.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    let error = "Ошибка!"
    let wrongCreds = "User exists"
    let networkError = "Сеть недоступна"
    let unknownError = "Ой, что-то не так. Но скоро заработает!"
    let confirm = "OK"
    
    @IBOutlet weak var loginTextView: UITextField!
    @IBOutlet weak var pwdTextView: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    var login = ""
    var pwd = ""
    
    @IBAction func onTapGestureRecognized(_ sender: Any) {
        loginTextView.resignFirstResponder()
        pwdTextView.resignFirstResponder()
    }
    @IBAction func performRegistration(_ sender: UIButton!) {
        login = loginTextView.text != nil ? loginTextView.text! : ""
        pwd = pwdTextView.text != nil ? pwdTextView.text! : ""
        UserAPI().register(login: login, pwd: pwd, onResult: onRegisterResponse)
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: confirm, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onRegisterResponse(code: Int?) {
        if code == nil {
            alert(message: networkError)
            return
        }
        switch code! {
        case API.OK:
            UserAPI().login(login: login, pwd: pwd, onResult: onLoginResult)
            return
        case API.CONFLICT:
            alert(message: wrongCreds)
            return
        default:
            alert(message: unknownError)
        }
    }
    
    func onLoginResult(code: Int?, user: UserModel?) {
        if code == 200 && user != nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
            appDelegate.window?.rootViewController = mainViewController
            return
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}
