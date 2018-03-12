import UIKit
import os.log

class ProjectsViewController: UITableViewController {
    var projects: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func loadData() -> Void {
        self.projects.removeAll()
        Project.getProjects { (projects) in
            self.projects = projects
            
            DispatchQueue.main.async(execute: {
                print("projects:")
                print(projects.count)
                self.tableView.reloadData()
            })
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell

        let project = projects[indexPath.row] as Project
        cell.project = project
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete department in api, update locally
            let project = projects[indexPath.row]
            Project.deleteProject(id: project.id) { (success) in
                if(success) {
                    self.projects.remove(at: indexPath.row)
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
        case "AddProject":
            os_log("Adding a new project", log: OSLog.default, type: .debug)
            
        case "ShowProjectDetails":
            guard let projectDetailsViewController = segue.destination as? ProjectDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedProjectCell = sender as? ProjectCell else {
                fatalError("Unexpected sender: " + sender.debugDescription)
            }
            
            guard let indexpath = tableView.indexPath(for: selectedProjectCell ) else {
                fatalError("Selected cell is not displayed on the table")
            }
            
            let selectedProject = projects[indexpath.row]
            projectDetailsViewController.project = selectedProject
        
        default:
            fatalError("Unexpected segue indentifier")
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToProjectList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ProjectDetailsViewController, let project = sourceViewController.project {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print("returning from editing")
                print(project)
                // Send changes to api
                Project.updateProject(project: project) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            self.projects[selectedIndexPath.row] = project
                            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        })
                    }
                }
            }
            else {
                Project.addProject(project: project) { (success) in
                    if(success) {
                        DispatchQueue.main.async(execute: {
                            let newIndexPath = IndexPath(row: self.projects.count, section: 0)
                            self.projects.append(project)
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
