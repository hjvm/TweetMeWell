//
//  DetailsViewController.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/28/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var tweet: Tweet!
    var indexPath: Int!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Basic profile
        self.tweetTextLabel.text = tweet.text as! String
        self.screenNameLabel.text = "@\((tweet.user!.screenName)!)"
        self.nameLabel.text = tweet.user!.name! as String
        
        //Set image
        let imageURL = tweet.user!.profileUrl! as NSURL
        self.profilePicture.setImageWithURL(imageURL)
        
        //Timestamp
        let date = (tweet.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        self.timestampLabel.text = relativeTimestamp
        
        if (tweet.retweeted){
            retweetButton.imageView!.image = UIImage(imageLiteral: "retweet-action-on-pressed")
        };if (tweet.favorited){
            likeButton.imageView!.image = UIImage(imageLiteral: "like-action-on-pressed")
        }


        //Retweets and favorites
        refreshDisplay(tweet)

        
        
        
    }
    @IBAction func retweetPost(sender: AnyObject) {
        
        if tweet.retweeted{
            TwitterClient.sharedInstance.unretweet(tweet)
            retweetButton.setImage(UIImage(named:"retweet-action"), forState: UIControlState.Normal)
            
            //retweetButton.imageView!.image = UIImage(imageLiteral: "retweet-action")
        }else{
            TwitterClient.sharedInstance.retweet(tweet)
            retweetButton.setImage(UIImage(named:"retweet-action-on-pressed"), forState: UIControlState.Normal)

            //retweetButton.imageView!.image = UIImage(imageLiteral: "retweet-action-on-pressed")
        }
        refreshDisplay(tweet)

    }
    
    @IBAction func likePost(sender: AnyObject) {
        if tweet.favorited{
            TwitterClient.sharedInstance.unlike(tweet)
            likeButton.setImage(UIImage(named:"like-action"), forState: UIControlState.Normal)

            //likeButton.imageView!.image = UIImage(imageLiteral: "like-action")
        }else{
            TwitterClient.sharedInstance.like(tweet)
            likeButton.setImage(UIImage(named:"like-action-on-pressed"), forState: UIControlState.Normal)
            
            //likeButton.imageView!.image = UIImage(imageLiteral: "like-action-on-pressed")
        }
        refreshDisplay(tweet)

    }
    
    func refreshDisplay(tweet: Tweet){
        
        TwitterClient.sharedInstance.homeTimeline({(tweets: [Tweet]) -> () in
            self.tweet = tweets[self.indexPath]
            print("Tweet reloaded")
            },failure:  { (error: NSError) -> () in
                print(error.localizedDescription)

        })
        
        //Retweets & Favorites
        if ((tweet.retweeted)){
            //retweetButton.imageView!.image = UIImage(imageLiteral: "retweet-action-on-pressed")
        };if ((tweet.favorited)){
            likeButton.imageView!.image = UIImage(imageLiteral: "like-action-on-pressed")
        }
        
        self.numRetweetsLabel.text = "\(tweet.retweetCount) RETWEETS"
        self.numFavoritesLabel.text = "\(tweet.favoritesCount) FAVORITES"
        
    }

}
