//
//  User.swift
//  
//
//  Created by Héctor J. Vázquez on 6/27/16.
//
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var profileUrlBackgroundImage: NSURL?
    var tagline: NSString?
    var numTweets: Int?
    var numFollowers: Int?
    var numFollowed: Int?
    
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        //Num tweets and followers
        numTweets = dictionary["statuses_count"] as? Int
        numFollowers = dictionary["followers_count"] as? Int
        numFollowed = dictionary["friends_count"] as? Int

        
        //Profile images
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
        let altProfileUrlString = dictionary["profile_background_image_url_https"] as? String
        if let altProfileUrlString = altProfileUrlString{
            profileUrlBackgroundImage = NSURL(string: altProfileUrlString)
        }

    }
    
    static let userDidLogoutNotification = "UserDidLogout"

    
    static var _currentUser: User?
    class var currentUser: User?{
        get {
            if _currentUser == nil{
                
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
            
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            
            }else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
            
            
        }
    }
    
}
