//
//  GameScene.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 22/03/22.
//

import SpriteKit
import SwiftUI


class GameScene: SKScene {
    
    @StateObject var gameLogic: GameLogic = GameLogic.shared
    
    private var alert: Bool = false
    private var background = SKSpriteNode()
    private var backgroundFrames: [SKTexture] = []
    private var housekeeper = SKSpriteNode()
    private var gnome = SKSpriteNode()
    private var button = SKSpriteNode()
    private var isVisible = true
    
    private var isMovingToTheRight: Bool = false
    private var isMovingToTheLeft: Bool = false
    
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "edgygerie", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        gameLogic.setUpGame()
        buildUnderpantsPile()
        buildSecondUnderpantsPile()
        buildBackground()
        animateBackground()
        buildGnome()
        buildHousekeeper()
        buildCestellino()
        buildButton()
        
        if !gameLogic.isGameOver {
            moveHousekeeper()
        }
        
    }
    
    enum SideOfTheScreen {
        case right, left
    }
    
    private func sideTouched(for position: CGPoint) -> SideOfTheScreen {
        if position.x < self.frame.width / 2 {
            return .left
        } else {
            return .right
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        
        switch sideTouched(for: touchLocation) {
        case .right:
            self.isMovingToTheRight = true
        case .left:
            self.isMovingToTheLeft = true
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "button" {
                button.texture = SKTexture(imageNamed: "ButtonPressed")
                gnome.texture = SKTexture(imageNamed: "gnome2")
                self.isMovingToTheRight = false
                gameLogic.currentScore += 1
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMovingToTheRight = false
        self.isMovingToTheLeft = false
        gnome.texture = SKTexture(imageNamed: "gnome1")
        button.texture = SKTexture(imageNamed: "Button")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        /*  if self.isGameOver { self.finishGame() }
         
         if self.lastUpdate == 0 { self.lastUpdate = currentTime }
         
         let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
         self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
         
         self.lastUpdate = currentTime */
        
        if isMovingToTheRight && (self.gnome.position.x > 0) {
            self.moveRight()
        }
        
        if isMovingToTheLeft && (self.gnome.position.x < frame.width) {
            self.moveLeft()
        }
        
        // BOUNDARIES FOR THE PLAYER
        
        if gnome.position.x < frame.minX + gnome.size.width/2 {
            gnome.position.x = frame.minX + gnome.size.width/2
          }
        
        if gnome.position.x > frame.maxX - gnome.size.width/2 {
            gnome.position.x = frame.maxX - gnome.size.width/2
          }
        
    }
    
    private func moveLeft() {
        self.gnome.position.x = self.gnome.position.x - 2
        self.gnome.xScale = -1
        
    }
    
    private func moveRight() {
        self.gnome.position.x = self.gnome.position.x + 2
        self.gnome.xScale = 1
        
    }
    
    func buildButton() {
        let button = SKSpriteNode(imageNamed: "Button")
        button.size = CGSize(width: 100, height: 100)
        button.name = "button"
        button.position = CGPoint(x: 680, y: 65)
        button.zPosition = 4
        addChild(button)
    }
    
    func moveHousekeeper() {
        let action1 = SKAction.move(to: CGPoint(x: 560, y: 140), duration: 5)
        let action2 = SKAction.move(to: CGPoint(x: 600, y: 190), duration: 5)
        
        housekeeper.run(action1)
        DispatchQueue.main.asyncAfter(deadline: .now()+7) {
            self.housekeeper.xScale = -1 //NEGATIVE TO FACE RIGHT
            self.housekeeper.run(action2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+14) {
            self.housekeeper.xScale = 1 //POSITIVE TO FACE LEFT
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+21) {
            self.housekeeper.xScale = -1
            self.housekeeper.run(action2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+28) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+35) {
            self.housekeeper.xScale = -1
            self.housekeeper.run(action2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+42) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+49) {
            self.housekeeper.xScale = -1
            self.housekeeper.run(action2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+56) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+63) {
            self.housekeeper.xScale = -1
            self.housekeeper.run(action2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+70) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
    }
    
    func buildSecondUnderpantsPile() {
        let pile = SKSpriteNode(imageNamed: "pilaDiMutande")
        pile.size = CGSize(width: 50, height: 70)
        pile.position = CGPoint(x: 660, y: 200)
        pile.zPosition = 1
        addChild(pile)
    }
    
    func buildUnderpantsPile() {
        let pile = SKSpriteNode(imageNamed: "pilaDiMutande")
        pile.size = CGSize(width: 50, height: 70)
        // CHANGE Y VALUE BASED ON UNDERPANTS GRABBED / TAPS
        pile.position = CGPoint(x: 550, y: 82)
        pile.zPosition = 2
        addChild(pile)
    }
    
    func buildCestellino() {
        let cestellino = SKSpriteNode(imageNamed: "cestellino")
        cestellino.size = CGSize(width: 170, height: 100)
        cestellino.name = "cestellino"
        cestellino.position = CGPoint(x: 581, y: 30)
        cestellino.zPosition = 2
        
        cestellino.physicsBody = SKPhysicsBody(rectangleOf: cestellino.size)
        cestellino.physicsBody?.affectedByGravity = false
        cestellino.physicsBody?.categoryBitMask = PhysicsCategory.cestellino
        cestellino.physicsBody?.contactTestBitMask = PhysicsCategory.gnome
        cestellino.physicsBody?.collisionBitMask = PhysicsCategory.gnome
        cestellino.physicsBody?.affectedByGravity = false
        cestellino.physicsBody?.isDynamic = false
        
        addChild(cestellino)
    }
    
    func buildHousekeeper() {
        housekeeper = SKSpriteNode(imageNamed: "housekeeper1")
        housekeeper.size = CGSize(width: 130, height: 250)
        housekeeper.position = CGPoint(x: 560, y: 190)
        housekeeper.zPosition = 1
        
        addChild(housekeeper)
    }
    
    func buildGnome() {
        gnome = SKSpriteNode(imageNamed: "gnome1")
        gnome.name = "gnome"
        gnome.size = CGSize(width: 50, height: 100)
        gnome.position = CGPoint(x: 150, y: 50)
        gnome.zPosition = 3
        
        gnome.physicsBody = SKPhysicsBody(rectangleOf: gnome.size)
        gnome.physicsBody?.affectedByGravity = false
        gnome.physicsBody?.categoryBitMask = PhysicsCategory.gnome
        //gnome.physicsBody?.collisionBitMask = PhysicsCategory.cestellino
        //gnome.physicsBody?.contactTestBitMask = PhysicsCategory.cestellino
        gnome.physicsBody?.affectedByGravity = false
        gnome.physicsBody?.isDynamic = false
        
        /* let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
         let xConstraint = SKConstraint.positionX(xRange)
         self.gnome.constraints = [xConstraint] */
        
        addChild(gnome)
    }
    
    func buildBackground() {
        let bgAnimatedAtlas = SKTextureAtlas(named: "Background")
        var bgFrames: [SKTexture] = []
        
        let numImages = bgAnimatedAtlas.textureNames.count   //bgAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bgTextureName = "background\(i)"
            bgFrames.append(bgAnimatedAtlas.textureNamed(bgTextureName))
        }
        backgroundFrames = bgFrames
        let firstFrameTexture = backgroundFrames[0]
        background = SKSpriteNode(texture: firstFrameTexture)
        background.size = CGSize(width: 900, height: 450)
        background.position =  CGPoint(x: 450, y: 202)   //CGPoint(x: frame.midX, y: frame.midY)
        //background.anchorPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        background.zPosition = -1
        addChild(background)
    }
    
    func animateBackground() {
        background.run(SKAction.repeatForever(
            SKAction.animate(with: backgroundFrames,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                       withKey:"animatedBackground")
    }
    
}

//MARK: - Collision

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "gnome" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "gnome" && secondBody.node?.name == "cestellino" {
            print("CONTACT")
       }
    }
}
