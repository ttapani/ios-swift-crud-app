import UIKit

class ProjectManagerCell: UITableViewCell {
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectManagerLabel: UILabel!
    @IBOutlet weak var projectManagerImage: UIImageView!
    
    var project: Project? {
        didSet {
            guard let project = project else { return }
            let fullName: String? = project.fname! + " " + project.lname!
            projectNameLabel.text = project.pname
            projectManagerLabel.text = fullName
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
