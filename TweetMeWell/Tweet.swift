//
//  Tweet.swift
//  
//
//  Created by Héctor J. Vázquez on 6/27/16.
//
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var retweeted: Bool = false
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var tweetID: Int = 0
    var userDictionary: NSDictionary?
    var user: User?

    
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
            favorited = (dictionary["favorited"] as? Bool) ?? false
        tweetID = (dictionary["id"] as? Int) ?? 0
        
        
        //Obtain date
        let timestampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            self.timestamp = formatter.dateFromString(timestampString)
        }
        
        //Obtain author
        self.userDictionary = dictionary["user"] as? NSDictionary
        self.user = User(dictionary: userDictionary!)
    }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
