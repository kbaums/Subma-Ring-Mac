//
//  ViewController.swift
//  SpriteGame
//
//  Created by Kirsten Bauman on 11/14/16.
//  Copyright © 2016 Kirsten Bauman. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let spriteView = view as! SKView
        
        if view.window == nil {
            print("no window yet")
        }
        else {
            print("YES! we have a window.")
            
        }
        
        if let visibleFrame = view.window?.screen?.visibleFrame {
            let newFrame = NSRect(x: visibleFrame.origin.x, y: visibleFrame.origin.y, width: visibleFrame.width, height: visibleFrame.height)
            view.window?.setFrame(newFrame, display: true)
        }
        
        let hello = MenuScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        
        spriteView.presentScene(hello)
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

