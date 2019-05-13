//
//  ViewController.swift
//  Project8
//
//  Created by Rahul Sharma on 5/12/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    
    var currentAnswerTextField: UITextField!
    
    var letterButtons: [UIButton] = []
    var tappedButtons: [UIButton] = []
    
    var solutions: [String] = []
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var correctlyAnsweredQuestions = 0
    
    var level = 1
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswerTextField = UITextField()
        currentAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        currentAnswerTextField.placeholder = "Tap letters to guess"
        currentAnswerTextField.textAlignment = .center
        currentAnswerTextField.font = UIFont.systemFont(ofSize: 44)
        currentAnswerTextField.isUserInteractionEnabled = false
        view.addSubview(currentAnswerTextField)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswerTextField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswerTextField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            submit.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                letterButton.setTitle("WWW", for: .normal)
                
                letterButton.addTarget(self, action: #selector(didTapLetterButton), for: .touchUpInside)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func didTapSubmitButton(_ sender: UIButton) {
        
        guard let answerText = currentAnswerTextField.text else { return }
        
        if let index = solutions.firstIndex(of: answerText) {
            
            tappedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[index] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswerTextField.text = ""
            
            score += 1
            correctlyAnsweredQuestions += 1
            
            if correctlyAnsweredQuestions.isMultiple(of: 7) {
                showNextLevelAlert()
            }
            
        } else {
            score -= 1
            
            currentAnswerTextField.text = ""
            
            for button in tappedButtons {
                button.isHidden = false
            }
            
            tappedButtons.removeAll()
            
            showIncorrectAnswerAlert()
        }
        
    }
    
    @objc func didTapClearButton() {
        
        currentAnswerTextField.text = ""
        
        for button in tappedButtons {
            button.isHidden = false
        }
        
        tappedButtons.removeAll()
    }
    
    @objc func didTapLetterButton(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        currentAnswerTextField.text = currentAnswerTextField.text?.appending(text)
        
        tappedButtons.append(sender)
        
        sender.isHidden = true
    }
    
    func levelUp(action: UIAlertAction) {

        level += 1
        
        for button in letterButtons {
            button.isHidden = false
        }
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
    }

    func loadLevel() {
        
        var cluesString = ""
        var answersString = ""
        var letterBits: [String] = []
        
        guard let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            return
        }
        
        let levelContents = try! String(contentsOf: url)
        
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        
        for (index, line) in lines.enumerated() {
            
            let parts = line.components(separatedBy: ": ")
            
            let answer = parts[0]
            
            let clue = parts[1]
            
            cluesString += "\(index + 1). " + clue + "\n"
            
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            answersString += "\(solutionWord.count) letters\n"
            solutions.append(solutionWord)
            
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
            
        }
        
        cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = answersString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        for index in 0..<letterButtons.count {
            letterButtons[index].setTitle(letterBits[index], for: .normal)
        }
        
    }
    
    func showNextLevelAlert() {
        let alert = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's go!", style: .default, handler: levelUp)
        
        alert.addAction(action)
        present(alert, animated: true)
    }

    func showIncorrectAnswerAlert() {
        let alert = UIAlertController(title: "Incorrect", message: "That word is not in the list.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

