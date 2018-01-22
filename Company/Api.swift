import Foundation

struct Api {
    static var companyUrl = "https://home.tamk.fi/~poypek/iosapi6/index.php/"
    static var companyImageUrl = "https://home.tamk.fi/~poypek/iosapi6/"
    
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
}