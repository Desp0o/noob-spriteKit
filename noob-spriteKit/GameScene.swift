//
//  GameScene.swift
//  noob-spriteKit
//
//  Created by Despo on 27.06.25.
//

import SpriteKit

final class GaameScene: SKScene {
  override func didMove(to view: SKView) {
    print("hello")
    let square = SKSpriteNode()
    square.size = CGSize(width: 20, height: 20)
    square.color = .systemPink
    square.position = CGPoint(x: 100, y: 100)
    
    addChild(square)
  }
}
