//
//  ViewController.swift
//  Assignment1
//
//  Created by app on 11.04.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
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
        display.text! = ""
        history.text = " "
        typing = false
        brain.clear()
        varDisplay.text = "M:"
        variables.removeAll()
    }
    @IBAction func useVariable(_ sender: UIButton) {
        brain.setVariable(sender.currentTitle!)
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        varDisplay.text = "M: " + String(displayValue)
        variables["M"] = displayValue
        descriptionstyle( result: brain.evaluate(using: variables))
        typing=false
    }
    
    @IBAction func undo(_ sender: Any) {
        if(!typing){
        brain.undo()
        descriptionstyle( result: brain.evaluate(using: variables))
        }else if(display.text != ""){
            var tmp = display.text!
            tmp.remove(at: tmp.index(before: tmp.endIndex))
            display.text = tmp
        }
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !typing && !brain.evaluate(using: variables).isPending && brain.evaluate(using: variables).description != " "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Once we have something to show in the detail
        // view allow the default which is to show the
        // secondary in a collapsed split view
        
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let graphingViewController = destinationViewController as? GraphViewController, let identifier = segue.identifier {
            switch identifier {
            case "ShowGraphSurge":
                graphingViewController.title = brain.evaluate(using: variables).description
                graphingViewController.function = {
                    (x: CGFloat) -> Double in
                    let graphVariables = ["M" : Double(x)]
                    return self.brain.evaluate(using: graphVariables).result!
                }
            default:
                break
            }
        }
    }
    
    //keep track if secondaryviewcontroller has something to show
    
    //set masterviewcontroller as the delegate
}

