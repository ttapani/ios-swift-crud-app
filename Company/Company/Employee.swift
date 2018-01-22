import Foundation

struct Employee {
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
        self.phone1 = json["phone1"] as? String ?? ""
        self.phone2 = json["phone2"] as? String ?? ""
        self.image = json["image"] as? String ?? ""
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
}
