//
//  Bus.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-12.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit

class Bus {

    var value = 0 {
        didSet {
            updateDisplay()
        }
    }
    var bits: Int
    var lines: Array<SKShapeNode> = []
    var label = SKLabelNode()

    init(x: Int, y: Int, width: Int, height: Int, bits: Int, spacing: Float, scene: Scene) {

        let cellWidth = width / bits
        self.bits = bits

        for i in 0..<bits {

            //determine how far along line the cell is x
            let offsetX = (i * cellWidth) + x

            //create position object
            let position = CGPoint.init(x: offsetX, y: y)

            //create cell
            let cell = SKShapeNode.init(rectOf: CGSize.init(width: Int(Float(cellWidth) * spacing), height: height))
            cell.position = position
            cell.lineWidth = 4
            cell.zPosition = 5
            cell.fillColor = SKColor.gray
            cell.strokeColor = SKColor.black
            lines.append(cell)
            scene.addNode(node: cell)
        }
    }

    func enableLabel(x: Int, y: Int, fontSize: Int, scene: Scene) {
        label.position = CGPoint(x: x, y: y)
        label.fontName = "AmericanTypewriter-Bold"
        label.fontSize = CGFloat(fontSize)
        label.fontColor = SKColor.orange
        label.text = "0"
        label.zPosition = 15
        scene.addNode(node: label)
    }

    func updateDisplay() {
        
        //update label
        label.text = "\(value)"
        
        let unpaddedBinary = String(value, radix: 2) //binary base
        let padding = String.init(repeating: "0", count: (bits - unpaddedBinary.count))
        let binary = Array(padding + unpaddedBinary)

        //update each individual cell
        for (index, i) in lines.enumerated() {

            //determine color based on binary value
            if(binary[index] == "1") {
                i.fillColor = SKColor.blue
            } else {
                i.fillColor = SKColor.gray
            }
        }
    }
}



