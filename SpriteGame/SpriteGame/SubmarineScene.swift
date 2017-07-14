//
//  SubmarineScene.swift
//  SpriteGame
//
//  Created by Kirsten Bauman on 11/14/16.
//  Copyright © 2016 Kirsten Bauman. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class SubmarineScene: SKScene, SKPhysicsContactDelegate {
    var contentCreated = false
    var randomSource = GKLinearCongruentialRandomSource.sharedRandom()
    var points = 0
    var menuScene: MenuScene? = nil
    let hitSound = SKAction.playSoundFileNamed("smw_coin.wav", waitForCompletion: false)
    var selected: SKNode?
    
    override func didMove(to view: SKView) {
        if contentCreated == false {
            createSceneContents()
            contentCreated = true
        }
    }
    
    func createSceneContents() {
        backgroundColor = SKColor(calibratedRed: 0.4, green: 0.55, blue: 0.7, alpha: 1.0)
        scaleMode = .aspectFit
        
        createSub()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.3)
        
        createBoundaries()
        
        let makeRing = SKAction.sequence([
            SKAction.perform(#selector(SubmarineScene.addRing), onTarget: self),
            SKAction.wait(forDuration: 4.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeRing))
        
        let scoreNode = SKLabelNode(fontNamed: "Bauhaus 93")
        scoreNode.text = "0"
        scoreNode.fontSize = 96.0
        scoreNode.position = CGPoint(x: 20.0, y: size.height - 120.0)
        scoreNode.zPosition = 20.0
        scoreNode.name = "Score"
        scoreNode.horizontalAlignmentMode = .left
        addChild(scoreNode)
    }
    
    func addPoints(value: Int) {
        points += value
        if let score = childNode(withName: "Score") as! SKLabelNode?{
            score.text = "\(points)"
        }
    }
    
    func createBoundaries() {
        let floor = SKSpriteNode(color: SKColor.green, size: CGSize(width: frame.width, height: 32))
        floor.position = CGPoint(x: frame.midX, y: -16.0)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        floor.name = "side"
        addChild(floor)
        
        let ceiling = SKSpriteNode(color: SKColor.green, size: CGSize(width: frame.width, height: 32))
        ceiling.position = CGPoint(x: frame.midX, y: frame.height + 16.0)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.isDynamic = false
        ceiling.name = "side"
        addChild(ceiling)
        
        let right = SKSpriteNode(color: SKColor.green, size: CGSize(width: 32, height: frame.height))
        right.position = CGPoint(x: frame.width + 32.0, y: 0.0)
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        right.name = "side"
        addChild(right)
        
        let left = SKSpriteNode(color: SKColor.green, size: CGSize(width: 32, height: frame.height))
        left.position = CGPoint(x: -32.0, y: 0.0)
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        left.name = "side"
        addChild(left)
    }
    
    func createSub() {
        let subTexture = SKTexture(imageNamed: "submarine.png")
        let sub = SKSpriteNode(texture: subTexture)
        sub.position = CGPoint(x: frame.midX, y: frame.midY)
        sub.zPosition = 5.0
        sub.size = CGSize(width: 127.0, height: 87.0)
        sub.name = "sub"
        sub.physicsBody = SKPhysicsBody(rectangleOf: sub.size)
        sub.physicsBody?.usesPreciseCollisionDetection = true
        sub.physicsBody?.contactTestBitMask = 1
        sub.physicsBody?.isDynamic = true
        
        let prop = propeller()
        sub.addChild(prop)
        
        /*let makeBubbles = SKAction.sequence([
            SKAction.perform(#selector(SubmarineScene.newbubble), onTarget: self),
            SKAction.wait(forDuration: 4.0, withRange: 1.0)])
        sub.run(SKAction.repeatForever(makeBubbles))*/
        
        addChild(sub)
    }
    
    /*func newbubble() {
        let bubbleTexture = SKTexture(imageNamed: "bubble.png")
        let bubble = SKSpriteNode(texture: bubbleTexture)
        
        let float = SKAction.moveBy(x: 0.0, y: 2.0, duration: 0)
        bubble.run(SKAction.repeatForever(float))
        
        if bubble.position.y > frame.height {
            bubble.removeFromParent()
        }
        
        addChild(bubble)
    } */
    
    func addRing() {
        let ringTexture = SKTexture(imageNamed: "ring.png")
        let ring = SKSpriteNode(texture: ringTexture)
        ring.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: CGFloat(randomSource.nextUniform()) * size.height)
        ring.name = "ring"
        ring.size = CGSize(width: 70.0, height: 70.0)
        ring.physicsBody = SKPhysicsBody(rectangleOf: ring.size)
        ring.physicsBody?.usesPreciseCollisionDetection = true
        ring.physicsBody?.contactTestBitMask = 1
        ring.physicsBody?.isDynamic = false
        addChild(ring)
        
        
        // fade and grow actions then delete
        let scale = SKAction.scale(to: 2.0, duration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 3.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        
        let actions = SKAction.sequence([scale, fadeIn, pause, fadeOut, remove])
        ring.run(actions)
    }
    
    func propeller() -> (SKSpriteNode){
        let propellerTexture = SKTexture(imageNamed: "propeller.png")
        let propeller = SKSpriteNode(texture: propellerTexture)
        propeller.size = CGSize(width: 51.0, height: 49.0)
        
        let rotate = SKAction.rotate(byAngle: 10.0, duration: 0.5)
        
        let rotateRepeat = SKAction.repeatForever(rotate)
        propeller.run(rotateRepeat)
        
        return propeller
    }
    
    func removeRing(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        if contact.bodyA.node?.name == "sub" && contact.bodyB.node?.name == "side" {
            menuScene?.updateHighScore(value: points)
            let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(menuScene!, transition: open)
        }
        if contact.bodyA.node?.name == "sub" && contact.bodyB.node?.name == "ring" {
            run(hitSound)
            addPoints(value: 1)
            removeRing(node: childNode(withName: "ring") as! SKSpriteNode)
        }
        if contact.bodyA.node?.name == "ring" && contact.bodyB.node?.name == "sub" {
            run(hitSound)
            addPoints(value: 1)
            removeRing(node: childNode(withName: "ring") as! SKSpriteNode)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.characters == "w" {
            if let node = childNode(withName: "sub") {
                let up = CGVector(dx: 0.0, dy: 50.0)
                node.physicsBody?.applyImpulse(up)           }
        }
        
        if event.characters == "s" {
            if let node = childNode(withName: "sub") {
                let down = CGVector(dx: 0.0, dy: -50.0)
                node.physicsBody?.applyImpulse(down)
            }
        }
        
        if event.characters == "d" {
            if let node = childNode(withName: "sub") {
                let right = CGVector(dx: 50.0, dy: 0.0)
                node.physicsBody?.applyImpulse(right)
            }
        }
        
        if event.characters == "a" {
            if let node = childNode(withName: "sub") {
                let left = CGVector(dx: -50.0, dy: 0.0)
                node.physicsBody?.applyImpulse(left)
            }
        }
    }
    
    
}






