import Foundation

struct Department: Encodable {
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
    enum CodingKeys: String, CodingKey {
        case dname
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
    
    static func deleteDepartment(id: String, completion: @escaping (Bool) -> Void) {
        let deleteUrl = "department"
        
        Api.delete(collection: deleteUrl, id: id) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func addDepartment(department: Department, completion: @escaping (Bool) -> Void) {
        let addUrl = "department"
        let encoder = JSONEncoder()
        //encoder = .prettyPrinted
        let encodedDepartment = try? encoder.encode(department)
        //print(String(data: encodedEmployee!, encoding: .utf8)!)
        Api.add(collection: addUrl, encodedData: encodedDepartment!) { (data, succeeded, error) in
            if !succeeded {
                print("Department add failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func updateDepartment(department: Department, completion: @escaping (Bool) -> Void) {
        let updateUrl = "department"
        let encoder = JSONEncoder()
        let encodedDepartment = try? encoder.encode(department)
        print(String(data: encodedDepartment!, encoding: .utf8)!)
        Api.update(collection: updateUrl, id: department.id, encodedData: encodedDepartment!) { (data, succeeded, error) in
            if !succeeded {
                print("Department update failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
}
