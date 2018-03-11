import UIKit
import os.log

class DepartmentsViewController: UITableViewController {
    var departments: [Department] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func loadData() -> Void {
        self.departments.removeAll()
        Department.getDepartments { (departments) in
            self.departments = departments
            
            DispatchQueue.main.async(execute: {
                print("departments: ")
                print(self.departments.count)
                self.tableView.reloadData()
            })
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as! DepartmentCell
        
        let department = departments[indexPath.row] as Department
        cell.department = department
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete department in api, update locally
            let department = departments[indexPath.row]
            Department.deleteDepartment(id: department.id) { (success) in
                if(success) {
                    self.departments.remove(at: indexPath.row)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddDepartment":
            os_log("Adding a new department", log: OSLog.default, type: .debug)
            
        case "ShowDepartmentDetail":
            guard let departmentDetailsViewController = segue.destination as? DepartmentDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDepartmentCell = sender as? DepartmentCell else {
                fatalError("Unexpected sender: " + sender.debugDescription)
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDepartmentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDepartment = departments[indexPath.row]
            departmentDetailsViewController.department = selectedDepartment
            
        default:
            fatalError("Unexpected Segue Identifier")
        }
    }
 
    // MARK: - Actions
    @IBAction func unwindToDepartmentsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DepartmentDetailsViewController, let department = sourceViewController.department {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print("returning from editing")
                print(department)
                // Send changes to api
                Department.updateDepartment(department: department) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            self.departments[selectedIndexPath.row] = department
                            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        })
                    }
                }
            }
            else {
                Department.addDepartment(department: department) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            let newIndexPath = IndexPath(row: self.departments.count, section: 0)
                            self.departments.append(department)
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
