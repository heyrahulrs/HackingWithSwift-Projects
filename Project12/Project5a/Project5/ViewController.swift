//
//  ViewController.swift
//  Project5
//
//  Created by Rahul on 5/11/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords: [String] = []
    var usedWords: [String] = []
    
    var currentWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(startGame))
        
        if let path = Bundle.main.path(forResource: "start", ofType: "txt") {
            let words = try! String(contentsOfFile: path)
            allWords = words.components(separatedBy: "\n")
        }else{
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        
        if let previousWord = defaults.object(forKey: "currentWord") as? String {
            title = previousWord
            if let previouslyUsedWords = defaults.object(forKey: "usedWords") as? [String] {
                usedWords = previouslyUsedWords
            }
        } else {
            startGame()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        usedWords.removeAll()
        tableView.reloadData()
        currentWord = allWords.randomElement()
        title = currentWord
        saveCurrentWord()
    }
    
    func submit(_ answer: String) {
        
        let lowercasedAnswer = answer.lowercased()
        
        var errorTitle: String
        var errorMessage: String
        
        if isPossible(word: lowercasedAnswer) {
            if isOriginal(word: lowercasedAnswer) {
                if isReal(word: lowercasedAnswer) {
                    
                    usedWords.insert(answer.lowercased(), at: 0)
                    
                    let indexPath = IndexPath(item: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    saveUsedWords()
    
                    return
                    
                }else{
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            }else{
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        }else{
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        }
        
        showAlert(title: errorTitle, message: errorMessage)
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        guard word.count >= 3 else { return false }
        guard word.lowercased() != title!.lowercased() else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc func didTapAddButton() {
        let alert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    func saveCurrentWord() {
        let defaults = UserDefaults.standard
        guard let currentWord = currentWord else { return }
        defaults.set(currentWord, forKey: "currentWord")
    }
    
    func saveUsedWords() {
        let defaults = UserDefaults.standard
        defaults.set(usedWords, forKey: "usedWords")
    }
    
}

