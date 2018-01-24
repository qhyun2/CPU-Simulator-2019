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

//ADD PAUSE STEP AND CONTINUE BUTTONS

class ControlUnit: Scene {

    var instructionArray: Array<Array<Int>> = [[]]
    var instructionPointer = 1 {
        didSet {
            instructionPointerLabel.text = "Current Line: \(instructionPointer)"
            indicatorArrow.position = CGPoint(x: 96, y: 589 - Int((Double((instructionPointer - 1)) * 14.1)))
        }
    }

    var halt = false
    let instructionPointerLabel = SKLabelNode(text: "Current Line: 1")
    var indicatorArrow = SKSpriteNode(imageNamed: "arrow")

    var buttons: Array<Button> = []

    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)

        indicatorArrow.position = CGPoint(x: 96, y: 589)
        addNode(node: indicatorArrow)

        let runRect = CGRect(x: 178, y: 700, width: 90, height: 30)
        let stopRect = CGRect(x: 178, y: 660, width: 90, height: 30)
        let stepRect = CGRect(x: 178, y: 620, width: 90, height: 30)

        let runButton = Button(rect: runRect, text: "Start", scene: self, event: Event(delay: 0, id: 7, scene: self))
        let stopButton = Button(rect: stopRect, text: "Pause", scene: self, event: Event(delay: 0, id: 8, scene: self))
        let stepButton = Button(rect: stepRect, text: "Step", scene: self, event: Event(delay: 0, id: 9, scene: self))

        buttons.append(runButton)
        buttons.append(stopButton)
        buttons.append(stepButton)

        instructionPointerLabel.fontName = "AmericanTypewriter-Bold"
        instructionPointerLabel.fontSize = 20
        instructionPointerLabel.fontColor = SKColor.green
        instructionPointerLabel.position = CGPoint(x: 90, y: 620)
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
            //prevents alot of index out of range crashes
            if instructionArray.count > instructionPointer {

                var toExe = instructionArray[instructionPointer]
                let instructionId = toExe.removeFirst()
                let instruction = Event(delay: 500, id: instructionId, scene: self, data: toExe)
                controller.eventQ?.addEvent(event: instruction)

                if !halt {
                    //hook into next instruction if not halted
                    let start = Event(delay: 500, id: 6, scene: self)
                    controller.eventQ?.addEvent(event: start)
                }

                //increment instruction pointer by 1 if not a jump command
                if !(instructionId == 3 || instructionId == 4) {
                    instructionPointer += 1
                }
            }
        case 7:
            halt = false
            instructionPointer = 1
            let start = Event(delay: 0, id: 6, scene: self)
            controller.eventQ?.addEvent(event: start)
            break
        case 8:
            //stop program execution
            halt = true
            break
        case 9:
            //exe one instruction, same as event 6 but no hook into next instruction
            if instructionArray.count > instructionPointer {

                var toExe = instructionArray[instructionPointer]
                let instructionId = toExe.removeFirst()
                let instruction = Event(delay: 0, id: instructionId, scene: self, data: toExe)
                controller.eventQ?.addEvent(event: instruction)

                //increment instruction pointer by 1 if not a jump command
                if !(instructionId == 3 || instructionId == 4) {
                    instructionPointer += 1
                }
            }
        default:
            print("Control Unit Event Error")
        }
    }

    var lines: Array<String> = []

    func parseCode(code: String) {

        //clear instruction array for a clean slate
        instructionArray = [[]]

        //each element of array is one line of code
        let codeLines = code.components(separatedBy: CharacterSet.newlines)

        for i in codeLines {

            //seperate each line into its componets as seperated by spaces
            var lineParts = i.components(separatedBy: CharacterSet.whitespaces)
            var instructionId = 0

            //decode keywords into ids
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
            case "input":
                instructionId = 5
                break
            case "display":
                instructionId = 6
                break
            default:
                instructionId = -1
            }

            var instruction = [instructionId]

            //taken any extra arguments and convert to ints and add on
            lineParts.removeFirst()
            for i in lineParts {
                instruction.append(Int(i) ?? -1)
            }
            instructionArray.append(instruction)
        }
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

        for i in buttons {
            i.update(point: point)
        }
    }
}


