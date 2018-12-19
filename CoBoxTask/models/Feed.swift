//
//  Feed.swift
//  CoBoxTask
//
//  Copyright © 2018 Nikita. All rights reserved.
//

import Foundation

struct Feed{
    
    struct Item{
        let title: String;
        let desc: String;
    }
    
    let title: String;
    let items: [Item];
}
