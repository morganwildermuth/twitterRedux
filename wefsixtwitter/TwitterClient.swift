//
//  TwitterClient.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

let twitterConsumerKey = "Hl2DK3CrCaMw8itBe9O38M3eL"
let twitterConsumerSecret = "ugqbiCaM4nryb6R0VxfvHRh8rOCtvSm9wPPfQmd9lXdgcImWrK"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    // property name Shared Instance, of type TwitterClient, and its implemented by returning nested static instance

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
//    func homeTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> ()
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])

            completion(tweets: tweets, error: nil)
            }, failure: {( operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting home time line")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func tweetWithParams(parameters: NSDictionary?, completion: (result: NSDictionary?, error: NSError?) -> ()){
            POST("1.1/statuses/update.json", parameters: parameters, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("tweeted success")
                    completion(result: response as? NSDictionary, error: nil)
                }, failure: {( operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("error tweeting")
                    completion(result: nil, error: error)
                })
    }
    
    func retweetWithParams(id: String?, completion: (result: NSDictionary?, error: NSError?) -> ()){
        var endPoint = "1.1/statuses/retweet/" + id! + ".json"
        POST(endPoint, parameters: nil, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("retweeted success")
            completion(result: response as? NSDictionary, error: nil)
            }, failure: {( operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error retweeting")
                print(error)
                completion(result: nil, error: error)
        })
    }
    
    func favoriteWithParams(parameters: NSDictionary?, completion: (result: NSDictionary?, error: NSError?) -> ()){
        var endPoint = "1.1/favorites/create.json"
        POST(endPoint, parameters: parameters!, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("favorite success")
            completion(result: response as? NSDictionary, error: nil)
            }, failure: {( operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error favoriting")
                completion(result: nil, error: error)
        })
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion;
        
        //reset access token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got request token")
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            // method to open any safari page, could use to open Maps, Contacts, or custom (like facebook); up to app to process route afterwards
            UIApplication.sharedApplication().openURL(authUrl!)
            }, failure: {(error: NSError!) -> Void in
                print(error)
                self.loginCompletion?(user: nil, error: error)
        })
        
    }
    
    func openURL(url: NSURL){
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)

            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //                    print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: {( operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }, failure: { (error: NSError!) -> Void in
            print("failed to recieve access token")
            self.loginCompletion?(user: nil, error: error)
        })

    }

}
