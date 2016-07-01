//
//  ProfileViewController.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/30/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    var homeUser = User._currentUser
    
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowedLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        self.nameLabel.text = homeUser?.name as! String
        self.taglineLabel.text = "@\((homeUser!.screenName)!)"
        self.numFollowingLabel.text = "\((homeUser?.numFollowers)!) \n Followers"
        self.numFollowedLabel.text = "\((homeUser?.numFollowed)!) \n Followed"
        self.numTweetsLabel.text = "\((homeUser?.numTweets)!) \n Tweets"
        
        
        //profile picture
        let profileImageURL = homeUser!.profileUrl! as NSURL
        self.profileImage.setImageWithURL(profileImageURL)
        
        //profile picture
        let backgroundImageURL = homeUser!.profileUrl! as NSURL
        self.profileBackgroundImage.setImageWithURL(backgroundImageURL)
        
    }
}
