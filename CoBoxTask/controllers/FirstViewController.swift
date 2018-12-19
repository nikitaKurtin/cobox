//
//  FirstViewController.swift
//  CoBoxTask
//
//  Copyright © 2018 Nikita. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    private static var feedTitle = "Nothing selected yet";
    
    private var refreshTime = false;
    
    @IBOutlet weak var time: UILabel!;
    @IBOutlet weak var selectedFeed: UILabel!;
    
    override func viewWillAppear(_ animated: Bool) {
        selectedFeed.text = FirstViewController.feedTitle;
        refreshTime = true;
        reloadTime();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        refreshTime = false;
    }
    
    static func changeFeedTitle(title : String){
        feedTitle = title;
    }
    
    private func reloadTime(){
        if refreshTime {
            let format = DateFormatter();
            format.timeZone = TimeZone(abbreviation: "GMT+2");
            format.locale = NSLocale.current;
            format.dateFormat = "dd/MM/yy HH:mm:ss";
            time.text = format.string(from: Date(timeIntervalSince1970: NSDate().timeIntervalSince1970));
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: reloadTime);
        }
    }
    
}
