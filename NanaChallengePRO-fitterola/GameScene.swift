//
//  GameScene.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 22/03/22.
//

import SpriteKit
import SwiftUI


enum GameState {
    case playing
    case gameover
}


class GameScene: SKScene {
    
    var gameState = GameState.playing
    
    @StateObject var gameLogic: GameLogic = GameLogic.shared
    
    private var background = SKSpriteNode()
    private var backgroundFrames: [SKTexture] = []
    private var housekeeper = SKSpriteNode()
    private var gnome = SKSpriteNode()
    private var button = SKSpriteNode()
    private var gameOverLogo = SKSpriteNode()
    private var restartButton = SKSpriteNode()
    
    private var isMovingToTheRight: Bool = false
    private var isMovingToTheLeft: Bool = false
    
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "edgygerie", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        //gameLogic.setUpGame()
        buildUnderpantsPile()
        buildSecondUnderpantsPile()
        buildBackground()
        animateBackground()
        buildGnome()
        buildHousekeeper()
        buildCestellino()
        buildButton()
        buildGameOverLogo()
        buildRestartButton()
        
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
        
        switch gameState {
        case .playing:
            switch sideTouched(for: touchLocation) {
            case .right:
                self.isMovingToTheRight = true
            case .left:
                self.isMovingToTheLeft = true
            }
        case .gameover:
            break
        }
        
        // INCREASING SCORE WHILE CLOSE TO THE BASKET
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "button" {
                button.texture = SKTexture(imageNamed: "ButtonPressed")
                gnome.texture = SKTexture(imageNamed: "gnome2")
                self.isMovingToTheRight = false
                if gnome.position.x > 500  && gnome.position.x < 600 {
                    gameLogic.currentScore += 1
                }
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "restartButton" {
                gameOverLogo.alpha = 0
                restartButton.alpha = 0
                gnome.position = CGPoint(x: 150, y: 50)
                housekeeper.texture = SKTexture(imageNamed: "housekeeper1")
                gameState = .playing
                gameLogic.restartGame()
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
        
        if isMovingToTheRight && (self.gnome.position.x > 0) {
            self.moveRight()
        }
        
        if isMovingToTheLeft && (self.gnome.position.x < frame.width) {
            self.moveLeft()
        }
        
        if gameState == .gameover {
            isMovingToTheRight = false
            isMovingToTheLeft = false
        }
        
        
        // BOUNDARIES FOR THE PLAYER
        
        if gnome.position.x < frame.minX + gnome.size.width/2 {
            gnome.position.x = frame.minX + gnome.size.width/2
          }
        
        if gnome.position.x > frame.maxX - gnome.size.width/2 {
            gnome.position.x = frame.maxX - gnome.size.width/2
          }
        
        // GAME OVER CONDITIONS
        
        if gnome.position.x > 330 && housekeeper.xScale == 1{
            housekeeper.texture = SKTexture(imageNamed: "housekeeper2")
            //gameLogic.isGameOver = true
            gameState = .gameover
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.gameOverLogo.alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.restartButton.alpha = 1
            }
            
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
    
    func buildRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.name = "restartButton"
        restartButton.size = CGSize(width: 50, height: 50)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY-110)
        restartButton.zPosition = 5
        restartButton.alpha = 0
        addChild(restartButton)
    }
    
    func buildGameOverLogo() { 
        gameOverLogo = SKSpriteNode(imageNamed: "gameOver")
        gameOverLogo.size = CGSize(width: 350, height: 180)
        gameOverLogo.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLogo.zPosition = 5
        gameOverLogo.alpha = 0
        addChild(gameOverLogo)
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
        let action1 = SKAction.move(to: CGPoint(x: 560, y: 140), duration: 3)
        let action2 = SKAction.move(to: CGPoint(x: 600, y: 190), duration: 3)
        
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
        DispatchQueue.main.asyncAfter(deadline: .now()+77) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+84) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+91) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+98) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+105) {
            self.housekeeper.xScale = 1
            self.housekeeper.run(action1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+112) {
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

