
import Foundation

struct BitcoinArticles {
    
    var author = ""
    var content = ""
    var description = ""
    var publishedAt = ""
    var title = ""
    var url = ""
    var urlToImage = ""
    var src = source()
    
    init(){}
    
    init(JSON: [String:Any]) {
        
        author = JSON["author"] as? String ?? ""
        content = JSON["content"] as? String ?? ""
        description = JSON["description"] as? String ?? ""
        publishedAt = JSON["publishedAt"] as? String ?? ""
        title = JSON["title"] as? String ?? ""
        url = JSON["url"] as? String ?? ""
        
        urlToImage = JSON["urlToImage"] as? String ?? ""
        
        if let x = JSON["source"] as? NSDictionary{
            src = source.init(JSON: x as! [String : Any])
        }
        
    }
    
    //mark: fetch data from web service responce-----------
    func getModeldata(){
        
    }
}

struct source {
    var id = ""
    var name = ""
    
    init() {
        
    }
    
    init(JSON: [String:Any]) {
        
        if JSON["id"] is NSNull{
            
            id = ""
        }else{
            
            id = JSON["id"] as? String ?? ""
        }
        
        name = JSON["name"] as? String ?? ""
    }
}





