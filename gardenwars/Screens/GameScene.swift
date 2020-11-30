//import SpriteKit
//import AudioToolbox
//import GameplayKit
//
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//
//    var player: SKSpriteNode?
//    let uiControls = UIControls()
//    var hpDisplay = HealthPoints()
//    private var activeTouches = [UITouch:String]()
//
//    override func didMove(to view: SKView) {
//        player = childNode(withName: "player") as? SKSpriteNode
//        
//        let background = SKSpriteNode(imageNamed: "image/sky")
//        background.position = self.position
////        background.anchorPoint = CGPoint(x: 0, y: 0)
//        background.zPosition = -1
//        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
//        addChild(background)
//       
//        physicsWorld.contactDelegate = self
//        self.view?.isMultipleTouchEnabled = true
//        camera?.addChild(uiControls)
//        camera?.addChild(hpDisplay)
//        run(SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.wait(forDuration: 1.0),
//                SKAction.wait(forDuration: 1.0),
//                SKAction.wait(forDuration: 1.0)
//            ])
//        ))
//    }
//    
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if (contact.bodyA.node?.name != nil && contact.bodyB.node?.name != nil) {
//
//        }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        camera?.position = uiControls.position
//       
//        
//    }
////    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("LOL")
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchedNode = self.nodes(at: location)
//            for node in touchedNode {
//            if node.name == "jump" {
//                activeTouches[touch] = "jump"
//                tapBegin(on: "jump")
//            }
//            if node.name == "settings" {
//                openSettingsMenu()
//            }
//            }
//            if (uiControls.substrate.frame.contains(location)) {
//                activeTouches[touch] = "joystick"
//                tapBegin(on: "joystick")
//                uiControls.stickActive = true
//            } else {
//                uiControls.stickActive = false
//            }
//        }
//    }
//    
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            if (uiControls.substrate.frame.contains(location)) {
//                uiControls.joyStickPoint = location
//                tapContinues(on: "joystick")
//            }
//        }
//    }
//    
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            guard let touchedArea = activeTouches[touch] else { break }
//            activeTouches[touch] = nil
//            tapEnd(on: touchedArea)
//        }
//    }
//    
//    
//    private func tapBegin(on button: String) {
//        if (button == "jump") {
//            player!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//            player!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
////            if let component = humanGardener.component(ofType: MovementComponent.self) {
//////                component.jump()
////                component.jump()
////            }
//        }
//    }
//    
//    
//    private func tapContinues(on button: String) {
//        if (button == "joystick") {
//            uiControls.moveJoystick()
////            if let component = humanGardener.component(ofType: MovementComponent.self) {
////                if (uiControls.xDist < 0) {
////                    component.move(direction: "right")
////                } else if (uiControls.xDist > 0) {
////                    component.move(direction: "left")
////                } else {
////                    component.faceForward()
////                }
////            }
//           
//        }
//        
//    }
//    
//    
//    private func tapEnd(on button:String) {
////        if (button == "joystick") {
////            uiControls.xDist = 0
////            uiControls.stickActive = false
////            let move:SKAction = SKAction.move(to: uiControls.substrate.position, duration: 0.2)
////            move.timingMode = .easeOut
////            uiControls.stick.run(move)
////        }
//    }
//    
//    
//    func openSettingsMenu() -> Void {
//        GameManager.shared.transition(self, toScene: .MainMenu, transition:
//                                        SKTransition.doorsCloseHorizontal(withDuration: 2))
//    }
//    
////    func nextLevel(level: Int) -> Void {
////        switch level {
////        case 2:
////            gameSetting.buildLevel2()
////        case 3:
////            gameSetting.buildLevel3()
////        case 4: // Ended game
////            GameManager.shared.transition(self, toScene: .Settings, transition:
////                                            SKTransition.crossFade(withDuration: 2))
////        default:
////            return
////        }
////    }
//    
//    
//    
//    
//    
//}
