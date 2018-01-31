import UIKit

class HomeViewController: UIViewController {

    // TODO: Reset DB, give confirmation
    @IBAction func resetDBClicked(_ sender: Any) {
        Api.resetDb( completion: { (description: String) in
            let alert = UIAlertController(title: "Database reset", message: "ok", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in NSLog("Reset occured")}))
            self.present(alert, animated: true, completion: nil)
            print(description)
        }
    )}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
