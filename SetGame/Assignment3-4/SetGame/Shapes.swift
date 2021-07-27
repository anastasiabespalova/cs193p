//
//  Shapes.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 20.07.2021.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
               // get the center of the rect
               let center = CGPoint(x: rect.midX, y: rect.midY)
               // get the starting of our drawing the right side of our diamond
               let startingPoint = CGPoint(x: rect.maxX, y: center.y)
               // move our start of drawing to the beggining point
               path.move(to: startingPoint)
               // distance / 2 is our height
               // create all our points
       // let secondPoint = CGPoint(x: center.x, y: center.y + rect.maxX/6)
        let secondPoint = CGPoint(x: center.x, y: rect.maxY)
               let thirdPoint = CGPoint(x: rect.minX , y: center.y)
               //let fourthPoint = CGPoint(x: center.x, y: center.y - rect.maxX/6)
        let fourthPoint = CGPoint(x: center.x, y: rect.minY)
               path.addLine(to: secondPoint)
               path.addLine(to: thirdPoint)
               path.addLine(to: fourthPoint)
               path.addLine(to: startingPoint)
               return path
    }
}

struct StripedRect: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var startingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        var secondPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let steps = 8
        
        for index in 0..<steps {
            startingPoint = CGPoint(x: rect.maxX - CGFloat(index) * rect.maxX/CGFloat(steps), y: rect.maxY)
            secondPoint = CGPoint(x: rect.maxX - CGFloat(index) * rect.maxX/CGFloat(steps), y: rect.minY)
            path.move(to: startingPoint)
            path.addLine(to: secondPoint)
            
        }
        return path
    }
    
    
}

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height)/2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
    
    
    
}

struct SquiggleShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
                
        path.move(to: CGPoint(x: 104.0, y: 15.0))
        path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                      control1: CGPoint(x: 112.4, y: 36.9),
                      control2: CGPoint(x: 89.7, y: 60.8))
        path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                      control1: CGPoint(x: 52.3, y: 51.3),
                      control2: CGPoint(x: 42.2, y: 42.0))
        path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                      control1: CGPoint(x: 9.6, y: 65.6),
                      control2: CGPoint(x: 5.4, y: 58.3))
        path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                      control1: CGPoint(x: 4.6, y: 22.0),
                      control2: CGPoint(x: 19.1, y: 9.7))
        path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                      control1: CGPoint(x: 59.2, y: 15.2),
                      control2: CGPoint(x: 61.9, y: 31.5))
        path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                      control1: CGPoint(x: 95.3, y: 10.0),
                      control2: CGPoint(x: 100.9, y: 6.9))
        
        let pathRect = path.boundingRect
        path = path.offsetBy(dx: rect.minX - pathRect.minX, dy: rect.minY - pathRect.minY)
        
        let scale: CGFloat = rect.width / pathRect.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path = path.applying(transform)
        
        
        return path
            .offsetBy(dx: rect.minX - path.boundingRect.minX, dy: rect.midY - path.boundingRect.midY)
    }
}
