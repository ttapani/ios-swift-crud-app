import UIKit

class DepartmentCell: UITableViewCell {
    @IBOutlet weak var departmentNameLabel: UILabel!
    
    var department: Department? {
        didSet {
            guard let department = department else { return }
            departmentNameLabel.text = department.dname
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
