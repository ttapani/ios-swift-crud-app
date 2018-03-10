import UIKit

class ProjectCell: UITableViewCell {
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var project: Project? {
        didSet {
            guard let project = project else { return }
            projectNameLabel.text = project.pname
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
