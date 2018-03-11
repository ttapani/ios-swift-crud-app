import UIKit

class ProjectDetailsCell: UITableViewCell {
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var workedHoursLabel: UILabel!
    @IBOutlet weak var employeeImage: UIImageView!
    
    var projectDetail: ProjectDetail? {
        didSet {
            guard let projectDetail = projectDetail else { return }
            let fullName: String? = projectDetail.fname! + " " + projectDetail.lname!
            employeeNameLabel.text = fullName
            var hourslabelText = projectDetail.hours
            if projectDetail.hours! == "1" {
                hourslabelText?.append(" tunti")
            } else {
                hourslabelText?.append(" tuntia")
            }
            workedHoursLabel.text = hourslabelText
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
