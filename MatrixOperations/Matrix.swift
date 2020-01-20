//
//  Matrix.swift
//  NoblyTest
//
//  Created by Criss on 11/29/19.
//  Copyright © 2019 Criss. All rights reserved.
//

import Foundation

class Matrix: CustomStringConvertible {
    
    internal var data: Array<Int>
    
    var rows: Int
    var columns: Int
    
    var description: String {
        var d = ""
        for row in 0..<rows {
            for col in 0..<columns {
                let s = String(self[row,col])
                d += s + " "
            }
            d += "\n"
        }
        return d
    }
    
    init(_ data: Array<Int>) {
        let lines = sqrt(Double(data.count))
        precondition(lines.truncatingRemainder(dividingBy: 1) == 0, "Matrix is not square")
        let count = Int(lines)
        
        self.data = data
        self.rows = count
        self.columns = count
    }
        
    // MARK: Private methods
        
    fileprivate init(rows: Int, columns: Int) {
        self.data = [Int](repeating: 0, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    fileprivate init(_ data:Array<Int>, rows:Int, columns:Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    fileprivate init(lines: Int) {
        self.data = [Int](repeating: 0, count: lines * lines)
        self.rows = lines
        self.columns = lines
    }
    
    fileprivate subscript(row: Int, col: Int) -> Int {
        get {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            return data[(row * columns) + col]
        }
        
        set {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            self.data[(row * columns) + col] = newValue
        }
    }
    
    fileprivate func row(index: Int) -> [Int] {
        var r = [Int]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        return r
    }
    
    fileprivate func col(index: Int) -> [Int] {
        var c = [Int]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        return c
    }
    
    fileprivate func copy(with zone: NSZone? = nil) -> Matrix {
        let m = Matrix(self.data, rows:self.rows, columns:self.columns)
        return m
    }
}

// MARK: Calculate the sum of matrix operations

func calculateSumMatrix(params: [(Matrix, Int)]) -> Matrix {
    precondition(params.count >= 3, "Minimum amount of inputted matrices is 3")
    
    let mappedItems: [Matrix] = params.map { $0.0 ^ $0.1 }
    let sum = mappedItems.reduce(Matrix(lines: mappedItems[0].rows), +)
                    
    return sum
}


// MARK: Private Matrix Operations

fileprivate func +(left: Matrix, right: Matrix) -> Matrix {
    precondition(left.rows == right.rows && left.columns == right.columns)
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] += right[row,col]
        }
    }
    return m
}

fileprivate func *(left: Matrix, right: Matrix) -> Matrix {
    let lcp = left.copy()
    let rcp = right.copy()
    
    guard lcp.columns == rcp.rows else { fatalError("These matrices cannot be multipied") }
    let dot = Matrix(rows:lcp.rows, columns:rcp.columns)
    
    for rIndex in 0..<lcp.rows {
        for cIndex in 0..<rcp.columns {
            let a = lcp.row(index: rIndex) ** rcp.col(index: cIndex)
            dot[rIndex,cIndex] = a
        }
    }
    
    return dot
}

fileprivate func ^(m: Matrix, exp: Int) -> Matrix {
    precondition(exp > 0, "Exponent should be at least 1" )
    var result = m.copy()
    for _ in 0..<exp-1 {
        result = m * result
    }
    return result
}

fileprivate typealias Vector = [Int]

infix operator **

fileprivate func **(left: Vector, right: Vector) -> Int {
    precondition(left.count == right.count)
    var d: Int = 0
    for i in 0..<left.count {
        d += left[i] * right[i]
    }
    return d
}

