/**
 Do not change anything in this class
 */
struct Scoreboard{
    
    let p1PrevSets: String
    let p1MatchScore: Int
    let p1SetScore: Int
    let p1GameScore: String
    let p2PrevSets: String
    let p2MatchScore: Int
    let p2SetScore: Int
    let p2GameScore: String
    
    init(p1PrevSets: String,
         p1MatchScore: Int,
         p1SetScore: Int,
         p1GameScore: String,
         p2PrevSets: String,
         p2MatchScore: Int,
         p2SetScore: Int,
         p2GameScore: String){
        self.p1PrevSets = p1PrevSets
        self.p1MatchScore = p1MatchScore
        self.p1SetScore = p1SetScore
        self.p1GameScore = p1GameScore
        self.p2PrevSets = p2PrevSets
        self.p2MatchScore = p2MatchScore
        self.p2SetScore = p2SetScore
        self.p2GameScore = p2GameScore
    }
    
    func printView() -> String {
        let prevSets1Padded = p1PrevSets.padding(toLength: 9, withPad: " ", startingAt: 0)
        let prevSets2Padded = p2PrevSets.padding(toLength: 9, withPad: " ", startingAt: 0)
        
        let board = """
        Prev Sets   Player    Sets  Games  Points
        \(prevSets1Padded)   Player 1  \(p1MatchScore)     \(p1SetScore)      \(p1GameScore)
        \(prevSets2Padded)   Player 2  \(p2MatchScore)     \(p2SetScore)      \(p2GameScore)
        """
        
        return board
    }
    
    
}

