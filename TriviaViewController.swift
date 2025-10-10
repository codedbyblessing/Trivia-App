//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Blessing Yeboah on 10/9/25.
//

import UIKit

class TriviaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLabelTapGestures()
        loadQuestion()
    }
    struct Question {
        let number: Int
        let topic: String
        let text: String
        let options: [String]
        let correctAnswerIndex: Int
    }
    
    @IBOutlet weak var Question_num: UILabel!
    
    @IBOutlet weak var QuestionType: UILabel!
    
    
    @IBOutlet weak var TextView: UILabel!
    @IBOutlet weak var Option1: UILabel!
    
    @IBOutlet weak var Option2: UILabel!
    
    @IBOutlet weak var Option3: UILabel!
    
    @IBOutlet weak var Option4: UILabel!
    
    @IBOutlet weak var ResetButton: UIButton!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    var currentQuestionIndex = 0
    var score = 0
    
    let questions: [Question] = [
        Question(
            number: 1,
            topic: "Pioneers in music",
            text: "Who was part of Fugees?",
            options: ["Lauryn Hill", "Whitney Houston", "Janet Jackson", "Stevie Wonder"],
            correctAnswerIndex: 0
        ),
        Question(
            number: 2,
            topic: "Pioneers in music",
            text: "Which option is a Swedish Band?",
            options: ["Coldplay", "ABBA", "Sade", "NKOTB"],
            correctAnswerIndex: 1
        ),
        Question(
            number: 3,
            topic: "Pioneers in music",
            text: "Which Beatle was famously shot in 1980?",
            options: ["John Lennon", "Paul McCartney", "George Harrison", "Ringo Starr"],
            correctAnswerIndex: 0
        ),
        Question(
            number: 4,
            topic: "Director's Cut",
            text: "Who directed the movie The Sound of Music?",
            options: ["John Ford", "John Carpenter", "Stanley Kubrick", "Robert Wise"],
            correctAnswerIndex: 3
        ),
        Question(
            number: 5,
            topic: "Director's Cut",
            text: "Who directed the movie The Godfather?",
            options: ["John Ford", "Martin Scorsese", "Francis Ford Coppola", "Stanley Kubrick"],
            correctAnswerIndex: 2
        ),
        Question(
            number: 6,
            topic: "Director's Cut",
            text: "Who directed the pilot episode of Abbott Elementary?",
            options: ["Quinta Brunson", "Ken Whittingham", "Randall Einhorn", "Spike Lee"],
            correctAnswerIndex: 2
        ),
        Question(
            number: 7,
            topic: "Bonus Topic",
            text: "Who wrote the play Othello?",
            options: ["Christopher Marlowe", "William Shakespeare", "Ben Jonson", "John Webster"],
            correctAnswerIndex: 1
        )
    ]
    

    func setupUI() {
        let labels = [Option1, Option2, Option3, Option4]
        for label in labels {
            label?.layer.cornerRadius = 0
            label?.clipsToBounds = true
            label?.backgroundColor = UIColor.white
            label?.textColor = .black
            label?.textAlignment = .center
            label?.numberOfLines = 0
            label?.isUserInteractionEnabled = true
        }
        
//        ResetButton.layer.cornerRadius = 0
//        ResetButton.clipsToBounds = true
        
        TextView.textAlignment = .center
        TextView.numberOfLines = 0
        TextView.lineBreakMode = .byWordWrapping
        TextView.adjustsFontSizeToFitWidth = true
        TextView.minimumScaleFactor = 0.5
    }
    
    func resetLabelColors() {
        [Option1, Option2, Option3, Option4].forEach { $0?.backgroundColor = .white }
        [Option1, Option2, Option3, Option4].forEach { $0?.isUserInteractionEnabled = true }
    }
    
    func loadQuestion() {
        resetLabelColors()
        guard questions.indices.contains(currentQuestionIndex) else { return }
     
        
        let question = questions[currentQuestionIndex]
        //Question_num.text = "Question (question[0].number) \(question.number)"
        Question_num.text = "Question \(currentQuestionIndex + 1) / \(questions.count)"
        QuestionType.text = question.topic
        TextView.text = question.text
        
        Option1.text = question.options[0]
        Option2.text = question.options[1]
        Option3.text = question.options[2]
        Option4.text = question.options[3]
    }
    
    
    func setupLabelTapGestures() {
        let labels = [Option1, Option2, Option3, Option4]
        for label in labels {
            guard let lbl = label else { continue }
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionLabelTapped(_:)))
            lbl.addGestureRecognizer(tap)
        }
    }
    
    @objc func optionLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let selected = label.text else { return }
        checkAnswer(selected: selected, label: label)
    }
    

    func checkAnswer(selected: String, label: UILabel) {
        guard questions.indices.contains(currentQuestionIndex) else { return }
        let question = questions[currentQuestionIndex]
        [Option1, Option2, Option3, Option4].forEach { $0?.isUserInteractionEnabled = false }
        
        if let index = question.options.firstIndex(of: selected),
           index == question.correctAnswerIndex {
            label.backgroundColor = .systemCyan
            score += 1
        } else {
            label.backgroundColor = .systemBlue
            highlightCorrectAnswer(correctIndex: question.correctAnswerIndex)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nextQuestion()
        }
    }
    
    func highlightCorrectAnswer(correctIndex: Int) {
        let labels = [Option1, Option2, Option3, Option4]
        if labels.indices.contains(correctIndex) {
            labels[correctIndex]?.backgroundColor = .systemCyan
        }
    }
    

    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            loadQuestion()
        } else {
            showFinalScore()
        }
    }
    
    func showFinalScore() {
        let alert = UIAlertController(
            title: "Game Over..",
            message: "You scored \(score) out of \(questions.count)!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "I'll play again!", style: .default, handler: { _ in
            self.resetGame()
        }))
        
        alert.addAction(UIAlertAction(title: "End game", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        score = 0
        currentQuestionIndex = 0
        loadQuestion()
    }

//    @IBAction func resetButtonTapped(_ sender: UIButton) {
//        resetGame()
//    }
}
