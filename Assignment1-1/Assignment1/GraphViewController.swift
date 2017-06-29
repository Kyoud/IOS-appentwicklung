//
//  GraphViewController.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 30.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var graphingView: GraphView! {
        didSet {
            graphingView.dataSource = self
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphingView, action: #selector(GraphView.zoom(recognizer:)))
            graphingView.addGestureRecognizer(pinchRecognizer)
            let panRecognizer = UIPanGestureRecognizer(target: graphingView, action: #selector(GraphView.move(recognizer:)))
            graphingView.addGestureRecognizer(panRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: graphingView, action: #selector(GraphView.tap(recognizer:)))
            graphingView.addGestureRecognizer(tapRecognizer)
        }
    }
    func getBounds() -> CGRect {
        return navigationController?.view.bounds ?? view.bounds
    }
    
    func getYCoordinate(x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        return nil
    }
    
    var function: ((CGFloat) -> Double)?
    
}
