//
//  QuizViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

struct Answer {
    let title: String
    let isRight: Bool
}

struct Size {
    let width: Int
    let height: Int
}

struct Question {
    let imageURL: URL
    let answers: [Answer]
    let imageSize: Size
}

struct Leaderboard: Codable {
    let name: String
    let score: Int
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseView: UIView!
    
    lazy var dateFormatter = DateFormatter()
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @UserDefault(key: "leaderBoard", defaultValue: []) var leaderboard: [Leaderboard]
    
    var questions = [Question]()
    
    var timer: Timer?
    var timerCount = Int()
    let defaultTime = 5
    var score = 0
    var round = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerSetRound()
        scoreLabel.text = String(score)
        
        pauseView.layer.cornerRadius = 10
        catImageView.layer.cornerRadius = 5
        catImageView.clipsToBounds = true
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let next = segue.destination as? GuideViewController {
            next.navigationItem.hidesBackButton = true
            next.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(backToMenu))
        }
    }
    
    @objc func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func rightAnswer() -> String {
        let questionsArr = questions[round]
        var answer = String()
        for i in 0...3 {
            if questionsArr.answers[i].isRight == true {
                answer = questionsArr.answers[i].title
            }
        }
        return answer
    }
    
    func showGameOverAlert() {
        let title = alertTitle()
        
        if self.score != 0 {
            let alert = UIAlertController(title: title, message: "Enter your name", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input your name here..."
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                if let name = alert.textFields?.first?.text {
                    print("Your name: \(name)")
                    if name != "" {
                        self.leaderboard.append( Leaderboard(name: name, score: self.score) )
                        self.leaderboard = self.leaderboard.sorted() {$0.score > $1.score }
                        self.performSegueToLeaderboard()
                    } else {
                        let errorAlert = UIAlertController(title: "Name can't be empty", message: nil, preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                            self!.present(alert, animated: true)
                        }))
                        self.present(errorAlert, animated: true)
                    }
                }
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Ooops you've got 0 points", message: "Maybe try to read guide?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Guide", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.performSegueToGuide()
            }))
            alert.addAction(UIAlertAction(title: "Leaderboard", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.performSegueToLeaderboard()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func alertTitle() -> String {
        var title = String()
        if score >= 80 {
            title = "Are u Kuklachev? \(score) points!"
        } else if score >= 50 {
            title = "Awesome! You've got \(score) points"
        } else if score >= 30 {
            title = "Good job! You've got \(score) points"
        } else if score >= 10 {
            title = "You've got \(score) points. Try reading guide!"
        }
        return title
    }
    
    func performSegueToLeaderboard() {
        performSegue(withIdentifier: "LeaderboardSeague", sender: self)
    }
    
    func performSegueToGuide() {
        performSegue(withIdentifier: "GuideSegue", sender: self)
    }
    
    func gameOver() {
        print("game over")
        timer?.invalidate()
        showGameOverAlert()
    }
    
    @IBAction func onMenu(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setNewImageWithFade(image: UIImage) {
        UIView.transition(with: self.catImageView,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.catImageView.image = image },
                          completion: nil)
    }
    
    private func date() -> String {
        dateFormatter.dateFormat = "dd MMMM, HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    //MARK: - Timer
    
    func timerSetRound() {
        let bgColor = UIColor.randomLight()
        let buttonsColor = bgColor.inverse()
        view.backgroundColor = bgColor
        answerButtons.forEach({ $0.setTitleColor(buttonsColor, for: .normal) })
        
        print(rightAnswer())
    
        timerCount = defaultTime
        timeLabel.text = String(timerCount)
        
        if let image = UIImage(contentsOfFile: questions[round].imageURL.path) {
            setNewImageWithFade(image: image)
        }
        
        for i in 0...3 {
            answerButtons[i].setTitle(questions[round].answers[i].title, for: .normal)
        }
    }
    
    @objc func updateCounter() {
        if (timerCount > 0) {
            timerCount = timerCount-1
            timeLabel.text = String(timerCount)
        } else {
            if round > 8 {
                gameOver()
            } else {
                round += 1
                timerSetRound()
            }
        }
            
    }
    
    @IBAction func answerTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == rightAnswer() {
            score += 10
        }
        round += 1
        if round > 9 {
            gameOver()
        } else {
            timerSetRound()
        }
        scoreLabel.text = String(score)
    }
    
    @IBAction func onPause(_ sender: Any) {
        
        pauseView.isHidden = false
        timer?.invalidate()
        for button in answerButtons {
            button.isUserInteractionEnabled = false
        }
    }
    @IBAction func onResume(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        pauseView.isHidden = true
        for button in answerButtons {
            button.isUserInteractionEnabled = true
        }
    }
}
