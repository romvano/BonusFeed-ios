//
//  LoginViewController.swift
//  BonusFeed
//
//  Created by Admin on 19.12.17.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let error = "Ошибка!"
    let wrongCreds = "Неверный логин или пароль. Попробуйте еще раз"
    let networkError = "Сеть недоступна"
    let unknownError = "Ой, что-то не так. Но скоро заработает!"
    let confirm = "OK"

    @IBOutlet weak var loginTextView: UITextField!
    @IBOutlet weak var pwdTextView: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    @IBAction func performLogin(_ sender: UIButton!) {
        let login: String = loginTextView.text != nil ? loginTextView.text! : ""
        let pwd: String = pwdTextView.text != nil ? pwdTextView.text! : ""
        UserAPI().login(login: login, pwd: pwd, onResult: onLoginResponse)
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: confirm, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onLoginResponse(code: Int?, user: UserModel?) {
        if code == nil || code == API.OK && user == nil {
            alert(message: networkError)
            return
        }
        switch code! {
        case API.OK:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
            appDelegate.window?.rootViewController = mainViewController
            return
        case API.FORBIDDEN:
            alert(message: wrongCreds)
            return
        default:
            alert(message: unknownError)
        }
    }
}
