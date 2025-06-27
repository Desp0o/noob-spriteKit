//
//  GameScene.swift
//  noob-spriteKit
//
//  Created by Despo on 27.06.25.
//

import SpriteKit

final class GaameScene: SKScene {
  let square = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    square.size = CGSize(width: 20, height: 20)
    square.color = .systemPink
    square.position = CGPoint(x: 100, y: 100)
    
    addChild(square)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let positinon = touch.location(in: self)
      
      let move = SKAction.move(to: positinon, duration: 0.5)
      let rotate = SKAction.rotate(byAngle: 90, duration: 0.5)
      
      let sequence = SKAction.sequence([move, rotate])
      square.run(sequence)
    }
  }
}
