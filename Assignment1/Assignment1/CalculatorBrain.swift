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
        "=" : Operation.equals
    ]
    
    mutating func performOperation (_ symbol: String){
        if let operation = operations[symbol]{
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
    }
    var result: Double?{
    get{
        return accumulator
    }
    }
}
