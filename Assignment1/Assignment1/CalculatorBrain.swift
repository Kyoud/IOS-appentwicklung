 //
 //  CalculatorBrain.swift
 //  Assignment1
 //
 //  Created by Jan Niklas Hollenbeck on 01.05.17.
 //  Copyright © 2017 h-da. All rights reserved.
 //
 
 import UIKit
 import Darwin
 import Foundation
 
 struct CalculatorBrain {
    
    var resultIsPending = false
    var description: String?
    
    private var save:[(operand: String, operation: Bool)] = []
    
    private var writeToSave = true
    private var accumulator: (Double?, String?)
    
    private enum Operation{
        case constant(Double)
        case uneryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double)
        case equals
    }
    var result: Double?{
        get{
            return accumulator.0
        }
    }
    
    private var operations : [String:Operation] = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "+" : Operation.binaryOperation({ $0 + $1}),
        "-" : Operation.binaryOperation({ $0 - $1}),
        "/" : Operation.binaryOperation({ $0 / $1}),
        "*" : Operation.binaryOperation({ $0 * $1}),
        "sin": Operation.uneryOperation({ sin($0 * Double.pi / 180)}),
        "cos": Operation.uneryOperation({ cos($0 * Double.pi / 180)}),
        "tan": Operation.uneryOperation({ tan($0 * Double.pi / 180)}),
        "√": Operation.uneryOperation({sqrt($0)}),
        "-X": Operation.uneryOperation({ -($0)}),
        "X²": Operation.uneryOperation({$0 * $0}),
        "=" : Operation.equals
    ]
    
    mutating func setOperand(variable named: String){
        setsave(named, is: false)
        if description != nil{
            description = description! + " " + named
        }else {
            description = named
        }
    }
    
    mutating func performOperation (_ symbol: String){
        
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator.0 = value
                if description != nil{
                    description = description! + symbol
                }else{
                    description = symbol
                }
                
            case .uneryOperation(let function):
                if accumulator.0 != nil{
                    accumulator.0 = function(accumulator.0!)
                    if resultIsPending{
                        description = description! + symbol + "(" + accumulator.1! + ")"
                    }else{
                        description = symbol + "(" + description! + ")"
                    }
                    setsave(symbol, is: true)
                }
            case .binaryOperation(let function):
                if accumulator.0 != nil {
                   /* if resultIsPending{
                        setsave(symbol, is: true)
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!)
                        description = description! + " " + symbol
                        resultIsPending = false
                    }else{*/
                        resultIsPending = true
                        description = description! + " " + symbol
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!)
                        setsave(symbol, is: true)
                        accumulator.0 = nil
                        accumulator.1 = ""
                    //}
                }
                
            case .equals:
                if resultIsPending{
                    setsave(symbol, is: true)
                    performPendingBinaryOperation()
                    resultIsPending = false
                    
                }
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator.0 != nil {
            accumulator.0 = pendingBinaryOperation!.perform(with: accumulator.0!)
            accumulator.1 = String(accumulator.0!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double)-> Double
        let firstOperand: Double
        
        func perform(with secoundOperand: Double)-> Double{
            return function(firstOperand, secoundOperand)
        }
    }
    mutating func setOperand(_ operand: Double){
        accumulator.0 = operand
        accumulator.1 = String(operand)
        if description != nil{
            description = description! + " " + accumulator.1!
        }else {
            description = accumulator.1
        }
        setsave(String(operand), is: false)
        
    }
    
    private mutating func setsave(_ symbol: String, is op: Bool){
        if writeToSave{
            save += [(operand: symbol, operation: op)]
        }
    }
    
    mutating func undo(){
        if save.count > 1 {
            save.removeLast()

            description=nil
            writeToSave = false
            for step in save{
                if step.operation{
                    performOperation(step.operand)
                }else{
                    setOperand(Double(step.operand)!)
                }
            }
            /*if save.last?.operation == false{
                setOperand(Double ((save.popLast()?.operand)!)!)
                save.removeLast()
            }*/
            writeToSave = true
        }else{
            clear()
        }
    }
    
    
    mutating func clear(){
        description = nil
        resultIsPending = false
        accumulator.0 = nil
        accumulator.1 = nil
        save.removeAll()
    }
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String)
    {
    }
    
 }
