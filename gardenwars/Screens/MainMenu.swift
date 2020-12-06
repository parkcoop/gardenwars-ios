import SpriteKit

class MainMenu: SKScene {
    var background = SKSpriteNode(imageNamed: "image/sky")
    let logo = SKSpriteNode(imageNamed: "image/logo")
    var menuPhase = 1
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = self.frame.size
        background.zPosition = -5
        logo.scale(to: CGSize(width: 200, height: 125))
        addChild(background)
        addChild(logo)
        
        let welcomeLabel = SKLabelNode(fontNamed: "Chalkduster")
        welcomeLabel.text = "Tap the screen to begin"
        welcomeLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 - 100)
        logo.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        welcomeLabel.zPosition = 6
        welcomeLabel.fontSize = 26
        welcomeLabel.fontColor = UIColor.black
        welcomeLabel.alpha = 1
        addChild(welcomeLabel)
    }
    
    func showChooseCharacter() {
        if menuPhase > 1 {
            return
        }
        menuPhase += 1
        self.removeAllChildren()
        let chooseLabel = SKLabelNode()
        chooseLabel.text = "Choose your gardener"
        chooseLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.9)
        addChild(chooseLabel)
        let parker = SKSpriteNode(imageNamed: "image/parker5")
        let enemy = SKSpriteNode(imageNamed: "image/enemy5")
        let darla = SKSpriteNode(imageNamed: "image/darla5")
        addChild(parker)
        parker.position = CGPoint(x: ScreenSize.width * 0.25, y: ScreenSize.height * 0.5)
        parker.name = "parker"
        addChild(enemy)
        enemy.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.5)
        enemy.name = "enemy"
        addChild(darla)
        darla.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height * 0.5)
        darla.name = "darla"

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        startGamePlay()
        showChooseCharacter()
      
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "parker" {
                    startGamePlay()
                }
                if node.name == "enemy" {
                    enemyCharacter = "darla"
                    chosenCharacter = "enemy"
                    startGamePlay()
                }
                if node.name == "darla" {
                    chosenCharacter = "darla"
                    enemyCharacter = "parker"
                    startGamePlay()
                }
            }

        }
    }
    
    
    func setupNodes() {
        
    }
    
    
    func addNodes() {
        
    }
    
    
    @objc func startGamePlayNotification(_ info:Notification) {
        startGamePlay()
    }
    
    
    func startGamePlay() {
        currentLevel = 1
        GameManager.shared.transition(self, toScene: .Gameplay, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 2))
    }
}
