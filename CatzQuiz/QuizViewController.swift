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

class QuizViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var aAnswerButton: UIButton!
    @IBOutlet weak var bAnswerButton: UIButton!

    @IBOutlet var answerButtons: [UIButton]!

    @UserDefault(key: "LeaderBoard", defaultValue: []) var leaderboard: [String]

    var questions = [Question]()
    
    var timer: Timer?
    var timerCount = Int()
    let defaultTime = 5
    var score = 0
    var round = 0
    var answerTag = 1
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerSetRound()
        scoreLabel.text = String(score)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        aAnswerButton.tag = 0
        bAnswerButton.tag = 1
    }
    
    //MARK: - Timer
    
    func timerSetRound() {
        timerCount = defaultTime
        timeLabel.text = String(timerCount)
        
        if let image = UIImage(contentsOfFile: questions[round].imageURL.path) {
            setNewImageWithFade(image: image)
        }
//        catImageView.image = UIImage(contentsOfFile: questions[round].imageURL.path)
        
//        catImageView.frame = CGRect(x: 0, y: 0, width: catImageView.frame.width, height: catImageView.frame.height * 0.1) //catImageView.contentClippingRect
        
        
        for i in 0...3 {
            answerButtons[i].setTitle(questions[round].answers[i].title, for: .normal)
        }
    }
    
    @objc func updateCounter() {
        if (timerCount > 0) {
            timerCount = timerCount-1
            timeLabel.text = String(timerCount)
        } else {
            round += 1
            if round > 10 {
                timer?.invalidate()
            } else {
                timerSetRound()
            }
        }
    }
    
    var breeds = [Breed]()
    
    @IBAction func answerTapped(_ sender: UIButton) {
        if sender.tag == answerTag {
            round += 1
            if round == 10 {
                timer?.invalidate()
            } else {
                score += 1
                timerSetRound()
            }
        }
        scoreLabel.text = String(score)
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        //TODO: create new timer on resume
        timer?.invalidate()
    }
    
    func setNewImageWithFade(image: UIImage) {
        UIView.transition(with: self.catImageView,
        duration:0.5,
        options: .transitionCrossDissolve,
        animations: { self.catImageView.image = image },
        completion: nil)
    }
    
}
