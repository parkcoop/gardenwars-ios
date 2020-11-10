import SpriteKit


class Gameplay: SKScene {
    private var activeTouches = [UITouch:String]()
    let controls = UIControls()
    let gameSetting = Level()
    var player1 = Player()
    var hpDisplay = HealthPoints()
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
        buildLevel1()
        addChild(hpDisplay)
        

        player1.buildPlayer1()
        hpDisplay.build()
        addChild(player1)
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(gameSetting.addThunder),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(gameSetting.addSun),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(gameSetting.addWater),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    override func update(_ currentTime: TimeInterval) {
        hpDisplay.healthText.text = String(player1.health)
        hpDisplay.scoreText.text = String(player1.points)
        if (controls.xDist < 0) {
            player1.position.x -= 0.2 * controls.xDist
        } else if (controls.xDist > 0) {
            player1.position.x -= 0.2 * controls.xDist
        } else {
            player1.faceForward()
        }
        
        if player1.frame.intersects(gameSetting.thunder.frame) {
            player1.takeDamage(points: 10)
        }
        
        if player1.frame.intersects(gameSetting.water.frame) {
            player1.holdItem(item: "water")
            player1.texture = SKTexture(imageNamed: "image/parker_water")
        }
        if player1.frame.intersects(gameSetting.sun.frame) {
            player1.holdItem(item: "sun")
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "jump" {
                    activeTouches[touch] = "jump"
                    tapBegin(on: "jump")
                }
            }
            if (controls.substrate.frame.contains(location)) {
                activeTouches[touch] = "joystick"
                tapBegin(on: "joystick")
                controls.stickActive = true
            } else {
                controls.stickActive = false
            }
            
           
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (controls.substrate.frame.contains(location)) {
                controls.joyStickPoint = location
                tapContinues(on: "joystick")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let touchedArea = activeTouches[touch] else { break }
            activeTouches[touch] = nil
            tapEnd(on: touchedArea)
        }
    }
    
    private func tapBegin(on button: String) {
        if (button == "jump") {
            player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
       }
    
    private func tapContinues(on button: String) {
        if (button == "joystick") {
            controls.moveJoystick()
            
            if (controls.xDist < 0) {
                player1.walkRight()
            } else if (controls.xDist > 0) {
                player1.walkLeft()
            } else {
                player1.faceForward()
            }
       }

    }

       private func tapEnd(on button:String) {
        if (button == "joystick") {
            controls.xDist = 0
            controls.stickActive = false
            let move:SKAction = SKAction.move(to: controls.substrate.position, duration: 0.2)
                move.timingMode = .easeOut
            controls.stick.run(move)
        }
       }
    
    
    func buildLevel1() {

        addChild(gameSetting)
        addChild(controls)
        controls.build()
        gameSetting.buildLevel1()
    }
    
    

    



}
