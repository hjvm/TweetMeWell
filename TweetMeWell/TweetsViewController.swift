//
//  TweetsViewController.swift
//  TweetMeWell
//
//  Created by Héctor J. Vázquez on 6/27/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet] = []
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Reusable cells
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! tweetCell
        
        cell.tweet = tweets[indexPath.section]
        cell.indexPath = indexPath.section
        
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UITableViewHeaderFooterView()
        vw.contentView.backgroundColor = UIColor.cyanColor()
        let tweet = self.tweets[section]
        vw.textLabel?.text = (tweet.user!.name as? String) ?? ""
        vw.textLabel?.textColor = UIColor.blackColor()
        return vw
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tweets.count
    }
    
    
    @IBAction func profileImagePressed(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tableView.indexPathForCell(cell)

        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeUserProfile") as! ProfileViewController
        vc.homeUser = tweets[indexPath!.section].user
        self.presentViewController(vc, animated:true, completion: nil)
        
    
    }
    
    
    
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadTweets()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //Auto-resizing cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        loadTweets()
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    

    

    
    func loadTweets(){
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            print("Tweets loaded successfully")
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        

    }
    
    
    @IBAction func createNewTweet(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CreateNewTweet") as! WriteTweetViewController
        self.presentViewController(vc, animated:true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Prepare for segue called")
        let cell = sender as! tweetCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets[indexPath!.section]
        print("PREPARE FOR SEGUE")
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        detailsViewController.tweet = tweet
        detailsViewController.indexPath = indexPath!.section

    
    }
}
