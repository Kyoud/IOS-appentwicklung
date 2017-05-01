//
//  CalculatorBrain.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 01.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import UIKit
import Darwin


class CalculatorBrain: NSObject {
    var operand = 0
    
    var mathsimbols : [String:Double] = [
        "π" : Double.pi,
        "e" : M_E,
        "+" : (operand + )
    ]
}
