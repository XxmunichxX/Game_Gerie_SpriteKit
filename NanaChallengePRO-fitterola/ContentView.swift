//
//  ContentView.swift
//  NanaChallengeRefined
//
//  Created by Francesco Monaco on 06/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var gameLogic: GameLogic = GameLogic()
    
    var body: some View {
        GameView()
            .environmentObject(gameLogic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
