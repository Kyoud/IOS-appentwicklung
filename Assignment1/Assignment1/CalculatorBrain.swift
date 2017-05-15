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
    private var save:[(operand: Double, operation: String)] = []

    private var writeToSave = true
    private var accumulator: (Double?, String?)
    
    private enum Operation{
        case constant(Double)
        case uneryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double)
        case equals
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
                    setsave(symbol)
                }
            case .binaryOperation(let function):
                if accumulator.0 != nil {
                    if resultIsPending{
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!)
                        description = description! + " " + symbol
                        setsave(symbol)
                        resultIsPending = false
                    }else{
                    resultIsPending = true
                    description = description! + " " + symbol
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!)
                    setsave(symbol)
                    accumulator.0 = nil
                    accumulator.1 = ""
                    }
                }
                
            case .equals:
                if resultIsPending{
                    performPendingBinaryOperation()
                    resultIsPending = false
                    setsave(symbol)
                    
                    
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

    }
    var result: Double?{
    get{
        return accumulator.0
    }
    }
    private mutating func setsave(_ symbol: String){
        if writeToSave{
        save += [(operand: accumulator.0!, operation: symbol)]
        }
    }
    
    mutating func undo(){
        save.removeLast()
        description=nil
        writeToSave = false
        for step in save{
            setOperand(step.operand)
            performOperation(step.operation)
        }
        writeToSave = true
    }
    mutating func clear(){
        description = nil
        resultIsPending = false
        save.removeAll()
    }
}
