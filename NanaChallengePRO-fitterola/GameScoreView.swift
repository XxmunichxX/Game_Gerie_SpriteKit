//
//  GameScoreView.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 25/03/22.
//

import SwiftUI

struct GameScoreView: View {
    @Binding var score: Int
    
    var body: some View {
        
        HStack {
            Image("Utande2")
                .font(.headline)
            Spacer()
            Text("\(score)")
                .font(.system(size: 35))
        }
        .frame(width: 100, height: 20)
        .padding(24)
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

/*struct GameScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GameScoreView(score: .constant(100))
            .previewLayout(.fixed(width: 300, height: 100))
    }
} */
