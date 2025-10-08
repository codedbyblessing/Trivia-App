//
//  TriviaController.swift
//  Trivia
//
//  Created by Blessing Yeboah on 10/7/25.
//

//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//
import UIKit

class TriviaController: UIViewController {
    

    @IBOutlet weak var Question_num: UILabel!
    @IBOutlet weak var topic_label: UILabel!
    @IBOutlet weak var Question_lable: UILabel!
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    
    var currentQuestionIndex = 0
    var score = 0
    
    let questions = [
        Question(
            number: 1,
            topic: "Retro Disney",
            text: "What was the first full-length animated feature released by Disney in 1937?",
            options: ["Cinderella", "Snow White and the Seven Dwarfs", "Pinocchio", "Fantasia"],
            correctAnswer: "Snow White and the Seven Dwarfs"
        ),
        Question(
            number: 2,
            topic: "Retro Disney",
            text: "What year did Disneyland first open its doors to the public?",
            options: ["1949", "1955", "1960", "1965"],
            correctAnswer: "1955"
        ),
        Question(
            number: 3,
            topic: "Retro Disney",
            text: "Which Disney film introduced the song 'When You Wish Upon a Star'?",
            options: ["Bambi", "Pinocchio", "Captain Hook", "Peter Pan"],
            correctAnswer: "Pinocchio"
        ),
        Question(
            number: 4,
            topic: "Retro Disney",
            text: "In 'Peter Pan,' what is the name of the Darling family's dog?",
            options: ["Pluto", "Nana", "Lady", "Bubbles"],
            correctAnswer: "Nana"
        ),
        Question(
            number: 5,
            topic: "Retro Disney",
            text: "What was the first Disney animated feature set in America?",
            options: ["The Fox and the Hound", "Pocahontas", "Dumbo", "The Hunchback of Notre Dame"],
            correctAnswer: "Dumbo"
        )
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        loadQuestion()
    }
    

    func setupButtons() {
        let buttons = [option1, option2, option3, option4]
        for button in buttons {
            button?.layer.cornerRadius = 10
            button?.clipsToBounds = true
            button?.backgroundColor = UIColor.systemBlue
            button?.setTitleColor(.white, for: .normal)
            button?.titleLabel?.numberOfLines = 0
            button?.titleLabel?.textAlignment = .center
        }
    }
    
    func resetButtonColors() {
        [option1, option2, option3, option4].forEach { $0?.backgroundColor = .systemBlue }
        [option1, option2, option3, option4].forEach { $0?.isEnabled = true }
    }

    func loadQuestion() {
        resetButtonColors()
        let question = questions[currentQuestionIndex]
        
        Question_num.text = "Question \(question.number)"
        topic_label.text = question.topic
        Question_lable.text = question.text
        
        option1.setTitle(question.options[0], for: .normal)
        option2.setTitle(question.options[1], for: .normal)
        option3.setTitle(question.options[2], for: .normal)
        option4.setTitle(question.options[3], for: .normal)
    }
    

    @IBAction func optionSelected(_ sender: UIButton) {
        guard let answer = sender.titleLabel?.text else { return }
        let question = questions[currentQuestionIndex]
        
   
        [option1, option2, option3, option4].forEach { $0?.isEnabled = false }
        
        if answer == question.correctAnswer {
            print("Ding!")
            sender.backgroundColor = .systemGreen
            score += 1
        } else {
            print("Errrr??")
            sender.backgroundColor = .systemRed
            highlightCorrectAnswer(correct: question.correctAnswer)
        }
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nextQuestion()
        }
    }
    
 
    func highlightCorrectAnswer(correct: String) {
        let buttons = [option1, option2, option3, option4]
        for button in buttons {
            if button?.titleLabel?.text == correct {
                button?.backgroundColor = .systemGreen
            }
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
            title: "Game Over 🎉",
            message: "You scored \(score) out of \(questions.count)!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.score = 0
            self.loadQuestion()
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

//
//private func addGradient() {
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.frame = view.bounds
//    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
//                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
//    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//    view.layer.insertSublayer(gradientLayer, at: 0)
//}
