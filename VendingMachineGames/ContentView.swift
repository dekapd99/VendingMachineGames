//
//  ContentView.swift
//  VendingMachineGames
//
//  Created by Deka Primatio on 04/10/23.
//

import SwiftUI

enum RectangleState {
    case neutral, green, red, yellow
}

struct ContentView: View {
    @State private var rectangleStates: [[RectangleState]] = Array(repeating: Array(repeating: .neutral, count: 3), count: 3)
    @State private var countdown = 3 // Set the initial countdown time
    @State private var showAlert = false
    @State private var gameResult = ""
    @State private var hp = 3
    
    var body: some View {
        VStack(spacing: 30) {
            if countdown > 0 {
                Text("Game starts in \(countdown) seconds")
                    .font(.title)
                    .foregroundColor(.blue)
                    .onAppear {
                        startCountdown()
                    }
            } else {
                ForEach(0..<3) { row in
                    HStack(spacing: 30) {
                        ForEach(0..<3) { column in
                            VStack {
                                Rectangle()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(rectangleColor(row, column))
                                    .onTapGesture {
                                        handleTap(row, column)
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text(gameResult),
                dismissButton: .default(Text("Restart")) {
                    resetGame()
                }
            )
        }
    }
    
    func rectangleColor(_ row: Int, _ column: Int) -> Color {
        switch rectangleStates[row][column] {
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .red:
            return .red
        case .neutral:
            return .gray
        }
    }
    
    func handleTap(_ row: Int, _ column: Int) {
        if rectangleStates[row][column] == .green {
            gameResult = "You win!"
        } else {
            gameResult = "You lose!"
        }
        
        showAlert = true
    }
    
    func resetGame() {
        rectangleStates = Array(repeating: Array(repeating: .neutral, count: 3), count: 3)
        
        // Set one random rectangle to green
        let greenRow = Int.random(in: 0..<3)
        let greenColumn = Int.random(in: 0..<3)
        rectangleStates[greenRow][greenColumn] = .green
        
        // Set the rest to red
        for row in 0..<3 {
            for column in 0..<3 {
                if row != greenRow || column != greenColumn {
                    rectangleStates[row][column] = .red
                }
            }
        }
        startCountdown() // Restart the countdown
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    ContentView()
}
