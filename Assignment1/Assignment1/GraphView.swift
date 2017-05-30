//
//  GraphView.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 30.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import Foundation
import UIKit

class GraphView: UIView {
    var graph = AxesDrawer()
    let rect = CGRect.init()
    let point = CGPoint.init(x: 200, y: 400)
    
    
    override func draw(_ rect: CGRect) {
        graph.drawAxes(in: rect, origin: point, pointsPerUnit: 50)
    }
}
