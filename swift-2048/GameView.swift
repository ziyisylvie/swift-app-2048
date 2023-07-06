//
//  GameView.swift
//  swift-2048
//
//  Created by user on 7/5/23.
//
import SwiftUI

enum SwipeDirection {
    case left, right, up, down
}

struct GameView: View {
    @State private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    
    var body: some View {
        VStack {
            Text("2048 Game")
                .font(.title)
                .padding()
            
            ForEach(0..<4) { row in
                HStack {
                    ForEach(0..<4) { column in
                        Text("\(board[row][column])")
                            .frame(width: 60, height: 60)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
            
            Button("New Game") {
                resetBoard()
            }
            .padding()
        }
        .onAppear {
            resetBoard()
        }
        .gesture(DragGesture()
                    .onEnded { value in
                        handleSwipe(value: value)
                    }
        )
    }
    
    private func resetBoard() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        addTile()
        addTile()
    }
    
    private func addTile() {
        let emptyTiles = getEmptyTiles()
        if emptyTiles.isEmpty {
            return
        }
        
        let randomIndex = Int.random(in: 0..<emptyTiles.count)
        let (row, column) = emptyTiles[randomIndex]
        board[row][column] = 2
    }
    
    private func getEmptyTiles() -> [(Int, Int)] {
        var emptyTiles: [(Int, Int)] = []
        
        for row in 0..<4 {
            for column in 0..<4 {
                if board[row][column] == 0 {
                    emptyTiles.append((row, column))
                }
            }
        }
        
        return emptyTiles
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let deltaX = value.translation.width
        let deltaY = value.translation.height
        
        if abs(deltaX) > abs(deltaY) {
            if deltaX > 0 {
                swipe(direction: .right)
            } else {
                swipe(direction: .left)
            }
        } else {
            if deltaY > 0 {
                swipe(direction: .down)
            } else {
                swipe(direction: .up)
            }
        }
    }
    
    private func swipe(direction: SwipeDirection) {
        switch direction {
        case .left:
            for row in 0..<4 {
                var tmp = Array(repeating: 0, count: 4)
                var index = 0
                for column in 0..<4 {
                    if board[row][column] != 0 {
                        tmp[index] = board[row][column]
                        index = index+1
                    }
                }
                for i in 0..<3 {
                    if tmp[i] == tmp[i + 1] {
                        tmp[i] *= 2
                        tmp[i + 1] = 0
                    }
                }
                if(tmp[2] != 0 && tmp[1] == 0) {
                    tmp[1] = tmp[2]
                    tmp[2] = 0
                }
                board[row] = tmp
            }
            
        case .right:
            for row in 0..<4 {
                var tmp = Array(repeating: 0, count: 4)
                var index = 3
                for column in (0..<4).reversed() {
                    if board[row][column] != 0 {
                        tmp[index] = board[row][column]
                        index = index-1
                    }
                }
                for i in stride(from: 3, to: 0, by: -1) {
                    if tmp[i] == tmp[i - 1] {
                        tmp[i] *= 2
                        tmp[i - 1] = 0
                    }
                }
                if(tmp[1] != 0 && tmp[2] == 0) {
                    tmp[2] = tmp[1]
                    tmp[1] = 0
                }
                board[row] = tmp
            }
            
        case .up:
            for column in 0..<4 {
                var tmp = Array(repeating: 0, count: 4)
                var index = 0
                for row in 0..<4 {
                    if board[row][column] != 0 {
                        tmp[index] = board[row][column]
                        index = index+1
                    }
                }
                for i in 0..<3 {
                    if tmp[i] == tmp[i + 1] {
                        tmp[i] *= 2
                        tmp[i + 1] = 0
                    }
                }
                if(tmp[2] != 0 && tmp[1] == 0) {
                    tmp[1] = tmp[2]
                    tmp[2] = 0
                }
                for i in 0..<4 {
                    board[i][column] = tmp[i]
                }
            }
            
        case .down:
            for column in 0..<4 {
                var tmp = Array(repeating: 0, count: 4)
                var index = 3
                for row in (0..<4).reversed() {
                    if board[row][column] != 0 {
                        tmp[index] = board[row][column]
                        index = index-1
                    }
                }
                for i in stride(from: 3, to: 0, by: -1) {
                    if tmp[i] == tmp[i - 1] {
                        tmp[i] *= 2
                        tmp[i - 1] = 0
                    }
                }
                if(tmp[1] != 0 && tmp[2] == 0) {
                    tmp[2] = tmp[1]
                    tmp[1] = 0
                }
                for i in 0..<4 {
                    board[i][column] = tmp[i]
                }
            }
        }
        
        addTile()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
