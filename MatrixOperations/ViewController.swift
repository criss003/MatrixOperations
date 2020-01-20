//
//  ViewController.swift
//  NoblyTest
//
//  Created by Criss on 11/29/19.
//  Copyright © 2019 Criss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        displayMatrix()
    }
    
    func displayMatrix() {
        let A = Matrix([1, 2, 3, 4, 5, 6, 7, 8, 9])
        let B = Matrix([1, 1, 0, 0, 1, 1, 1, 0, 1])
        let C = Matrix([1, -2, -3, -1, -1, -1, 2, 2, -1])
        let AExp = 3
        let BExp = 3
        let CExp = 3
        
        // Move to a background thread to do matrix operations
        DispatchQueue.global(qos: .userInitiated).async {
            let params = [(A, AExp), (B, BExp), (C, CExp)]
            let sum = calculateSumMatrix(params: params)
            
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.resultLabel.text = "A =\n \(A) \n" +
                "B =\n \(B) \n" +
                "C =\n \(C) \n" +
                "AExp = \(AExp) \n" +
                "BExp = \(BExp) \n" +
                "CExp = \(CExp) \n" +
                "\nA^\(AExp)+B^\(BExp)+C^\(CExp) =\n \(sum.description)"
            }
        }
    }
}

