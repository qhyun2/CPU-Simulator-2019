//
//  ViewController.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//
import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    
    @IBOutlet var skView: SKView!
    var memory = SKScene(fileNamed: "GameScene")!
    var alu = SKScene(fileNamed: "ALU")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
                // Set the scale mode to scale to fit the window
                memory.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(memory)
            
            let presOptions: NSApplication.PresentationOptions = ([.fullScreen,.autoHideMenuBar])
            /*These are all of the options for NSApplicationPresentationOptions
             .Default
             .AutoHideDock              |   /
             .AutoHideMenuBar           |   /
             .DisableForceQuit          |   /
             .DisableMenuBarTransparency|   /
             .FullScreen                |   /
             .HideDock                  |   /
             .HideMenuBar               |   /
             .DisableAppleMenu          |   /
             .DisableProcessSwitching   |   /
             .DisableSessionTermination |   /
             .DisableHideApplication    |   /
             .AutoHideToolbar
             .HideMenuBar               |   /
             .DisableAppleMenu          |   /
             .DisableProcessSwitching   |   /
             .DisableSessionTermination |   /
             .DisableHideApplication    |   /
             .AutoHideToolbar */
            
            let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions :
                presOptions.rawValue]
            
            view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
