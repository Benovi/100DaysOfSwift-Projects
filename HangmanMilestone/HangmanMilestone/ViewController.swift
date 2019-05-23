//
//  ViewController.swift
//  HangmanMilestone
//
//  Created by Ben Oveson on 5/23/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var wordArray = ["climb","boulder","crimps","dog","car"]
    var word: String!
    var guess = ""
    var guesses: Int!
    var guessed = 0
    var usedLetters: [String]?
    var titleWithQuestionmarks: [String] = []
    
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var guessTxtFld: UITextField!
    @IBOutlet var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegate for limiting the guessTxtFld to 1 character
        guessTxtFld.delegate = self
        
        /// Prepares the the game
        setupGame()

        
    }
    
    ///Prepares the game in an inital state
    func setupGame() {
        
        /// Loads initial properties from a random word in the array
        wordArray.shuffle()
        word = wordArray[0]
        guesses = word.count
        scoreLbl.text = "\(guesses - guessed) guesses left"
        scoreLbl.textAlignment = .center
        
        /// Resets values to blank or zero
        guessed = 0
        titleWithQuestionmarks = []
        
        /// Creates a title with question marks
        for _ in word {
            titleWithQuestionmarks.append("?")
        }
        title = titleWithQuestionmarks.joined()
        
    }
    
    /// The main logic of the game is performed when the submit button is pressed.
    @IBAction func submitPressed(_ sender: Any) {
        
        if let guess = guessTxtFld.text {
            self.guess = guess
            if checkLetter(letter: guess) {
                replaceWithCorrectLetter(letter: guess)
            } else {
                guessed += 1
            }
            checkIfWonOrLost()
            scoreLbl.text = "\(guesses - guessed) guesses left"
            guessTxtFld.text = ""
        }
  
    }
    
    /// Replaces the "?" in the title with the correct letter.
    func replaceWithCorrectLetter(letter: String) {
        
        let l = letter.lowercased()
            for (index, c) in word.enumerated() {
                if String(c) == l {
                    titleWithQuestionmarks[index] = l
                }
            }
        title = titleWithQuestionmarks.joined()
        loadView()
        
    }
    
    /// Checks to see if the player has lost or won and presents an alert to tell them. Also resets the game to its inital state.
    func checkIfWonOrLost() {
        if title == word {
            let ac = UIAlertController(title: "You Won!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default))
            present(ac, animated: true)
            setupGame()
        }
        
        if guessed == guesses {
            let ac = UIAlertController(title: "You Lost!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default))
            present(ac, animated: true)
            setupGame()
        }
    }
    
    /// Checks to see if the letter is in the word.
    func checkLetter(letter: String) -> Bool {
        let l = letter.lowercased()
        if word.contains(l) { return true } else {
            return false
        }
    }
    
    /// Limits the number of characters in the textfield.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 1
    }
    
}

