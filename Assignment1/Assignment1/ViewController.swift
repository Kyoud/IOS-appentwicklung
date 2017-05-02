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
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result{
            displayValue = result
        }
        if !typing{
        if brain.resultIsPending{
            history.text = brain.description! + "..."
        }else{
            history.text = brain.description! + "="
        }
        }
    }
    @IBAction func deletedisplay(_ sender: UIButton) {
        display.text! = "0"
        history.text = " "
        brain.description = nil
        brain.resultIsPending = false
        typing = false
    }


}

