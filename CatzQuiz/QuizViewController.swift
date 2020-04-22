//
//  QuizViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

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
    let date: String
    let score: Int
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var aAnswerButton: UIButton!
    @IBOutlet weak var bAnswerButton: UIButton!
    
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
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        clearCache()
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
    
    
    func gameOver() {
        print("game over")
        timer?.invalidate()
        leaderboard.append( Leaderboard(date: date(), score: score) )
        leaderboard = leaderboard.sorted() {$0.score > $1.score }
        performSegue(withIdentifier: "LeaderboardSeague", sender: self)
    }
    
    func setNewImageWithFade(image: UIImage) {
        UIView.transition(with: self.catImageView,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.catImageView.image = image },
                          completion: nil)
    }
    
    func clearCache(){
        if let path = URL(string: NSTemporaryDirectory()) {
            let fileManager = FileManager.default
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory( at: path, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    do {
                        try fileManager.removeItem(at: file)
                    }
                    catch let error as NSError {
                        debugPrint("ERROR: \(error)")
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
//        if let next = segue.destination as? LeaderBoardViewController {
//            next.leaderboard = leaderboard
//        }
    }
    
    private func date() -> String {
        dateFormatter.dateFormat = "dd MMMM, HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    //MARK: - Timer
    
    func timerSetRound() {
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
            if round > 9 {
                gameOver()
            } else {
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
    
    @IBAction func pausePressed(_ sender: Any) {
        //TODO: create new timer on resume
        timer?.invalidate()
    }
}
