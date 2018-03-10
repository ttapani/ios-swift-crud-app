import UIKit
import os.log

class EmployeesViewController: UITableViewController {
    var employees: [Employee] = []

    @IBAction func refreshEmployeesClicked(_ sender: Any?) {
        loadData()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshEmployeesClicked), for: .valueChanged)
        
        navigationItem.leftBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func loadData() -> Void {
        self.employees.removeAll()
        Employee.getEmployees { (employees) in
            self.employees = employees
            
            DispatchQueue.main.async(execute: {
                print("emp: ")
                print(self.employees.count)
                self.tableView.reloadData()
            })
            
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        
        let employee = employees[indexPath.row] as Employee
        cell.employee = employee
        if employee.image != nil {
            let url = URL(string: Api.companyImageUrl + employee.image!)
            
            Api.downloadImage(url: url!, completion: { (image: UIImage?, success: Bool, error: String?) in
                if(success) {
                    DispatchQueue.main.async {
                        cell.employeeImage.image = image
                    }
                }
                else {
                    DispatchQueue.main.async {
                        cell.employeeImage.image = image
                    }
                }
                
            })
        } else {
            print("Employee has no image")
            cell.employeeImage.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete employee in api, update locally
            let employee = employees[indexPath.row]
            Employee.deleteEmployee(id: employee.id) { (success) in
                if(success) {
                    self.employees.remove(at: indexPath.row)
                    let indexPaths = [indexPath]
                    DispatchQueue.main.async(execute: {
                        tableView.deleteRows(at: indexPaths, with: .fade)
                    })
                }
                
            }
        }
        else if editingStyle == .insert {
            
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddEmployee":
            os_log("Adding a new employee", log: OSLog.default, type: .debug)
            
        case "ShowEmployeeDetail":
            guard let employeeDetailsViewController = segue.destination as? EmployeeDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEmployeeCell = sender as? EmployeeCell else {
                //fatalError("Unexpected sender: \(sender)")
                fatalError("Unexpected sender: " + sender.debugDescription)
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEmployeeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEmployee = employees[indexPath.row]
            employeeDetailsViewController.employee = selectedEmployee
            
        default:
            fatalError("Unexpected Segue Identifier")
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToEmployeeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EmployeeDetailsViewController, let employee = sourceViewController.employee {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing employee
                //employees[selectedIndexPath.row] = employee
                //tableView.reloadRows(at: [selectedIndexPath], with: .none)
                print("returning from editing")
                print(employee)
                // Send changes to api
                Employee.updateEmployee(employee: employee) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            self.employees[selectedIndexPath.row] = employee
                            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        })
                    }
                }
            }
            else {
                Employee.addEmployee(employee: employee) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            let newIndexPath = IndexPath(row: self.employees.count, section: 0)
                            self.employees.append(employee)
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        })
                    }
                    else {
                        print("error in api")
                    }

                }
            }

        }
    }

}

