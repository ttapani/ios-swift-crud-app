import UIKit
import os.log

class AddHoursViewController: UITableViewController {
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var hoursWorkedLabel: UILabel!
    @IBOutlet weak var hoursWorkedStepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var employee: Employee?
    var employeeId: String?
    var hoursWorked: String?
    var projectDetail: ProjectDetail?

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperChanged(_ sender: Any?) {
        let value = Int(hoursWorkedStepper.value)
        if value <= 1 {
            hoursWorkedLabel.text = value.description + " tunti"
        } else {
            hoursWorkedLabel.text = value.description + " tuntia"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem
        stepperChanged(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindWithWorker(segue: UIStoryboardSegue) {
        if let chooseWorkerViewController = segue.source as? ChooseWorkerViewController,
            let employeeId = chooseWorkerViewController.employeeId {
            self.employeeId = employeeId
            
            // We need to fetch the employees and look for matching id in the collection
            // updating the cell asynchonously..
            Employee.getEmployees { (employees) in
                let employee = employees.first(where: { (employee) -> Bool in
                    return employeeId == employee.id
                })
                print("found employee: " + employee.debugDescription)
                self.employee = employee
                DispatchQueue.main.async {
                    self.employeeNameLabel.text = (employee?.fname)! + " " + (employee?.lname)!
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let eid = employee?.id
        let fname = employee?.fname
        let lname = employee?.lname
        let image = employee?.image
        let hours = Int(hoursWorkedStepper.value).description
        
        projectDetail = ProjectDetail(eid: eid!, fname: fname!, lname: lname!, image: image!, hours: hours, pid: "")!
    }
}
