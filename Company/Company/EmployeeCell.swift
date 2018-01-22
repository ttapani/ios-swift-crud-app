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
            
            let url = URL(string: Api.companyImageUrl + employee.image!)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.employeeImage.image = UIImage(data: data!)
                }
            }
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
