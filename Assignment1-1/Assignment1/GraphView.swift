//
//  GraphView.swift
//  Assignment1
//
//  Created by Jan Niklas Hollenbeck on 30.05.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import Foundation
import UIKit

protocol GraphViewDataSource {
    func getBounds() -> CGRect
    func getYCoordinate(x: CGFloat) -> CGFloat?
}
@IBDesignable
class GraphView: UIView {
    @IBInspectable
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = CGFloat(50.0) { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    var dataSource: GraphViewDataSource?
    private let drawer = AxesDrawer(color: UIColor.blue)
    
    private func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        if let data = dataSource {
            var pathIsEmpty = true
            var point = CGPoint()
            
            let width = Int(bounds.size.width * scale)
            for pixel in 0...width {
                point.x = CGFloat(pixel) / scale
                
                if let y = data.getYCoordinate(x: (point.x - origin.x) / scale) {
                    
                    if !y.isNormal && !y.isZero {
                        pathIsEmpty = true
                        continue
                    }
                    
                    point.y = origin.y - y * scale
                    
                    if pathIsEmpty {
                        path.move(to: point)
                        pathIsEmpty = false
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            
            path.lineWidth = lineWidth
            return path
        } else {
            print("There is no dataSource!")
            return path
        }

    }
    override func draw(_ rect: CGRect) {
        
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        
        color.set()
        pathForFunction().stroke()
        
        drawer.drawAxes(in: dataSource?.getBounds() ?? bounds, origin: origin, pointsPerUnit: scale)
    }
    
    func tap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            origin = recognizer.location(in: self)
        }
    }
    
    func zoom(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    func move(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed: fallthrough
        case .ended:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint(x: 0,y :0), in: self)
        default: break
        }
    }
}
