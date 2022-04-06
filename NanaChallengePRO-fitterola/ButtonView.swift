//
//  ButtonView.swift
//  NanaChallengeX
//
//  Created by Francesco Monaco on 25/03/22.
//

import SwiftUI

struct ButtonView: View {
    
    @State private var pressed: Bool = false
    @Binding var grabbing: Bool
    
    var body: some View {
        Button(action: {grabbing.toggle(); pressed.toggle() }) {
            Image(pressed ? "ButtonPressed" : "Button")
                .resizable()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        pressed = false
                        grabbing = false
                        
                    }
                }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(grabbing: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
