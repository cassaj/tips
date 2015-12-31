//
//  SettingsViewController.swift
//  tips
//
//  Created by Cassandra James on 12/21/15.
//  Copyright © 2015 Cassandra James. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var percentControl: UISegmentedControl!
    @IBOutlet weak var colorControl: UISegmentedControl!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadSavedSettings() {
        let locale = defaults.objectForKey("locale") as? String
        let color = defaults.objectForKey("color") as? String
        
        if let localeStr = locale {
            switch localeStr {
            case "en_US" :
                currencyControl.selectedSegmentIndex = 0
            case "eu_EU":
                currencyControl.selectedSegmentIndex = 1
            default: break
            }
        }
        
        if let colorStr = color {
            switch colorStr {
            case "Light" :
                colorControl.selectedSegmentIndex = 0
            case "Dark" :
                colorControl.selectedSegmentIndex = 1
            default: break
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorThemeChanged(sender: AnyObject) {
        let index = colorControl.selectedSegmentIndex
        let colorName = colorControl.titleForSegmentAtIndex(index)!
        
        let white = UIColor.whiteColor()
        let lightblue = UIColor(red: 0/255, green: 152/255, blue: 155/255, alpha: 1.0)
        let darkblue = UIColor(red: 0/255, green: 56/255, blue: 109/255, alpha: 1.0)
        
        //default to "Light"
        var background = white
        var foreground = lightblue
        
        if colorName == "Dark" {
            background = darkblue
            foreground = white
        }
        
        view.backgroundColor = background
        view.tintColor = foreground
        
        for sub in view.subviews {
            if sub.isKindOfClass(UILabel) {
                let label = sub as! UILabel
                label.textColor = foreground
            }
        }
        defaults.setObject(colorName, forKey: "color")
        defaults.synchronize()
    }

    @IBAction func tipControlChanged(sender:UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(sender.selectedSegmentIndex, forKey: "default_tip")
        defaults.synchronize()
    }
    
    @IBAction func currencyChanged(sender: AnyObject) {
        let identifiers = ["en_US", "eu_EU"]
        let index = currencyControl.selectedSegmentIndex
        let identifier = identifiers[index]
        
        defaults.setObject(identifier, forKey: "locale")
        defaults.synchronize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedSettings()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = defaults.integerForKey("default_tip")
        print("got default tip: \(defaultTip)")
        switch defaultTip {
        case 0...2:
            percentControl.selectedSegmentIndex = defaultTip
        default:
            percentControl.selectedSegmentIndex = 0
        }
        
    }

    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
