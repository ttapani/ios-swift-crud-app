import Foundation
import UIKit

struct Api {
    static var companyUrl = "https://home.tamk.fi/~poypek/iosapi6/index.php/"
    static var companyImageUrl = "https://home.tamk.fi/~poypek/iosapi6/"
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    // this resets the db
    static func resetDb (completion: @escaping (String) -> Void){
        let url = URL(string: self.companyUrl + "resetDB")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            completion((response?.description)!)
            print ((response?.description)!)
            }.resume()
        
    }
    
    // this handles api reads
    static func read(getUrl: String, getCompleted:@escaping (Data?, Bool, String) -> Void) {
        let apiUrl = URL(string: self.companyUrl + getUrl)
        URLSession.shared.dataTask(with: apiUrl!) { (data, response, error)  in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    getCompleted(nil, false, String(httpResponse.statusCode))
                } else {
                    getCompleted(data, true, String(httpResponse.statusCode))
                }
            }
        }.resume()
    }
    
    // This handles api posts
    static func add(collection: String, encodedData: Data, addCompleted:@escaping (Data?, Bool, String) -> Void) {
        let apiUrl = URL(string: self.companyUrl + collection)
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "POST"
        request.httpBody = encodedData
        print("HTTP POST: " + request.description)
        print(request.httpBody?.description)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    addCompleted(nil, false, String(httpResponse.statusCode))
                } else {
                    addCompleted(data, true, String(httpResponse.statusCode))
                }
            }
            }.resume()
    }
    
    static func update(collection: String, id: String, encodedData: Data, updateCompleted:@escaping (Data?, Bool, String) -> Void) {
        let apiUrl = URL(string: self.companyUrl + collection + "/" + id)
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "PUT"
        request.httpBody = encodedData
        print("HTTP PUT: " + request.description)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    updateCompleted(nil, false, String(httpResponse.statusCode))
                } else {
                    updateCompleted(data, true, String(httpResponse.statusCode))
                }
            }
        }.resume()
    }
    
    // this handles api deletions
    static func delete(collection: String, id: String, deleteCompleted:@escaping (Data?, Bool, String) -> Void) {
        let apiUrl = URL(string: self.companyUrl + collection + "/" + id)
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "DELETE"
        print(request as Any)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    deleteCompleted(nil, false, String(httpResponse.statusCode))
                } else {
                    deleteCompleted(data, true, String(httpResponse.statusCode))
                }
            }
        }.resume()
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?, Bool, String?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, true, nil)
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image, true, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        print("employee image not found")
                        completion(nil, false, nil)
                    }
                }
            }
        }
    }
}
