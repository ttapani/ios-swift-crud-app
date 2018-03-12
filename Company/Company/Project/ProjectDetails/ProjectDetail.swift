import Foundation

struct ProjectDetail: Encodable {
    var id: String
    var pname: String?
    var eid: String?
    var fname: String?
    var lname: String?
    var image: String?
    var hours: String?
    var pid: String?
}

extension ProjectDetail {
    init() {
        self.id = ""
        self.pname = ""
        self.eid = ""
        self.fname = ""
        self.lname = ""
        self.image = ""
        self.hours = ""
        self.pid = ""
    }
}

extension ProjectDetail {
    init?(eid: String?, fname: String?, lname: String?, image: String?, hours: String?, pid: String?) {
        self.id = ""
        self.pname = ""
        self.eid = eid ?? ""
        self.fname = fname ?? ""
        self.lname = lname ?? ""
        self.image = image ?? ""
        self.hours = hours ?? ""
        self.pid = hours ?? ""
    }
}

extension ProjectDetail {
    init?(json: [String: Any]) {
        self.id = (json["id"] as? String)!
        self.pname = (json["pname"] as? String) ?? nil
        self.eid = (json["eid"] as? String) ?? nil
        self.fname = (json["fname"] as? String) ?? nil
        self.lname = (json["lname"] as? String) ?? nil
        self.image = (json["image"] as? String) ?? nil
        self.hours = (json["hours"] as? String) ?? nil
        self.pid = ""
    }
}

extension ProjectDetail {
    enum CodingKeys: String, CodingKey {
        case eid
        case pid
        case hours
    }
}

extension ProjectDetail {
    static func getProjectDetails(id: String, completion: @escaping ([ProjectDetail]) -> Void) {
        var projectDetails: [ProjectDetail] = []
        let getUrl = "projectdetails/" + id
        
        Api.read(getUrl: getUrl) { (data, succeeded, error)
            in
            
            if !succeeded {
                print(error)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    let projectDetailsData = parsedData["data"] as! [[String: Any]]
                    
                    for case let result in projectDetailsData {
                        if let projectDetail = ProjectDetail(json: result) {
                            projectDetails.append(projectDetail)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            completion(projectDetails)
        }
    }
    
    static func deleteProjectDetail(id: String, completion: @escaping (Bool) -> Void) {
        let deleteUrl = "projectdetail"
        
        Api.delete(collection: deleteUrl, id: id) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func addProjectDetail(projectDetail: ProjectDetail, completion: @escaping (Bool) -> Void) {
        let addUrl = "projectdetail"
        let encoder = JSONEncoder()
        //encoder = .prettyPrinted
        let encodedProject = try? encoder.encode(projectDetail)
        //print(String(data: encodedEmployee!, encoding: .utf8)!)
        Api.add(collection: addUrl, encodedData: encodedProject!) { (data, succeeded, error) in
            if !succeeded {
                print("Projectdetail add failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
}
