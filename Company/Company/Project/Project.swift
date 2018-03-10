import Foundation

struct Project {
    var id: String
    var pname: String?
    var mid: String?
    var fname: String?
    var lname: String?
    var image: String?
}

// Default constructor for empty object
extension Project {
    init() {
        self.id = ""
        self.pname = ""
        self.mid = ""
        self.fname = ""
        self.lname = ""
        self.image = ""
    }
}

// Constructing from JSON
extension Project {
    init?(json: [String: Any]) {
        self.id = (json["id"] as? String)!
        self.pname = (json["pname"] as? String) ?? nil
        self.mid = (json["mid"] as? String) ?? nil
        self.fname = (json["fname"] as? String) ?? nil
        self.lname = (json["lname"] as? String) ?? nil
        self.image = (json["image"] as? String) ?? nil
    }
}

extension Project {
    static func getProjects(completion: @escaping ([Project]) -> Void) {
        var projects: [Project] = []
        let getUrl = "projects"
        
        Api.read(getUrl: getUrl) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let projectsData = parsedData["data"] as! [[String:Any]]
                    
                    for case let result in projectsData {
                        if let project = Project(json: result) {
                            projects.append(project)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            completion(projects)
        }
    }
}
