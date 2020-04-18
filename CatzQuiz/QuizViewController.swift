//
//  QuizViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

//struct Answer {
//    let title: String
//    let isRight: Bool
//}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var aAnswerButton: UIButton!
    @IBOutlet weak var bAnswerButton: UIButton!
    
    let network = Network()
    
    var timer: Timer?
    var timerCount = Int()
    let defaultTime = 5
    var score = 0
    //    var answer = "lel2"
    var answerTag = 1
    
    //    var answersArr = [Answer(title: "lel1", isRight: false), Answer(title: "lel2", isRight: true)]//, Answer(title: "lel3", isRight: false), Answer(title: "lel4", isRight: false)]
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerCount = defaultTime
        scoreLabel.text = String(score)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        aAnswerButton.tag = 0
        bAnswerButton.tag = 1
        
    }
    
    //MARK: - Timer
    
    func timerSetDefaultTime() {
        timerCount = defaultTime
        timeLabel.text = String(timerCount)
    }
    
    @objc func updateCounter() {
        if(timerCount > 0) {
            timerCount = timerCount-1
            timeLabel.text = String(timerCount)
        } else {
            timerSetDefaultTime()
        }
    }
    
    var breeds = [Breed]()
    
    @IBAction func answerTapped(_ sender: UIButton) {
//        network.getBreeds() { (breeds) in
//            print("BREEDS IDs\(breeds)")
//        }
        
        network.getImagesFullInfo() { (breeds) in
            print("BREEDS \(breeds)")
        }
        
//        let url = URL(string: "https://cdn2.thecatapi.com/images/IOjBCPLXA.jpg")!
//        network.getImage(from: url) { [weak self] data, response, error in
//            guard let `self` = self else { return }
//
//            guard let data = data, error == nil else { return }
//            DispatchQueue.main.async() {
//                self.catImageView.image = UIImage(data: data)
//            }
//        }
        
        if sender.tag == answerTag {
            score += 1
            timerSetDefaultTime()
        }
        scoreLabel.text = String(score)
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        //TODO: create new timer on resume
        timer?.invalidate()
    }
    
}
