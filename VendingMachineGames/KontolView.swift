//
//  KontolView.swift
//  VendingMachineGames
//
//  Created by Deka Primatio on 05/10/23.
//

import SwiftUI

struct KontolView: View {
    @State private var health = 3
    @State private var isGameOver = false
    @State private var currentRound = 0
    
    // Indicators
    @State private var targetIndex = 0
    @State private var indicatorColors: [Color] = Array(repeating: .red, count: 9)
    
    let maxRounds = 5
    let gridSize = 3
    
    // Timer
    @State private var timer: Timer?
    @State private var timeRemaining = 5 // Set the initial time limit
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Round: \(currentRound) / \(maxRounds)")
                .font(.headline)
                .foregroundColor(.black)
            
            gameGrid
            
            HStack(spacing: 16) {
                ForEach(0..<health, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $isGameOver) {
            Alert(
                title: Text("Congratulations"),
                message: Text("Bla-bla-bla"),
                dismissButton: .default(Text("Next"), action: startNextRound)
            )
        }
        .onAppear {
            startNextRound()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    private var gameGrid: some View {
        VStack(spacing: 16) {
            ForEach(0..<gridSize) { row in
                HStack(spacing: 16) {
                    ForEach(0..<gridSize) { col in
                        gameSquare(at: row * gridSize + col)
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up, decrease health and proceed to the next round
                health -= 1
                startNextRound()
                checkGameOver()
            }
        }
    }
    
    private func gameSquare(at index: Int) -> some View {
        Rectangle()
            .frame(width: 100, height: 100)
            .foregroundColor(indicatorColors[index])
            .onTapGesture {
                squareTapped(at: index)
            }
    }
    
    private func startNextRound() {
        if currentRound == maxRounds {
            isGameOver = true
            return
        }
        
        indicatorColors = Array(repeating: .red, count: gridSize * gridSize)
        targetIndex = Int.random(in: 0..<gridSize * gridSize)
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            // Change the color of the target square with animation
            indicatorColors[targetIndex] = .green
        }
        
        currentRound += 1
        
        // Reset the timer and set the initial time limit for the next round
        timeRemaining = 5
        timer?.invalidate()
        startTimer()
    }
    
    private func squareTapped(at index: Int) {
        if index == targetIndex {
            //                currentRound += 1
            startNextRound()
        } else {
            health -= 1
            startNextRound()
            checkGameOver()
        }
    }
    
    private func checkGameOver() {
        if health <= 0 {
            isGameOver = true
        }
    }
}

#Preview {
    KontolView()
}
