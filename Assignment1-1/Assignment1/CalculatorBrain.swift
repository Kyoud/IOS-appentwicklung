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
    
    
    var description: String?
    var writeToSave = true
    
    private var save = [Saveoptions]()

    private enum Saveoptions{
        case operation(String)
        case operand(Double)
        case variable(String)
    }
    
    private enum Operation{
        case constant(Double)
        case uneryOperation((Double)-> Double , (String)->String)
        case binaryOperation((Double, Double)->Double, (String, String)->String)
        case equals
    }

    mutating func setVariable(_ named: String){
        setsave(Saveoptions.variable(named))
    }
    
    mutating func setOperand(_ operand: Double){
        setsave(Saveoptions.operand(operand))
        description = String (operand)
    }
    mutating func setOperation(_ operation: String){
        setsave(Saveoptions.operation(operation))
    }
    
    
    private mutating func setsave(_ option: Saveoptions){
        save.append(option)
    }
    
    mutating func undo()
        {
            if !save.isEmpty {
                save.removeLast()
            }
            
        }
    
    
    
    mutating func clear(){
        /*resultIsPending = false
        accumulator.0 = nil
        accumulator.1 = nil*/
        save.removeAll()
    }
    
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String)
    {

        var operations : [String:Operation] = [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "+" : Operation.binaryOperation(+, { $0 + " + " + $1}),
            "-" : Operation.binaryOperation(- ,{ $0 + " - " + $1}),
            "/" : Operation.binaryOperation(/, { $0 + "/" + $1}),
            "*" : Operation.binaryOperation(*, { $0 + " * " + $1}),
            "sin": Operation.uneryOperation(sin, {"sin(" + $0 + ")"}),
            "cos": Operation.uneryOperation(cos, {"cos(" + $0 + ")"}),
            "tan": Operation.uneryOperation(tan, {"tan(" + $0 + ")"}),
            "√": Operation.uneryOperation(sqrt, {"√(" + $0 + ")"}),
            "-X": Operation.uneryOperation(-,{"- " +  $0}),
            "X²": Operation.uneryOperation({$0 * $0},{ "( " + $0 + " )^2"}),
            "=" : Operation.equals
        ]
        
        var pendingBinaryOperation: PendingBinaryOperation?
        var accumulator: (Double?, String?)
        var resultIsPending = false
        
        var result: Double?{
            get{
                return accumulator.0
            }
        }
        
        func performOperation (_ symbol: String){
            
            if let operation = operations[symbol]{
                switch operation {
                case .constant(let value):
                    accumulator.0 = value
                    accumulator.1 = symbol
                    
                case .uneryOperation(let function, let description):
                    if accumulator.0 != nil{
                        accumulator.0 = function(accumulator.0!)
                        accumulator.1 = description(accumulator.1!)
                        }
                    
                case .binaryOperation(let function, let description):
                    if accumulator.0 != nil {
                        resultIsPending = true
                        pendingBinaryOperation = PendingBinaryOperation(function: function, description: description, firstOperand: (accumulator.0!,accumulator.1!))
                    }
                    
                case .equals:
                    if resultIsPending{
                        performPendingBinaryOperation()
                        resultIsPending = false
                        
                    }
                }
            }
        }
        
        func performPendingBinaryOperation(){
            if pendingBinaryOperation != nil && accumulator.0 != nil {
                let tmp = pendingBinaryOperation!.perform(with: (accumulator.0!,accumulator.1!))
                accumulator.0 = tmp.0
                accumulator.1 = tmp.1
                
                pendingBinaryOperation = nil
            }
        }
        
        
        
        struct PendingBinaryOperation {
            let function: (Double, Double)->Double
            let description: (String, String)->String
            let firstOperand: (Double, String)
            
            func perform(with secoundOperand: (Double,String))-> (Double,String){
                return (function(firstOperand.0, secoundOperand.0), description(firstOperand.1 , secoundOperand.1))
            }
        }
        if !save.isEmpty{
        for step in save{
            switch step{
            case .operand(let value):
                accumulator.0 = value
                accumulator.1 = String(value)
            case .operation(let value):
                performOperation(value)
            case.variable(let value):
                if variables?[value] != nil{
                    accumulator.0 = variables?[value]!
                    accumulator.1 = value//String(describing: variables?[value]!)
                }else{
                    accumulator.0 = 0
                    accumulator.1 = "M"
                }
                
                
            }
        }
        }else{
            accumulator.0 = 0
            accumulator.1 = ""
            resultIsPending = false
        }

        return(result: accumulator.0!, isPending: resultIsPending, description: accumulator.1!)
    }
 }
