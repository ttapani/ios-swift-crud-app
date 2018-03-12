import UIKit

class SelectDepartmentViewController: UITableViewController {
    var departments: [Department] = []
    var departmentId: String?
    var departmentName: String?
    var selectedDepartment: Department? {
        didSet {
            if let selectedDepartment = selectedDepartment, let index = departments.index(where: { (employee) in
                employee.id == selectedDepartment.id
            }) {
                selectedDepartmentIndex = index
            }
        }
    }
    var selectedDepartmentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return departments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath)
        let department = departments[indexPath.row] as Department
        cell.textLabel?.text = department.dname
        if indexPath.row == selectedDepartmentIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = selectedDepartmentIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedDepartment = departments[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveDepartment", let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let index = indexPath.row
        departmentId = departments[index].id
        departmentName = departments[index].dname
        print("preparing for segue with " + (departmentId?.debugDescription)! + " and ", departmentName)
    }
}
