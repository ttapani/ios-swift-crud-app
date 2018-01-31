//
//  EmployeeDetailsViewController.swift
//  Company
//
//  Created by Tomi Heino on 29/01/2018.
//  Copyright © 2018 th. All rights reserved.
//

import UIKit

class EmployeeDetailsViewController: UITableViewController {

    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
