import Foundation

struct Project: Encodable {
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
    enum CodingKeys: String, CodingKey {
        case pname
        case mid
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
    
    static func deleteProject(id: String, completion: @escaping (Bool) -> Void) {
        let deleteUrl = "project"
        
        Api.delete(collection: deleteUrl, id: id) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func addProject(project: Project, completion: @escaping (Bool) -> Void) {
        let addUrl = "project"
        let encoder = JSONEncoder()
        //encoder = .prettyPrinted
        let encodedProject = try? encoder.encode(project)
        //print(String(data: encodedEmployee!, encoding: .utf8)!)
        Api.add(collection: addUrl, encodedData: encodedProject!) { (data, succeeded, error) in
            if !succeeded {
                print("Project add failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func updateProject(project: Project, completion: @escaping (Bool) -> Void) {
        let updateUrl = "project"
        let encoder = JSONEncoder()
        let encodedProject = try? encoder.encode(project)
        print(String(data: encodedProject!, encoding: .utf8)!)
        Api.update(collection: updateUrl, id: project.id, encodedData: encodedProject!) { (data, succeeded, error) in
            if !succeeded {
                print("Project update failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
}
