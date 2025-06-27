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
    self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.8)
    
    square.size = CGSize(width: 20, height: 20)
    square.color = .systemPink
    square.position = CGPoint(x: 100, y: 400)
    
    square.physicsBody = SKPhysicsBody(rectangleOf: square.size)
    square.physicsBody?.isDynamic = true
    square.physicsBody?.affectedByGravity = true
    
    addChild(square)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let rotate = SKAction.rotate(byAngle: 90, duration: 0.5)
      
      square.run(rotate)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let positinon = touch.location(in: self)
      
      let move = SKAction.move(to: positinon, duration: 0.5)
      square.run(move)
    }
  }
}
