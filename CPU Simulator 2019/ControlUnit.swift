//
//  ControlUnit.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-11.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

var text: NSTextField = NSTextField()

class ControlUnit: Scene {

    var instructionArray: Array<Array<Int>> = [[]]
    var instructionPointer = 1 {
        didSet {
            instructionPointerLabel.text = "Current Line: \(instructionPointer)"
        }
    }
    var halt = false
    let runButton = SKShapeNode(rect: CGRect(x: 178, y: 650, width: 87, height: 31))
    let stopButton = SKShapeNode(rect: CGRect(x: 178, y: 610, width: 87, height: 31))
    let startLabel = SKLabelNode(text: "Run")
    let stopLabel = SKLabelNode(text: "Stop")
    let instructionPointerLabel = SKLabelNode(text: "Current Line: 1")

    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)

        runButton.fillColor = SKColor.cyan
        runButton.lineWidth = 3
        runButton.strokeColor = SKColor.black
        addNode(node: runButton)

        stopButton.fillColor = SKColor.cyan
        stopButton.lineWidth = 3
        stopButton.strokeColor = SKColor.black
        addNode(node: stopButton)

        stopLabel.fontName = "AmericanTypewriter-Bold"
        stopLabel.fontSize = 16
        stopLabel.fontColor = SKColor.black
        stopLabel.position = CGPoint(x: 221, y: 620)
        addNode(node: stopLabel)

        startLabel.fontName = "AmericanTypewriter-Bold"
        startLabel.fontSize = 16
        startLabel.fontColor = SKColor.black
        startLabel.position = CGPoint(x: 221, y: 660)
        addNode(node: startLabel)

        instructionPointerLabel.fontName = "AmericanTypewriter-Bold"
        instructionPointerLabel.fontSize = 20
        instructionPointerLabel.fontColor = SKColor.green
        instructionPointerLabel.position = CGPoint(x: 90, y: 609)
        addNode(node: instructionPointerLabel)

        for i in 1...40 {
            let lineLabels = SKLabelNode()
            lineLabels.text = String(i)
            lineLabels.fontSize = 16
            lineLabels.fontName = "AmericanTypewriter-Bold"
            lineLabels.fontColor = SKColor.green
            let offset = Int(14.1 * Float(i - 1))
            lineLabels.position = CGPoint(x: 148, y: 583 - offset)
            lineLabels.zPosition = 10
            addNode(node: lineLabels)
        }
    }


    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            loadFromMemory(address: data[0], reg: data[1])
            break
        case 2:
            saveToMemory(address: data[0])
            break
        case 3:
            //jump command
            instructionPointer = data[0]
            break
        case 4:
            //jump if command
            instructionPointer = zeroFlag ? data[0] : data[1]
            break
        case 5:
            //long supply chain for text input (part 4)
            parseCode(code: controller.codeIn)
            break
        case 6:
            //trigger next line of code, (attached onto the end of all instructions)
            if !halt {
                
                //prevents alot of index out of range crashes
                if instructionArray.count > instructionPointer {
                    
                    var toExe = instructionArray[instructionPointer]
                    let instructionId = toExe.removeFirst()
                    let instruction = Event(delay: 500, id: instructionId, scene: self, data: toExe)
                    let start = Event(delay: 500, id: 6, scene: self)

                    controller.eventQ?.addEvent(event: instruction)
                    controller.eventQ?.addEvent(event: start)

                    if !(instructionId == 3 || instructionId == 4) {
                        instructionPointer += 1
                    }
                }
            }

        default:
            print("Control Unit Event Error")
        }
    }

    var lines: Array<String> = []

    func parseCode(code: String) {

        //each element of array is one line of code
        let codeLines = code.components(separatedBy: CharacterSet.newlines)

        for i in codeLines {

            //seperate each line into its componets as seperated by spaces
            var lineParts = i.components(separatedBy: CharacterSet.whitespaces)
            var instructionId = 0

            switch(lineParts[0]) {
            case "load":
                instructionId = 1
                break
            case "save":
                instructionId = 2
                break
            case "jump":
                instructionId = 3
                break
            case "jumpif":
                instructionId = 4
                break
            default:
                instructionId = -1
            }
            var instruction = [instructionId]
            lineParts.removeFirst()

            for i in lineParts {
                instruction.append(Int(i)!)
            }
            instructionArray.append(instruction)
        }

        print(instructionArray)
    }


    func loadFromMemory(address: Int, reg: Int) {

        let memory = controller.memory!
        let alu = controller.alu!

        let setAdd = Event(delay: 500, id: 4, scene: memory, data: [address])
        let readMem = Event(delay: 500, id: 2, scene: memory, data: [1])
        let writeALU = Event(delay: 500, id: reg, scene: alu, data: [1])
        let writeALUo = Event(delay: 500, id: reg, scene: alu, data: [0])
        let readMemo = Event(delay: 500, id: 2, scene: memory, data: [0])

        controller.eventQ?.addEvent(event: setAdd)
        controller.eventQ?.addEvent(event: readMem)
        controller.eventQ?.addEvent(event: writeALU)
        controller.eventQ?.addEvent(event: writeALUo)
        controller.eventQ?.addEvent(event: readMemo)
    }

    func saveToMemory(address: Int) {

        let memory = controller.memory!
        let alu = controller.alu!

        let setAdd = Event(delay: 500, id: 4, scene: memory, data: [address])
        let readALU = Event(delay: 500, id: 3, scene: alu, data: [1])
        let writeMem = Event(delay: 500, id: 1, scene: memory, data: [1])
        let writeMemo = Event(delay: 500, id: 1, scene: memory, data: [0])
        let readALUo = Event(delay: 500, id: 3, scene: alu, data: [0])

        controller.eventQ?.addEvent(event: setAdd)
        controller.eventQ?.addEvent(event: readALU)
        controller.eventQ?.addEvent(event: writeMem)
        controller.eventQ?.addEvent(event: writeMemo)
        controller.eventQ?.addEvent(event: readALUo)

    }

    override func mouseDown(event: NSEvent) {
        super.mouseDown(event: event)

        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let point = CGPoint(x: x, y: y)

        if runButton.contains(point) {
            halt = false
            instructionPointer = 1
            let start = Event(delay: 0, id: 6, scene: self)
            controller.eventQ?.addEvent(event: start)
        }

        if stopButton.contains(point) {
            halt = true
        }
    }
}


