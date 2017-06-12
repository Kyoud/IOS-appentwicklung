//
//  GraphViewController.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 30.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController {

    
    func calculatepoints()->Array<Int>{
        var points = [Int]()
        for index in -10...10{
            points.append(2*index)
    }
        return points
    }
}
