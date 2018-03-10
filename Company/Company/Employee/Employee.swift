import Foundation

struct Employee: Encodable {
    var id: String
    var fname: String?
    var lname: String?
    var salary: Double?
    var bdate: String?
    var email: String?
    var dep: String?
    var dname: String?
    var phone1: String?
    var phone2: String?
    var image: String?
}

extension Employee {
    init() {
        self.id = ""
        self.fname = ""
        self.lname = ""
        self.salary = 0.0
        self.bdate = ""
        self.email = ""
        self.dep = ""
        self.dname = ""
        self.phone1 = ""
        self.phone2 = ""
        self.image = ""
    }
}

extension Employee {
    enum CodingKeys: String, CodingKey {
        case fname
        case lname
        case salary
        case bdate
        case email
        case dep
        case phone1
        case phone2
        case image
    }
}

extension Employee {
    init?(json: [String: Any]) {
        self.id = (json["id"] as? String)!
        self.fname = json["fname"] as? String ?? ""
        self.lname = json["lname"] as? String ?? ""
        let tmpSalary = json["salary"] as? String ?? "0.0"
        self.salary = Double(tmpSalary)
        self.bdate = json["bdate"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.dep = json["dep"] as? String ?? nil
        self.dname = json["dname"] as? String ?? ""
        self.phone1 = json["phone1"] as? String ?? nil
        self.phone2 = json["phone2"] as? String ?? nil
        self.image = json["image"] as? String ?? nil
    }
}

extension Employee {
    init?(id: String?, fname: String?, lname: String?, salary: String?, bdate: String?, email: String?, dep: String?, dname: String?, phone1: String?, phone2: String?, image: String?) {
        self.id = (id ?? nil)!
        self.fname = fname
        self.lname = lname
        let tmpSalary = salary ?? "0.0"
        self.salary = Double(tmpSalary)
        self.bdate = bdate
        self.email = email
        self.dep = dep
        self.dname = dname ?? ""
        self.phone1 = phone1
        self.phone2 = phone2
        self.image = image ?? nil
    }
}



extension Employee {
    
    static func getEmployees(completion: @escaping ([Employee]) -> Void) {
        var employees: [Employee] = []
        let getUrl = "employees"
        
        Api.read(getUrl: getUrl) { (data, succeeded, error)
            in
            
            if !succeeded {
                print(error as Any)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let employeesData = parsedData["data"] as! [[String:Any]]
                    
                    for case let result in employeesData {
                        if let employee = Employee(json: result) {
                            employees.append(employee)
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            completion(employees)
        }
        
    }
    
    static func deleteEmployee(id: String, completion: @escaping (Bool) -> Void) {
        let deleteUrl = "employee"
        
        Api.delete(collection: deleteUrl, id: id) { (data, succeeded, error) in
            if !succeeded {
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func addEmployee(employee: Employee, completion: @escaping (Bool) -> Void) {
        let addUrl = "employee"
        let encoder = JSONEncoder()
        //encoder = .prettyPrinted
        let encodedEmployee = try? encoder.encode(employee)
        //print(String(data: encodedEmployee!, encoding: .utf8)!)
        Api.add(collection: addUrl, encodedData: encodedEmployee!) { (data, succeeded, error) in
            if !succeeded {
                print("Employee add failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
    
    static func updateEmployee(employee: Employee, completion: @escaping (Bool) -> Void) {
        let updateUrl = "employee"
        let encoder = JSONEncoder()
        let encodedEmployee = try? encoder.encode(employee)
        print(String(data: encodedEmployee!, encoding: .utf8)!)
        Api.update(collection: updateUrl, id: employee.id, encodedData: encodedEmployee!) { (data, succeeded, error) in
            if !succeeded {
                print("Employee update failed, error: ")
                print(error as Any)
            } else {
                completion(succeeded)
            }
        }
    }
}
