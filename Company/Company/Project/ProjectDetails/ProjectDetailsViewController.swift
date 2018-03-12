import UIKit
import os.log

class ProjectDetailsViewController: UITableViewController {
    
    var project: Project?
    var projectDetails: [ProjectDetail] = []
    var nameCell: ProjectNameCell = ProjectNameCell()
    var managerCell: ProjectManagerCell = ProjectManagerCell()
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddEmployeeMode = presentingViewController is UITabBarController
        if isPresentingInAddEmployeeMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ProjectDetailsViewController is not inside a navigationcontroller.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let project = project {
            navigationItem.title = project.pname
            loadData()
        } else {
            // Instantiate an empty object
            self.project = Project()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func loadData() -> Void {
        guard let projectId = project?.id else {
            return
        }
        self.projectDetails.removeAll()
        ProjectDetail.getProjectDetails(id: projectId) { (projectDetails) in
            self.projectDetails = projectDetails
            
            DispatchQueue.main.async(execute: {
                print("project details for " + projectId + ":")
                print(projectDetails.count)
                self.tableView.reloadData()
            })
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 3{
            return 1
        } else {
            return projectDetails.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Project name"
        } else if section == 1 {
            return "Project manager"
        } else if section == 3 {
            return "Project management"
        } else {
            return "Workers"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nameCell = tableView.dequeueReusableCell(withIdentifier: "ProjectNameCell", for: indexPath) as! ProjectNameCell
            self.nameCell = nameCell
            nameCell.projectNameLabel.text = project?.pname
            return nameCell
        }
        else if indexPath.section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ProjectManagerCell", for: indexPath) as! ProjectManagerCell
            headerCell.project = project
            if project?.image != nil {
                let url = URL(string: Api.companyImageUrl + (project?.image)!)
                Api.downloadImage(url: url!, completion: { (image: UIImage?, success: Bool, error: String?) in
                    if(success) {
                        DispatchQueue.main.async {
                            headerCell.projectManagerImage.image = image
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            headerCell.projectManagerImage.image = image
                        }
                    }
                    
                })
            } else {
                print("Employee has no image")
                headerCell.projectManagerImage.image = nil
            }
            managerCell = headerCell
            return headerCell
        } else if indexPath.section == 3 {
            let addHoursCell = tableView.dequeueReusableCell(withIdentifier: "AddHoursCell", for: indexPath) as! AddHoursCell
            return addHoursCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsCell", for: indexPath) as! ProjectDetailsCell
            let projectDetail = projectDetails[indexPath.row] as ProjectDetail
            cell.projectDetail = projectDetail
            if projectDetail.image != nil {
                let url = URL(string: Api.companyImageUrl + (projectDetail.image)!)
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
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        } else {
            return false
        }
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let projectDetail = self.projectDetails[indexPath.row]
            print("Deleting projectdetail " + projectDetail.id)
            
            ProjectDetail.deleteProjectDetail(id: projectDetail.id) { (success) in
                if(success) {
                    self.projectDetails.remove(at: indexPath.row)
                    let indexPaths = [indexPath]
                    // Sending a DELETE request to a project detail id seems to always return 200
                    // despite not changing the state, eg. actually deleting a resource..
                    // UI gets falsefully updated for now..
                    DispatchQueue.main.async(execute: {
                        print("Deleted projectdetail " + projectDetail.id)
                        tableView.deleteRows(at: indexPaths, with: .fade)
                    })
                }
                
            }
        }
        return [delete]
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "EditProjectName":
            guard let editProjectNameViewController = segue.destination as? EditProjectNameViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard (sender as? ProjectNameCell) != nil else {
                fatalError("Unexpected sender: " + sender.debugDescription)
            }
            
            editProjectNameViewController.projectName = project?.pname
            
        case "ChooseManager":
            guard let chooseManagerViewController = segue.destination as? ChooseManagerViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard (sender as? ProjectManagerCell) != nil else {
                fatalError("Unexpected sender: " + sender.debugDescription)
            }
            
            chooseManagerViewController.managerId = project?.mid
            
        case "SaveProject":
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            let pname = project?.pname
            let mid = project?.mid
            let fname = project?.fname
            let lname = project?.lname
            
            // Data when editing an employee
            let image = project?.image ?? ""
            let id = project?.id ?? ""
            
            project = Project(id: id, pname: pname, mid: mid, fname: fname!, lname: lname!, image: image)
        
        case "AddHours":
            guard let addHoursViewController = segue.destination as? AddHoursViewController else {
                return
            }

        default:
            fatalError("Unexpected Segue Identifier")
        }
    }
    
    @IBAction func unwindWithProjectName(segue: UIStoryboardSegue) {
        if let editProjectNameViewController = segue.source as? EditProjectNameViewController,
            let projectName = editProjectNameViewController.projectName {
            project?.pname = projectName
            nameCell.projectNameLabel.text = projectName
        }
    }
    
    @IBAction func unwindWithManager(segue: UIStoryboardSegue) {
        if let chooseManagerViewController = segue.source as? ChooseManagerViewController,
            let managerId = chooseManagerViewController.managerId {
            project?.mid = managerId
            
            // We need to fetch the employees and look for matching id in the collection
            // updating the cell asynchonously..
            Employee.getEmployees { (employees) in
                let newManager = employees.first(where: { (employee) -> Bool in
                    return managerId == employee.id
                })
                self.project?.fname = newManager?.fname
                self.project?.lname = newManager?.lname
                self.project?.image = newManager?.image
                DispatchQueue.main.async {
                    self.managerCell.projectManagerLabel.text = (self.project?.fname)! + " " + (self.project?.lname)!
                }
                if self.project?.image != nil {
                    let url = URL(string: Api.companyImageUrl + (self.project?.image)!)
                    Api.downloadImage(url: url!, completion: { (image: UIImage?, success: Bool, error: String?) in
                        if(success) {
                            DispatchQueue.main.async {
                                self.managerCell.projectManagerImage.image = image
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.managerCell.projectManagerImage.image = image
                            }
                        }
                        
                    })
                } else {
                    DispatchQueue.main.async {
                        print("Employee has no image")
                        self.managerCell.projectManagerImage.image = nil
                    }
                }
            }
        }
    }
    
    @IBAction func unwindWithHoursWorked(segue: UIStoryboardSegue) {
        if let addHoursViewController = segue.source as? AddHoursViewController, var projectDetail = addHoursViewController.projectDetail {
            projectDetail.pid = project?.id
            
            ProjectDetail.addProjectDetail(projectDetail: projectDetail) { (success) in
                if(success) {
                    DispatchQueue.main.async(execute: {
                        let newIndexPath = IndexPath(row: self.projectDetails.count, section: 2)
                        self.projectDetails.append(projectDetail)
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
