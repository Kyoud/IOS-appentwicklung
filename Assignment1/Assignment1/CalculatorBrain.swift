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
    var description: String?
    
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
        "!": Operation.uneryOperation({ floor($0)}),
        "X²": Operation.uneryOperation({$0 * $0}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation (_ symbol: String){
        if let operation = operations[symbol]{
            description = description! + " " + symbol
            switch operation {
            case .constant(let value):
                accumulator = value
            case .uneryOperation(let function):
                if accumulator != nil{
                accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            resultIsPending = false
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
        description = String(operand)
        resultIsPending = true
    }
    var result: Double?{
    get{
        return accumulator
    }
    }
}
