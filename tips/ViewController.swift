//
//  ViewController.swift
//  tips
//
//  Created by Cassandra James on 12/19/15.
//  Copyright © 2015 Cassandra James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var dividingBar: UIView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var mealCost: Float?
    var tipPercent: Float = 20.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tipLabel.text = "0.00"
        totalLabel.text = "0.00"
    }
    
    func updateTotalLabel(){
        if mealCost != nil {
            self.totalLabel.text = "\(totalCost())"
            self.tipLabel.text = "\(tipAmount())"
        } else if (self.billField.text!.isEmpty) {
            self.totalLabel.text = ""
        } else {
            self.totalLabel.text = "Invalid Cost!"
        }
        
        onEditingChanged([:])
    }
    
    func totalCost() -> Float {
        return mealCost! + tipPercent / 100.0 * mealCost!
    }
    
    func tipAmount() -> Float {
        return tipPercent / 100.0 * mealCost!
    }
    
    @IBAction func billFieldChanged(sender: UITextField) {
        self.mealCost = Float(sender.text!)
        
        updateTotalLabel()
    }
    
    @IBAction func tipSliderChanged(sender: UISlider) {
        self.tipPercent = round(sender.value)
        self.tipPercentLabel.text = "\(Int(self.tipPercent))%"

        updateTotalLabel()
        
        totalLabel.text = String(format: "$%.2f", totalCost())
        tipLabel.text = String(format: "$%.2f", tipAmount())
        //changes slider dollar value

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTipAmount()
    }
    
    func updateTipAmount() {
        var tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = formatNumberforLocale(tip)
        totalLabel.text = formatNumberforLocale(total)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func updateColorFromDefaults() {
        let colorName : String? = defaults.objectForKey("color") as? String
        
        let white = UIColor.whiteColor()
        let lightblue = UIColor(red: 0/255, green: 152/255, blue: 155/255, alpha: 1.0)
        let darkblue = UIColor(red: 0/255, green: 56/255, blue: 109/255, alpha: 1.0)
        
        print("recieved default color: \(colorName)")

        
        //default to "Light"
        var background = white
        var foreground = lightblue
        
        if colorName == "Dark" {
            background = darkblue
            foreground = white
            
            
        }

        view.backgroundColor = background
        view.tintColor = foreground
        dividingBar.backgroundColor = foreground
        
        for sub in view.subviews {
            if sub.isKindOfClass(UILabel) {
                let label = sub as! UILabel
                label.textColor = foreground
            }
        }
    }
    
    func formatNumberforLocale(num: Double) -> String{
        let identifier : String? = defaults.objectForKey("locale") as? String
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle

        if let localeIdentifier = identifier {
            formatter.locale = NSLocale(localeIdentifier: identifier!)
        } else {
            formatter.locale = NSLocale(localeIdentifier: "en_US")
        }
       // print("recieved default currency: \(identifier)")
        
        return formatter.stringFromNumber(num)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = defaults.integerForKey("default_tip")
        print("recieved default tip: \(defaultTip)")
        switch defaultTip {
        case 0...2:
            tipControl.selectedSegmentIndex = defaultTip
        default:
            tipControl.selectedSegmentIndex = 0
        }
        updateTipAmount()
        updateColorFromDefaults()
    
    }

   }