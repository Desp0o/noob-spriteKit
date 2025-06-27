//
//  ContentView.swift
//  noob-spriteKit
//
//  Created by Despo on 27.06.25.
//

import SwiftUI
import SpriteKit


struct ContentView: View {
  let width = UIScreen.main.bounds.width
  let height = UIScreen.main.bounds.height
  
  var scene: SKScene {
    let scene = GaameScene()
    scene.size.width = width
    scene.size.height = height
    scene.scaleMode = .fill
    
    return scene
  }
  
    var body: some View {
        VStack {
            SpriteView(scene: scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
