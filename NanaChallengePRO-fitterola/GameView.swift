//
//  GameView.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 25/03/22.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject var gameLogic: GameLogic = GameLogic.shared
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    var gameScene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        
        return scene
    }
    
    
    var body: some View {
        ZStack() {
            // View that presents the game scene
            SpriteView(scene: self.gameScene)
                .frame(width: screenWidth, height: screenHeight+30, alignment: .center) //850, 420
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .zIndex(-1)
                            
            
            /**
             * UI element showing the current score of the player.
             * Remove it if your game is not based on scoring points.
             */
            
            GameScoreView(score: $gameLogic.currentScore)
                .position(x: 120, y: 100)
                .zIndex(2)
               
           /* ButtonView(grabbing: $gameLogic.isGrabbing)
                .position(x: 700, y: 350)
                .zIndex(2) */
                
            
        }
        .onChange(of: gameLogic.isGameOver) { _ in
            if gameLogic.isGameOver {
                
                /** # PRO TIP!
                 * You can experiment by adding other types of animations here before presenting the game over screen.
                 */
                
                withAnimation {
                    //self.presentGameOverScreen()
                }
            }
        }
        .onAppear {
            gameLogic.restartGame()
        }
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewInterfaceOrientation(.landscapeLeft)
           
            
    }
}
