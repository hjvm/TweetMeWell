//
//  tweetCell.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/28/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class tweetCell: UITableViewCell {

    
    @IBOutlet var tweetText: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var relativeTimestampLabel: UILabel!
    
    
    @IBOutlet weak var replyIcon: UIButton!
    @IBOutlet weak var retweetIcon: UIButton!
    @IBOutlet weak var favoriteIcon: UIButton!
    
     var tweetTextVar: String!
    var indexPath: Int!
    
    var tweet: Tweet?{
        didSet {
            self.tweetText.text = tweet!.text as! String
            self.usernameLabel.text = "@\((tweet!.user!.screenName)!)"
            
            //Set image
            let imageURL = tweet!.user!.profileUrl! as NSURL
            self.profilePictureView.setImageWithURL(imageURL)
                     
            //Timestamp
            let date = (tweet?.timestamp)! as NSDate
            let relativeTimestamp = date.dateTimeUntilNow()
            self.relativeTimestampLabel.text = relativeTimestamp
            
            //Buttons
            if ((tweet?.retweeted)!){
                retweetIcon.imageView!.image = UIImage(imageLiteral: "retweet-action-on-pressed")
            };if ((tweet?.favorited)!){
                favoriteIcon.imageView!.image = UIImage(imageLiteral: "like-action-on-pressed")
            }
            
        
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    

    @IBAction func retweetPost(sender: AnyObject) {
        
        if tweet!.retweeted{
            TwitterClient.sharedInstance.unretweet(tweet!)
            retweetIcon.setImage(UIImage(named:"retweet-action"), forState: UIControlState.Normal)
            tweet!.retweeted = false
        }else{
            TwitterClient.sharedInstance.retweet(tweet!)
            retweetIcon.setImage(UIImage(named:"retweet-action-on-pressed"), forState: UIControlState.Normal)
            tweet!.retweeted = true
        }
  //      refreshDisplay(tweet!)
        
    }
    
    @IBAction func likePost(sender: AnyObject) {
        if tweet!.favorited{
            TwitterClient.sharedInstance.unlike(tweet!)
                favoriteIcon.setImage(UIImage(named:"like-action"), forState: UIControlState.Normal)
            tweet!.favorited = false
        }else{
            TwitterClient.sharedInstance.like(tweet!)
            favoriteIcon.setImage(UIImage(named:"like-action-on-pressed"), forState: UIControlState.Normal)
            tweet!.favorited = true
        }
  //      refreshDisplay(tweet!)
        
    }
    
    func refreshDisplay(tweet: Tweet){
        
        TwitterClient.sharedInstance.homeTimeline({(tweets: [Tweet]) -> () in
            self.tweet = tweets[self.indexPath]
            print("Tweet reloaded")
            },failure:  { (error: NSError) -> () in
                print(error.localizedDescription)
                
                
                
        })
    }
    
    
    
}
