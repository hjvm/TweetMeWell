//
//  WriteTweetViewController.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/29/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit


class WriteTweetViewController: UIViewController {
    
    let user = User._currentUser
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var tweetTextField: UITextField!
    
    
    @IBAction func cancelTweet(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.nameLabel.text = user!.name as! String
        self.screenNameLabel.text = "@\((user!.screenName)!)"
        
        //profile picture
        let imageURL = user!.profileUrl! as NSURL
        self.profilePictureView.setImageWithURL(imageURL)

    }
    
    @IBAction func submitTweet(sender: AnyObject) {
        let text = tweetTextField.text ?? ""
        
        if text.characters.count > 140 {
            //Display pop-up
            let alertController = UIAlertController(title: "Exceeded character limit", message:
                "It's a tweet, not a life statement, geez!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else if text.characters.count == 0 {
            //Display pop-up
            let alertController = UIAlertController(title: "Tweet empty", message:
                "Don't waste people's time like that.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            TwitterClient.sharedInstance.tweet(text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}
