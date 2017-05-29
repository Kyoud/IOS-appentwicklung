//
//  ViewController.swift
//  Assignment1
//
//  Created by app on 11.04.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UITextView!
    
    @IBOutlet weak var varDisplay: UITextField!
    
    var variables: [String:Double] = [:]
    
    var typing = false
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text=String(newValue)
        }
    }
    
    @IBOutlet weak var delete: UIButton!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if(!(sender.currentTitle==".") || !(display.text!.contains("."))){
            if typing{
                display.text = display.text! + sender.currentTitle!
                
            }else{
                if(sender.currentTitle=="." && display.text == "0"){
                    display.text = "0"+sender.currentTitle!
                }
                else{
                    display.text = sender.currentTitle!
                }
                typing = true
            }
        }
    }
    
    
    
    var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if typing {
            brain.setOperand(displayValue)
            typing = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.setOperation(mathematicalSymbol)
            descriptionstyle( result: brain.evaluate(using: variables))
        }
        /*if let result = brain.result{
         displayValue = result
         }else{
         displayValue = 0
         }*/
        if !typing{
            //descriptionstyle()
        }
    }
    @IBAction func deletedisplay(_ sender: UIButton) {
        display.text! = "0"
        history.text = " "
        typing = false
        brain.clear()
    }
    @IBAction func useVariable(_ sender: UIButton) {
        brain.setVariable(sender.currentTitle!)
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        varDisplay.text = "M: " + String(displayValue)
        brain.setVariable(sender.currentTitle!)
        variables["M"] = displayValue
    }
    
    @IBAction func undo(_ sender: Any) {
        brain.undo()
         descriptionstyle( result: brain.evaluate(using: variables))
        
    }
    func descriptionstyle(result:( Double?, Bool, String)){
        history.text = result.2
        
        if result.0 != nil {
            displayValue = result.0!
        }
        if result.1{
            history.text = history.text + "..."
        }else{
            history.text = history.text + "="
        }
    }
}
