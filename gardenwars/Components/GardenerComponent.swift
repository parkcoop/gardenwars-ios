import SpriteKit
import GameplayKit

class GardenerComponent: GKComponent {
    
    // 1
    var coins = 0
    var health = 100
    var currentItem: String? = nil
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
    
    func grabItem(item: String) {
        self.currentItem = item
    }
}
