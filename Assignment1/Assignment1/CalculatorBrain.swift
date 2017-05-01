//
//  CalculatorBrain.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 01.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import UIKit
import Darwin


struct CalculatorBrain {
    
    var resultIsPending = false
    var description: String = "..."
    
    private var accumulator: Double?
    
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
                accumulator = value
                resultIsPending = true
                description = description.replacingOccurrences(of: "...", with:String(symbol))
            case .uneryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                    resultIsPending = false
                    history(symbol)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    resultIsPending = true
                    history(symbol)
                }
                
            case .equals:
                if resultIsPending{
                performPendingBinaryOperation()
                description = description + "="
                }
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
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
        accumulator = operand
        description = description.replacingOccurrences(of: "...", with:String(operand))
        
        
        
    }
    var result: Double?{
    get{
        return accumulator
    }
    }
    mutating func history(_ anhang: String){
        description = description.replacingOccurrences(of: "=", with: "")
        if (resultIsPending){
        description = description + anhang + " ..."
        }else
        {
            description = anhang + "("+description+")"
        }
    }
}
