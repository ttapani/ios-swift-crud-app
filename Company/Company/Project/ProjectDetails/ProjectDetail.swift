import Foundation

struct ProjectDetail {
    var id: String
    var pname: String?
    var eid: String?
    var fname: String?
    var lname: String?
    var image: String?
    var hours: String?
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
}
