//
//  ViewController.swift
//  Project2
//
//  Created by Rahul on 5/9/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var countries: [String] = []
    
    var questionsAsked: Int = 0
    
    var correctAnswer = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "UK", "USA"]

        askQuestion()
        
    }
    
    func askQuestion() {
        
        if questionsAsked >= 10 {
            
            showGameOverAlert()
            
            let defaults = UserDefaults.standard
            
            if let previousHighScore = defaults.object(forKey: "highScore") as? Int {
                if score > previousHighScore {
                    saveScore()
                    showNewHighScoreAlert()
                }
            } else {
                saveScore()
            }
            
            return
        }
        
        questionsAsked += 1
        
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased()
        
        button1.setBackgroundImage(UIImage(named: countries[0]), for: .normal)
        button2.setBackgroundImage(UIImage(named: countries[1]), for: .normal)
        button3.setBackgroundImage(UIImage(named: countries[2]), for: .normal)
        
    }
    
    @IBAction func didTapCountryFlag(_ sender: UIButton) {
        
        var title: String
        var message: String = ""
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            message += "This was flag of \(countries[sender.tag].uppercased())! "
        }
        
        message += "Your score is \(score)."
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default) { _ in
            self.askQuestion()
        }
        
        ac.addAction(action)
        
        present(ac, animated: true)
        
    }
    
    @IBAction func didTapShowScoreButton() {
        let title = "Your score is \(score)."
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default)
        ac.addAction(action)
        
        present(ac, animated: true)
    }
    
    func saveScore() {
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "All 10 questions have been asked", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showNewHighScoreAlert() {
        let alert = UIAlertController(title: "New High Score!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yay!", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }

}

