//
//  ProjectsViewController.swift
//  Company
//
//  Created by Tomi Heino on 29/01/2018.
//  Copyright © 2018 th. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController {
    var projects: [Project] = []

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
}
