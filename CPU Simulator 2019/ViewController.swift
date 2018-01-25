//
//  ViewController.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.

/* Project Outline TODO
 
 X -> Done
 - -> Todo
 
 Sprint 2:
 XCreate working memory display
 XDisplay when sections are accessed
 
 Sprint 3:
 XWrite Scene Controller
 -Finish Everything
 
Overall:
     Overview:
         XRepresent each scene connected together
         Xcomponent selection
         Xreturning from scenes
         -ALU control lines
     Memory Scene:
         Xsplit up updateState function
         -Click memory editing
     ALU:
         XInput and Result registers
         XOp Codes
         -Flags
     Control Unit:
         XIntruction id input
         XIntruction representation
         Xintruction execution
 */

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var textField: NSTextView!
    @IBOutlet var skView: SKView!
    @IBOutlet weak var textWindow: NSScrollView!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var submitButton: NSButton!
    @IBOutlet weak var codeSelector: NSPopUpButton!
    @IBOutlet weak var picker: NSPopUpButton!

    //main skscene
    var SceneController = SKScene(fileNamed: "SceneController")!

    override func viewDidLoad() {

        super.viewDidLoad()
        // Set the scale mode to scale to fit the window
        let viewer = self.skView!
        // Present the scene
        SceneController.scaleMode = .aspectFit
        viewer.presentScene(SceneController)
    }

    //user inputed text into
    @IBAction func preformedClick(_ sender: AnyObject) {
        textInput = textField.string
        updated = true
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
        textWindow.isHidden = !textWindow.isHidden
        codeSelector.isHidden = !codeSelector.isHidden
        submitButton.isHidden = !submitButton.isHidden

        button.title = textWindow.isHidden ? "Show Code" : "Hide Code"
    }

    @IBAction func selected(_ sender: Any) {
        switch(picker.index(of: picker.selectedItem!)) {
        case 0:
            textField.string = ""
            break
        case 1:
            textField.string =
                """
            load 0 1
            load 1 2
            save 0
            jump 1
            """
            break
        case 2:
            textField.string =
                """
            load 0 1
            load 1 2
            save 2
            """
            break
        case 4:
            textField.string =
                """
            load 0 1
            load 1 2
            save 0
            load 0 1
            load 1 2
            save 1
            jump 1
            """
            break
        case 3:
            textField.string =
                """
            jump 6
            jump 11
            jump 1
            jump 10
            jump 2
            jump 4
            jump 9
            jump 12
            jump 3
            jump 13
            jump 7
            jump 5
            jump 8
            """
            break
        default:
            print("Preloaded Code Selector Error")
        }
    }
}
