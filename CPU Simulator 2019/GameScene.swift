//
//  GameScene.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//


/* Project Outline
 
 Sprint 2:
 -Create working memory display
 -Display when sections are accessed
 
 Sprint 3:
 -Finish everything else

*/
import SpriteKit
import GameplayKit
import Cocoa

class GameScene: SKScene {

    //variables for testing


    //constant "settings"
    var dataSize = 16
    var storageSize = 32
    var row = 0
    var col = 0
    var screenWidth = Float()
    var screenHeight = Float()
    var CGwidth = CGFloat()
    var width = Float()
    var unitWidth = Float()
    var unitHeight = Float()
    var centerX = Float()
    var centerY = Float()
    var memoryX = Float()
    var memoryY = Float()
    var memoryTop = CGFloat()
    var busWidth = CGFloat()
    var busHeight = CGFloat()

    //objects in scene
    private var background = SKSpriteNode(imageNamed: "memory background")
    private var memory: Array<SKShapeNode> = Array()
    private var accessIndicator = SKShapeNode()
    private var writeIndicator = SKShapeNode()
    private var addressBus: Array<SKShapeNode> = Array()
    private var dataBus: Array<SKShapeNode> = Array()

    //other variables
    private var memoryValue: Array<Int> = Array(repeating: 0, count: 32)

    // init the game scene
    override func didMove(to view: SKView) {

        row = 16
        col = 32
        screenWidth = Float(self.size.width)
        screenHeight = Float(self.size.height)
        CGwidth = (self.size.width + self.size.height) * 0.017
        width = Float(CGwidth)
        unitWidth = width * Float(col)
        unitHeight = width * Float(row)
        centerX = Float(self.size.width / 2)
        centerY = Float(self.size.height / 2)
        memoryX = screenWidth * 0.04
        memoryY = screenHeight * 0.05
        memoryTop = CGFloat(memoryY + unitHeight / 2 - 14)
        busWidth = CGFloat(screenWidth * 0.05)
        busHeight = CGFloat(screenHeight * 0.1)

        //background
        background.size = CGSize(width: CGFloat(screenWidth), height: CGFloat(screenHeight))
        background.zPosition = -99
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        self.addChild(background)
        
        //address bus
        for i in 0...7 {
            
            let offsetX = CGFloat(Float(i) * width + memoryX)
            let position = CGPoint.init(x: offsetX, y: CGFloat(memoryY + unitHeight))
            
            let addressLabel = SKLabelNode(text: String(i))
            addressLabel.position = position
            addressLabel.fontName = "AmericanTypewriter-Bold"
            addressLabel.fontSize = 20
            addressLabel.fontColor = SKColor.orange
            
            self.addChild(addressLabel)
        }
        
        //data bus

        //memory labels 0 - 31
        for i in 0..<col {

            let offsetX = CGFloat(Float(i) * width + memoryX)
            let position = CGPoint.init(x: offsetX, y: CGFloat(memoryY + unitHeight))

            let addressLabel = SKLabelNode(text: String(i))
            addressLabel.position = position
            addressLabel.fontName = "AmericanTypewriter-Bold"
            addressLabel.fontSize = 20
            addressLabel.fontColor = SKColor.orange

            self.addChild(addressLabel)
        }

        //background box
        let memoryBackground = SKShapeNode.init(rectOf: CGSize.init(width: CGFloat(screenWidth * 0.85   ), height: CGFloat(screenWidth * 0.46)))
        memoryBackground.position.x = CGFloat(centerX - 76)
        memoryBackground.position.y = CGFloat(memoryY + unitHeight / 2)
        memoryBackground.fillColor = SKColor.init(white: 0, alpha: 0.65)
        memoryBackground.lineWidth = 4
        memoryBackground.strokeColor = SKColor.blue
        self.addChild(memoryBackground)

        //access indicator
        accessIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight + 15)))
        accessIndicator.fillColor = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 0.4)
        accessIndicator.zPosition = 2
        self.addChild(accessIndicator)

        //write indicator
        writeIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight + 15)))
        writeIndicator.fillColor = SKColor.init(red: 0.0196, green: 0.6862, blue: 0.2274, alpha: 0.4)
        writeIndicator.zPosition = 3
        self.addChild(writeIndicator)

        //memory cell bank
        for i in 0..<col {
            for j in 0..<row {

                //determine positions and size
                let offsetX = CGFloat(Float(i) * width + memoryX)
                let offsetY = CGFloat(Float(j) * width + memoryY)
                let cellWidth = CGFloat(CGwidth * 0.45)
                let cellHeight = CGFloat(CGwidth * 0.8)

                //create position object
                let position = CGPoint.init(x: offsetX, y: offsetY)

                //create cell
                let cell = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight), cornerRadius: 0)
                cell.position = position
                cell.lineWidth = 2
                cell.fillColor = SKColor.gray
                cell.lineWidth = 2
                cell.strokeColor = SKColor.black


                //add to array and scene
                memory.append(cell)
                self.addChild(cell)
            }
        }
    }

    func accessMemory(address: Int) -> Int {

        //handle invalid addresses
        if address < 0 || address * dataSize >= memory.count {
            print("Address \(address) is out of range")
            return 0
        }
        //update read indicator
        accessIndicator.position = CGPoint.init(x: CGFloat(memoryX + Float(address) * width), y: memoryTop)

        return memoryValue[address]
    }


    //updated given memory location with given data
    func updateMemory(address: Int, data: Int) -> Bool {

        //handle invalid addresses
        if address < 0 || address * dataSize >= memory.count {
            print("Address \(address) is out of range")
            return false
        }

        //update write indicator
        writeIndicator.position = CGPoint.init(x: CGFloat(memoryX + Float(address) * width), y: memoryTop)

        //update value
        memoryValue[address] = data

        //determine first cell of the set to be modified
        let firstCell = dataSize * address

        //binary visual representation
        let unpaddedBinary = String(data, radix: 2) //binary base
        let padding = String.init(repeating: "0", count: (dataSize - unpaddedBinary.count))
        let binary = Array(padding + unpaddedBinary)

        //update each individual cell
        for i in 0..<dataSize {

            //determine color based on binary value
            if(binary[i] == "1" || binary[i] == "-") {
                memory[firstCell + i].fillColor = SKColor.blue
            } else {
                memory[firstCell + i].fillColor = SKColor.gray
            }
        }

        return false
    }

    //mouse clicked
    override func mouseDown(with event: NSEvent) {

        print(event.location(in: self))
    }

    //mouse dragged
    override func mouseDragged(with event: NSEvent) {

    }

    //mouse released
    override func mouseUp(with event: NSEvent) {

    }

    //keyboard pressed
    override func keyDown(with event: NSEvent) {
//        switch event.keyCode {
//        case 0x31:
//
//        default:
//            //print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
//        }
    }


    override func update(_ currentTime: TimeInterval) {

        //random values put in random locations to simulate write operations
        let randomInt = Int(arc4random_uniform(65536)) - 32768
        updateMemory(address: Int(arc4random_uniform(31)), data: randomInt)
        accessMemory(address: Int(arc4random_uniform(31)))
        sleep(1)
    }
}

