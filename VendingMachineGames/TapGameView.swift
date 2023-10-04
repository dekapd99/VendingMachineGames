import SwiftUI

struct TapGameView: View {
    @State private var health = 5
    @State private var round = 0
    @State private var isGameActive = true
    @State private var greenIndex = 0
    @State private var redIndices = Set<Int>()
    
    var body: some View {
        VStack {
            Text("Round: \(round + 1)")
                .padding()
            
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        GameSquareView(isGreen: greenIndex == row * 3 + col,
                                       isRed: redIndices.contains(row * 3 + col),
                                       onTap: { self.squareTapped(row * 3 + col) })
                    }
                }
            }
            
            if !isGameActive {
                VStack {
                    if health > 0 {
                        Text("Congratulations!")
                            .font(.largeTitle)
                            .padding()
                        Button("Next", action: nextRound)
                    } else {
                        Text("Game Over!")
                            .font(.largeTitle)
                            .padding()
                        Button("Restart", action: restartGame)
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: startGame)
    }
    
    func startGame() {
        nextRound()
    }
    
    func nextRound() {
        isGameActive = true
        round += 1
        greenIndex = Int.random(in: 0..<9)
        redIndices = Set((0..<8).map { _ in Int.random(in: 0..<9) })
        health = 5
        flashSquares()
    }
    
    func squareTapped(_ index: Int) {
        if isGameActive {
            if index == greenIndex {
                // Green square tapped
                nextRound()
            } else if redIndices.contains(index) {
                // Red square tapped
                health -= 1
                if health == 0 {
                    isGameActive = false
                }
            }
        }
    }
    
    func restartGame() {
        isGameActive = true
        round = 0
        nextRound()
    }
    
    func flashSquares() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.greenIndex = -1
                self.redIndices = []
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.greenIndex = -1
                    self.redIndices = []
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        self.greenIndex = -1
                        self.redIndices = []
                    }
                }
            }
        }
    }
}

struct GameSquareView: View {
    let isGreen: Bool
    let isRed: Bool
    let onTap: () -> Void
    
    var body: some View {
        Rectangle()
            .frame(width: 80, height: 80)
            .foregroundColor(isGreen ? .green : (isRed ? .red : .blue))
            .onTapGesture {
                onTap()
            }
    }
}

struct TapGameView_Previews: PreviewProvider {
    static var previews: some View {
        TapGameView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TapGameView()
    }
}

