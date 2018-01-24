//
//  ViewController.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.

/* Project Outline
 
 X Done
 - Todo
 
 Sprint 2:
 XCreate working memory display
 XDisplay when sections are accessed
 
 Sprint 3:
 XWrite Scene Controller
 
 
 Overall:

 
 Overview:
 XRepresent each scene connected together
 Xcomponent selection
 Xreturning from scenes
 
 Memory Scene:
 Xsplit up updateState function
 
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
    
    //main skscene
    var SceneController = SKScene(fileNamed: "SceneController")!

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
    
    //mouse tracking
    lazy var window: NSWindow = self.view.window!
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        // Set the scale mode to scale to fit the window
        let viewer = self.skView!
        SceneController.scaleMode = .aspectFit
        // Present the scene
        viewer.presentScene(SceneController)

        //mystery most of the time fullscreen works stuff
        let presOptions: NSApplication.PresentationOptions = ([])
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:
                presOptions.rawValue]
        viewer.enterFullScreenMode(NSScreen.main!, withOptions: optionsDictionary)
        viewer.showsFPS = true
        viewer.showsNodeCount = true

        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            //print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
            return $0
        }
    }
}
