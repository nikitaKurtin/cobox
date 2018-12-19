//
//  FirstViewController.swift
//  CoBoxTask
//
//  Copyright © 2018 Nikita. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var feeds : [[Feed]] = [[],[]];
    private var keepLoading = false;
    private var segmentIndex = 0;
    
    //UI references
    @IBOutlet weak var tbl:UITableView!;
    @IBOutlet weak var segments: UISegmentedControl!;
    @IBOutlet weak var loading: UIActivityIndicatorView!;
    
    //Start load data when the screen is going to appear
    override func viewWillAppear(_ animated: Bool) {
        keepLoading = true;
        reloadData();
    }
    
    //Stop load data when the screen is closing
    override func viewWillDisappear(_ animated: Bool) {
        keepLoading = false;
    }
    
    //When user changes segment
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex;
        tbl.reloadData();
    }
    
    private func reloadData(){
        if keepLoading{
            loading.isHidden = false;
            //First segment contains a table that will show the information received from businessNews
            loadData(forFeedAt: 0, urls: Api.businessNewsUrl);
            
            //Second segment contains a table which is a unification of the data received from entertainment and then environment
            loadData(forFeedAt: 1, urls: Api.entertainmentUrl, Api.environmentUrl);
            
            //Delayed recursion
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: reloadData);
        }
    }
    
    //Loading data for feed at given index from urls
    private func loadData(forFeedAt i : Int, urls : String...){
        var count = urls.count;//How many urls to handle
        var feeds : [Feed] = [];//Temp feeds array
        for url in urls{//Handle all urls
            Api.load(fromURL: url, completion: {d,r,e in//Load and parse asyncronously
                AsyncTask(backgroundTask: {(url: String)->Feed? in
                    if let data = d {
                        let parser = FeedParser(data: data);
                        parser.parse();
                        let feed = parser.getFeed();
                        count -= 1;
                        return feed;//On success - return Feed
                    }
                    return nil;//On any failure - return nil
                }, afterTask: {result in
                    if let feed = result{//If successfully loaded
                        feeds.append(feed);//Store locally
                        if count == 0{//All urls successfully handled
                            self.updateData(forFeedAt: i, withFeeds: feeds);
                        }
                    }
                }).execute(url);
            });
        }
    }
    
    //Update ViewController
    private func updateData(forFeedAt i : Int, withFeeds feeds : [Feed]){
        self.feeds[i] = feeds;
        self.tbl.reloadData();
        self.loading.isHidden = true;
    }
    
    //Number of sections according to current selected segment
    func numberOfSections(in tableView: UITableView) -> Int {
        return feeds[segmentIndex].count;
    }
    
    //Number of rows according to items in selected segment for current section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds[segmentIndex][section].items.count;
    }
    
    //Feed title as a header title of each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return feeds[segmentIndex][section].title;
    }
    
    //Show each item title in separate row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem")!;
        cell.textLabel?.text = feeds[segmentIndex][indexPath.section].items[indexPath.row].title;
        return cell;
    }
    
    //When user selects an item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feeds[segmentIndex][indexPath.section].items[indexPath.row];
        let alert = UIAlertController(title: item.title, message: item.desc, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
        present(alert, animated: true, completion: nil);
        FirstViewController.changeFeedTitle(title: item.title);
    }
    
}
