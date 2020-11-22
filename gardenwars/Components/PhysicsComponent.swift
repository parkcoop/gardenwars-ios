
import SpriteKit
import GameplayKit

class PhysicsComponent : GKComponent {
    var body : SKPhysicsBody?
    // 1.
    init( body : SKPhysicsBody ) {
        self.body = body
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    // 2.
    override func didAddToEntity() {
        self.entity?.component(ofType: NodeComponent.self)?.node.physicsBody = self.body
    }
    // 3.
    override func willRemoveFromEntity() {
        if let hasNode = self.entity?.component(ofType: NodeComponent.self)?.node {
            hasNode.physicsBody = nil
            // 4.
            self.entity?.component(ofType: PositionComponent.self)?.currentPosition = hasNode.position
        }
        self.body = nil
    }
}
