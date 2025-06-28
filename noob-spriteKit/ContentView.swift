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
    let scene = ShooterScene()
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


final class ShooterScene: SKScene {
  let square = SKSpriteNode()
  
  let screenWidth: CGFloat = UIScreen.main.bounds.width
  let screenHeight: CGFloat = UIScreen.main.bounds.height
  
  override func didMove(to view: SKView) {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    
    createSquareSprite()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let newLocation = touch.location(in: self)
      
      let move = SKAction.move(to: CGPoint(x: newLocation.x, y: square.position.y), duration: 0.1)
      
      square.run(move)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
      shootBullets()
  }
  
  func createSquareSprite() {
    square.name = "ship"
    square.size = CGSize(width: 40, height: 40)
    square.color = .green
    square.position = CGPoint(x: screenWidth / 2, y: CGFloat(UIScreen.main.bounds.minY + 40))
    
    square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)
    square.physicsBody?.isDynamic = false
    square.physicsBody?.affectedByGravity = false
    square.physicsBody?.usesPreciseCollisionDetection = true

    addChild(square)
  }
  
  func shootBullets() {
    let bullet = SKShapeNode(circleOfRadius: 10)
    bullet.fillColor = .red
    bullet.strokeColor = .yellow
    bullet.position = CGPoint(x: square.position.x, y: square.position.y + 20)
    
    bullet.physicsBody = SKPhysicsBody(circleOfRadius: 10)
    bullet.physicsBody?.isDynamic = false
    bullet.physicsBody?.affectedByGravity = false
    bullet.physicsBody?.usesPreciseCollisionDetection = true
    
    let bulletMove = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 0.5)
    let removeBullet = SKAction.removeFromParent()
    
    let sequence = SKAction.sequence([bulletMove, removeBullet])
    
    bullet.run(sequence)
    
    addChild(bullet)
  }
}

