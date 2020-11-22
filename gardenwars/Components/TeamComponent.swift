import SpriteKit
import GameplayKit

// 1
enum Team: Int {
    case team1 = 1
    case team2 = 2
    
    static let allValues = [team1, team2]
    
    func oppositeTeam() -> Team {
        switch self {
        case .team1:
            return .team2
        case .team2:
            return .team1
        }
    }
}

// 2
class TeamComponent: GKComponent {
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
