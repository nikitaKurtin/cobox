import Foundation

struct Api {
    //Encapsulated to Api struct
    //Taking in account that base url can change
    private static let baseUrl = "http://feeds.reuters.com/reuters";
    
    //Accessible within the project
    //Taking in account that endpoints can move to different domains
    static let businessNewsUrl = baseUrl + "/businessNews";
    static let entertainmentUrl = baseUrl + "/entertainment";
    static let environmentUrl = baseUrl + "/environment";
    
    //Only HTTP GET used here, therefor name load seems accurate
    static func load(fromURL url:String, completion:@escaping (Data?,URLResponse?, Error?)->()){
        URLSession.shared.dataTask(with: URL(string:url)!, completionHandler: completion).resume();
    }
    
}
