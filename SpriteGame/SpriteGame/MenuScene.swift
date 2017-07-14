//
//  MenuScene.swift
//  SpriteGame
//
//  Created by Kirsten Bauman on 11/14/16.
//  Copyright © 2016 Kirsten Bauman. All rights reserved.
//

import Cocoa
import SpriteKit

class MenuScene: SKScene {

    var contentsCreated = false
    var highScore = 0
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.blue
        scaleMode = .aspectFit
        if contentsCreated == false {
            createSceneContents()
            contentsCreated = true
        }
    }
    
    
    func createSceneContents() {
        let textNode = SKLabelNode(fontNamed: "Futura Condensed ExtraBold")
        textNode.text = "Subma-ring"
        textNode.fontSize = 48
        textNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        textNode.name = "HelloText"
        addChild(textNode)
        
        let highScoreNode = SKLabelNode(fontNamed: "Futura Medium")
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 50.0
        highScoreNode.position = CGPoint(x: size.width/2.0, y: 100)
        highScoreNode.name = "HighScore"
        addChild(highScoreNode)
    }
    
    func updateHighScore(value: Int) {
        if value > highScore {
            highScore = value
            if let node = childNode(withName: "HighScore") as! SKLabelNode? {
                node.text = "HighScore: \(highScore)"
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if let node = childNode(withName: "HelloText") {
            let moveUp = SKAction.moveBy(x: 0.0, y: 100.0, duration: 0.5)
            let zoom = SKAction.scale(to: 2.0, duration: 0.25)
            let sequence = SKAction.sequence([moveUp, zoom])
            
            node.run(sequence, completion: {
                let newScene = SubmarineScene(size: self.size)
                newScene.menuScene = self
                let doors = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(newScene, transition: doors)
            })
            
            
        }
    }

}
