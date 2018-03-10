import Foundation

struct Department {
    var id: String
    var dname: String?
}

// Default constructor for empty object
extension Department {
    init() {
        self.id = ""
        self.dname = ""
    }
}

// Constructing from JSON
extension Department {
    init?(json: [String: Any]) {
        self.id = (json["id"] as? String)!
        self.dname = (json["dname"] as? String) ?? nil
    }
}

extension Department {
    static func getDepartments(completion: @escaping ([Department]) -> Void) {
        var departments: [Department] = []
        let getUrl = "departments"
        
        Api.read(getUrl: getUrl) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let departmentsData = parsedData["data"] as! [[String:Any]]
                    
                    for case let result in departmentsData {
                        if let department = Department(json: result) {
                            departments.append(department)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            completion(departments)
        }
    }
}
