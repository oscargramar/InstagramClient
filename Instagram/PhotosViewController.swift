//
//  ViewController.swift
//  Instagram
//
//  Created by Oscar G.M on 1/26/16.
//  Copyright © 2016 GMStudios. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var media: [NSDictionary]?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.media = responseDictionary["data"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mediaCell") as! MediaTableViewCell
        let  post = media![indexPath.section]
        let image = (post["images"]!["low_resolution"]!!["url"]) as! String
        let image_url = NSURL(string: image)
        cell.mediaView.setImageWithURL(image_url!)
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  post = media![section]
        
        let image = post["user"]!["profile_picture"] as! String
        let image_url = NSURL(string: image)
        let username = post["user"]!["username"] as! String
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        
        profileView.setImageWithURL(image_url!)
        headerView.addSubview(profileView)
        
        let label = UILabel(frame: CGRectMake(70, 10, 200, 21))
        label.text = username
        let textColor = UIColor(red:55/255, green:84/255, blue:107/255, alpha:1)
        label.textColor = textColor
        headerView.addSubview(label)
        
        
        
        return headerView
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let media = media{
            return media.count
        }
        else{
            return 0
        }
    }


}

