//
//  GameLogic.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 25/03/22.
//

import Foundation


class GameLogic: ObservableObject {
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    
    // Keep tracks of the duration of the current session in number of seconds
    @Published var sessionDuration: TimeInterval = 0
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    // Single instance of the class
    static let shared: GameLogic = GameLogic()
    
    // Function responsible to set up the game before it starts.
    func setUpGame() {
        
        // TODO: Customize!
        
        self.currentScore = 0
        //self.sessionDuration = 0
        
        self.isGameOver = false
    }
    

    // Increases the score by a certain amount of points
    func score(points: Int) {
        
        // TODO: Customize!
        
        self.currentScore = self.currentScore + points
    }
    
    
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.sessionDuration = self.sessionDuration + timeIncrement
    }
    
    func restartGame() {
        
        // TODO: Customize!
        
        self.setUpGame()
    }
    
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
        }
    }
    
}
