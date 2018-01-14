//
//  ViewController.swift
//  vko2
//
//  Created by Tomi Heino on 08/01/2018.
//  Copyright © 2018 Tomi Heino. All rights reserved.
///Users/hemulizard/Documents/AMK/swift_kehittyneet_ohjelmointikielet/tomi.heino/vko2/vko2/Info.plist

import UIKit

class ViewController: UIViewController {


    // Entry labels
    @IBOutlet weak var multiplicationLabel1: UILabel!
    @IBOutlet weak var multiplicationLabel2: UILabel!
    @IBOutlet weak var multiplicationLabel3: UILabel!
    
    // Textboxes
    @IBOutlet weak var entryTextField1: UITextField!
    @IBOutlet weak var entryTextField2: UITextField!
    @IBOutlet weak var entryTextField3: UITextField!
    
    // Result labels
    @IBOutlet weak var resultLabel1: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var resultLabel3: UILabel!
    @IBOutlet weak var resultTextLabel: UILabel!
    
    var entries: [MultiplicationEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame(nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkResults(_ sender: UIButton) {
//        var niceSmiley = Attributed
        
        var correctResults = 0;
        if(entryTextField1.text == String(entries[0].result())) {
            correctResults += 1
            resultLabel1.text = ":-)"
            resultLabel1.textColor = UIColor.green
        } else {
            resultLabel1.text = ":-("
            resultLabel1.textColor = UIColor.red
        }
        if(entryTextField2.text == String(entries[1].result())) {
            correctResults += 1
            resultLabel2.text = ":-)"
            resultLabel2.textColor = UIColor.green
        } else {
            resultLabel2.text = ":-("
            resultLabel2.textColor = UIColor.red
        }
        if(entryTextField3.text == String(entries[2].result())) {
            correctResults += 1
            resultLabel3.text = ":-)"
            resultLabel3.textColor = UIColor.green
        } else {
            resultLabel3.text = ":-("
            resultLabel3.textColor = UIColor.red
        }
        if(correctResults != 3) {
            resultTextLabel.text = "Reenaa vielä! Sait \(correctResults)/3 oikein!"
        } else {
            resultTextLabel.text = "Hyvää työtä! Sait \(correctResults)/3 oikein!"
        }
        
    }
    
    @IBAction func resetGame(_ sender: UIButton?) {
        generateEntries()
        multiplicationLabel1.text = entries[0].description()
        multiplicationLabel2.text = entries[1].description()
        multiplicationLabel3.text = entries[2].description()
        
        entryTextField1.text = "";
        entryTextField2.text = "";
        entryTextField3.text = "";
        
        resultLabel1.text = ""
        resultLabel2.text = ""
        resultLabel3.text = ""
        resultTextLabel.text = ""
    }
    
    func generateEntries() {
        entries.removeAll()
        for _ in 0..<3 {
            entries.append(MultiplicationEntry())
        }
    }
}

