//
//  TweetsViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

@objc protocol TweetsViewControllerDelegate {
    optional func tweetsViewController(tweetsViewController: TweetsViewController)
    optional func tweetsViewControllerOpenUserProfile(tweetCell: TweetTableViewCell)
    
    // too late and tired to implement, but the below is a good idea since then I can do the wee alerts like before
    //    optional func favoriteTweetTableViewCell(tweetCell: TweetTableViewCell)
    //    optional func replyTweetTableViewCell(tweetCell: TweetTableViewCell)
    
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetTableViewCellDelegate{

    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    weak var delegate: TweetsViewControllerDelegate?
    
    @IBOutlet weak var tweetTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTable.delegate = self
        tweetTable.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        loadData()
        setupRefreshController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tweetTableViewCellSegueToPost(tweetCell: TweetTableViewCell) {
        performSegueWithIdentifier("segueToPost", sender: tweetCell)
    }
    
    func tweetTableViewCellOpenUserProfile(tweetCell: TweetTableViewCell) {
        delegate?.tweetsViewControllerOpenUserProfile?(tweetCell)
    }
    
    func refresh(sender: AnyObject){
        loadData()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetTable.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.setData()
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tweetTable.cellForRowAtIndexPath(indexPath) as! TweetTableViewCell
        performSegueWithIdentifier("segueToTweet", sender: cell)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    


    private func setupRefreshController(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tweetTable.addSubview(refreshControl)
    }

    private func loadData(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets, error) -> () in
            self.tweets = tweets
            self.tweetTable.reloadData()
            self.refreshControl.endRefreshing()
//            self.tweetTable.rowHeight = UITableViewAutomaticDimension
//            self.tweetTable.estimatedRowHeight = 400
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToTweet"){
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.tweet = sender!.tweet
        }
        if (segue.identifier == "segueToPost"){
            let vc = segue.destinationViewController as! PostViewController
            if let tweet = sender?.tweet {
                vc.tweet = sender!.tweet
                vc.mode = "reply"
            } else {
                vc.mode = "new"
            }

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
