//
//  FeedParser.swift
//  CoBoxTask
//
//  Copyright © 2018 Nikita. All rights reserved.
//

import Foundation

class FeedParser : XMLParser, XMLParserDelegate{
    
    //Parseable keys
    private struct Keys{
        static let title = "title";
        static let item = "item";
        static let description = "description";
    }
    
    //Flags to navigate parsing
    private var isListItem = false;
    private var isItemTitle = false;
    private var isItemDesc = false;
    private var isMainTitle = false;
    
    //Titles
    private var mainTitle:String?;
    private var currentItemTitle : String?;
    
    //Array of all feed items
    private var allItems : [Feed.Item] = [];
    
    override init(data: Data) {
        super.init(data: data);
        self.delegate=self;
    }
    
    //Starting elements
    func parser(_ parser: XMLParser, didStartElement elem: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if mainTitle == nil && elem == Keys.title{//Main title found
            isMainTitle = true;
        }else if isListItem{
            if elem == Keys.title{//found title
                isItemTitle = true;
            }else if elem == Keys.description{//found description
                isItemDesc = true;
            }
        }else if elem == Keys.item{//found item
            isListItem=true;
        }
    }
    
    //Contents of each element
    func parser(_ parser: XMLParser, foundCharacters content: String) {
        if isMainTitle{
            mainTitle = content;
            isMainTitle = false;
        }else if isItemTitle && content != currentItemTitle{
            currentItemTitle = content;//store new item title
        }else if isItemDesc && currentItemTitle != nil{//When item description reached the Item can be stored
            allItems.append(Feed.Item(title: currentItemTitle!, desc: content));
            currentItemTitle = nil;
        }
    }
    
    //Closing elements
    func parser(_ parser: XMLParser, didEndElement elem: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isListItem{
            if elem == Keys.title{//closing item title
                isItemTitle = false;
            }else if elem == Keys.description{//closing item description
                isItemDesc = false;
            }else if elem == Keys.item{//closing whole item
                isListItem = false;
            }
        }
    }
    //parsing failure
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Failed to parse \(parseError.localizedDescription)");
    }
    //get all users
    func getFeed()->Feed{
        return Feed(title: mainTitle!, items: allItems);
    }
}
