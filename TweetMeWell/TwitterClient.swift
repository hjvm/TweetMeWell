//
//  TwitterClient.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/27/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "811xwOWAiLkX8du0DZ3yDdWqK", consumerSecret: "8fzRocUCg9ryRCc8PMC2dsloUWVahUzTPYdoIa6vNGaIBztjgQ")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        //Obtain home timeline
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            
                failure(error)
        })
        
    }
    


    func currentAccount(success: (User) -> (), failure: (NSError) ->()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
            
                success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
                failure(error)
        })

    }

    func login(success: () -> (), failure: (NSError)->()){
        
        loginSuccess = success
        loginFailure = failure
        
        //Logout before loging in
        deauthorize()
        
        //Login request
        fetchRequestTokenWithPath("https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweetmewell://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
//            print("Successful login")
            
            //Authorization URL
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
//            print("Got access token")
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: {(error: NSError) -> () in
                    self.loginFailure?(error)
                })
            
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        

    }
    
    func retweet(tweet: Tweet)  {
        let url = "1.1/statuses/retweet/\(tweet.tweetID).json"
        POST(url, parameters: nil, progress: nil,
             success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                print("Post has been retweeted")
                
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    func unretweet(tweet: Tweet){
        let url = "1.1/statuses/unretweet/\(tweet.tweetID).json"
        POST(url, parameters: nil, progress: nil,
             success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                print("Post has been unretweeted")
                
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
                
        })
        
    }
    
    func like(tweet: Tweet){
        let url = "1.1/favorites/create.json?id=\(tweet.tweetID)"
        POST(url, parameters: nil, progress: nil,
             success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Post has been liked")
            
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    
    func unlike(tweet: Tweet){
        let url = "1.1/favorites/destroy.json?id=\(tweet.tweetID)"

        POST(url, parameters: nil, progress: nil,
             success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Post has been unliked")
                
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    
    func tweet(text: String){
        
        let altText = NSURL(string : text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let url = "1.1/statuses/update.json?status=\((altText)!)"
       
        //https://api.twitter.com/1.1/statuses/update.json?status=Maybe%20he%27ll%20finally%20find%20his%20keys.%20%23peterfalk
        
        POST(url, parameters: nil, progress: nil,
             success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                print("Tweet has been posted")
                
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
                
        })

        
    }
    



}
