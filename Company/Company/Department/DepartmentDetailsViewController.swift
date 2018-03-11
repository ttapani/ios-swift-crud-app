import UIKit
import os.log

class DepartmentDetailsViewController: UITableViewController {
    @IBOutlet weak var departmentNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var department: Department?

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddDepartmentMode = presentingViewController is UITabBarController
        if isPresentingInAddDepartmentMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DepartmentDetailsViewController is not inside a navigationcontroller.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let department = department {
            navigationItem.title = department.dname
            departmentNameTextField.text = department.dname
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let dname = departmentNameTextField.text
        let id = department?.id ?? ""
        
        department = Department(id: id, dname: dname)
    }

}
