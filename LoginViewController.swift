//
//  LoginViewController.swift
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // twitter login
        let loginButton = TWTRLogInButton(logInCompletion: {
            session, error in
            if session != nil {
                let tlVC = TimelineViewController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = tlVC
            } else {
                /* TODO : ERROR Handling */
            }
        })
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
}