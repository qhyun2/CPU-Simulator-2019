//
//  HorizontalBus.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-19.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit

class HorizontalBus {

    var value = 0 {
        didSet {
            updateDisplay()
        }
    }
    var bits: Int
    var lines: Array<SKShapeNode> = []
    var label = SKLabelNode()
    var activeColour = SKColor.blue

    init(x: Int, y: Int, width: Int, height: Int, bits: Int, spacing: Float, scene: Scene) {

        let cellHeight = height / bits
        self.bits = bits

        for i in 0..<bits {


            //determine how far along line the cell is x
            let offsetY = (i * cellHeight) + y

            //create position object
            let position = CGPoint.init(x: x, y: offsetY)

            //update cell
            let cell = SKShapeNode.init(rectOf: CGSize.init(width: width, height: Int(Float(cellHeight) * spacing)))
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

        if value < 65536 {
            let unpaddedBinary = String(value, radix: 2) //binary base
            let padding = String.init(repeating: "0", count: (bits - unpaddedBinary.count))
            let binary = Array(padding + unpaddedBinary)
            //update each individual cell
            for (index, i) in lines.enumerated() {

                //determine color based on binary value
                if(binary[index] == "1") {
                    i.fillColor = activeColour
                } else {
                    i.fillColor = SKColor.gray
                }
            }
        } else {
            for i in lines {
                i.fillColor = SKColor.red
            }
        }
    }
}



