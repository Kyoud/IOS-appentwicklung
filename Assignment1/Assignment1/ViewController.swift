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
    
    var typing = false
    
    var Displayvalue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text=String(newValue)
        }
    }

    
    @IBAction func touchDigit(_ sender: UIButton) {
        if typing{
            display.text = display.text! + sender.currentTitle!
        }else{
            typing = true
            display.text = sender.currentTitle!
        }
    }
    var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        typing = false
        Displayvalue = brain.mathsimbols[sender.currentTitle!]!
    }
    

}

