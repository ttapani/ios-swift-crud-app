import UIKit
import os.log

class EmployeeDetailsViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var phone1TextField: UITextField!
    @IBOutlet weak var phone2TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var employee: Employee?
    var departmentId: String?
    @IBOutlet weak var bdayDatePicker: UIDatePicker!
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddEmployeeMode = presentingViewController is UITabBarController
        if isPresentingInAddEmployeeMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The EmployeeDetailsViewController is not inside a navigationcontroller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton, segue.identifier == "SaveEmployee" else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let fname = fnameTextField.text
        let lname = lnameTextField.text
        let salary = salaryTextField.text
        //let bday = birthdayTextField.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ("yyyy-MM-dd")
        let bday = dateFormatter.string(from: bdayDatePicker.date)
        let email = emailTextField.text
        let dep = departmentId
        let phone1 = phone1TextField.text
        let phone2 = phone2TextField.text
        
        // Data when editing an employee
        let image = employee?.image ?? ""
        let id = employee?.id ?? ""
        let dname = employee?.dname ?? ""
        
        employee = Employee(id: id, fname: fname!, lname: lname!, salary: salary!, bdate: bday, email: email!, dep: dep!, dname: dname, phone1: phone1!, phone2: phone2!, image: image)
    }
    
    @IBAction func unwindWithDepartment(segue: UIStoryboardSegue) {
        if let selectDepartmentViewController = segue.source as? SelectDepartmentViewController,
            let departmentId = selectDepartmentViewController.departmentId, let departmentName = selectDepartmentViewController.departmentName {
            employee?.dname = departmentName
            employee?.dep = departmentId
            self.departmentId = departmentId
            departmentLabel.text = departmentName
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            fnameTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        fnameTextField.delegate = self
        
        if let employee = employee {
            navigationItem.title = employee.fname! + " " + employee.lname!
            fnameTextField.text = employee.fname
            lnameTextField.text = employee.lname
            salaryTextField.text = employee.salary?.description
            //birthdayTextField.text = employee.bdate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ("yyyy-MM-dd")
            let date = dateFormatter.date(from: employee.bdate!)
            bdayDatePicker.setDate(date!, animated: false)
            emailTextField.text = employee.email
            departmentLabel.text = employee.dname
            departmentId = employee.dep
            phone1TextField.text = employee.phone1
            phone2TextField.text = employee.phone2
        }
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        let text = fnameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    

}
