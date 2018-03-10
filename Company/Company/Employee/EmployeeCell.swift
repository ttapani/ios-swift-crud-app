import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var employeeImage: UIImageView!
    
    var employee: Employee? {
        didSet {
            guard let employee = employee else { return }
            
            let fullName: String? = employee.fname! + " " + employee.lname!
            nameLabel.text = fullName
            departmentLabel.text = employee.dname

            
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url!) {
//                    DispatchQueue.main.async {
//                        print("employee " + fullName! + " image set")
//                        self.employeeImage.image = UIImage(data: data)
//                    }
//                }
//                else {
//                    DispatchQueue.main.async {
//                        print("employee image not found")
//                        self.employeeImage.image = UIImage()
//                    }
//                }
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
