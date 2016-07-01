//
//  LoginViewController.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/27/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBAction func onLoginButton(sender: AnyObject){
        
        let client = TwitterClient.sharedInstance
        
        client.login({ () -> () in
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
        
        
    }
    
}
