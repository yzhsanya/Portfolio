import SwiftUI

struct ContentView: View {
    @State var game = Game()
    
    @State private var showingModal = false
    
    var body: some View {
        
        
            TennisScoreView(game: game, onScoreChanged: {
                if game.complete() {
                    showingModal = true
                }
            })
        
            .padding()
            .sheet(isPresented: $showingModal, onDismiss: {
                restart()
            }, content: {
                GameCompleteModalView(game: game)
            })
            
    }
    
    func restart(){
        game = Game()
    }
}

#Preview {
    ContentView()
}


struct TennisScoreView: View {
    @ObservedObject var game: Game 
    var onScoreChanged: () -> Void

    var body: some View {
        VStack(spacing: 20) {


            HStack(spacing: 20) {
                VStack {
                    Text("Player 1")
                        .font(.headline)
                    Text(game.player1Score())
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                }

                VStack {
                    Text("Player 2")
                        .font(.headline)
                    Text(game.player2Score())
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                }
            }.frame(minHeight: 50)

            HStack(spacing: 10) {
                Button(action: {
                    game.addPointToPlayer1()
                    onScoreChanged()
                }) {
                    Text("P 1")
                        .frame(minWidth: 50)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button(action: {
                    game.addPointToPlayer2()
                    onScoreChanged()
                }) {
                    Text("P 2")
                        .frame(minWidth: 50)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

           
        }
        .padding()
    }
}

struct GameCompleteModalView: View {
    var game: Game
    var body: some View {
        VStack {
            Text("🎾 Game Over")
                .font(.headline)
                .padding()

            Text("Player \(game.player1Won() ? "1" : "2") wins")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

