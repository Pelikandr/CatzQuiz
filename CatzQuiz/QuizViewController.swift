//
//  QuizViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer?
    var timerCount = Int()
    let defaultTime = 5
    
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerCount = defaultTime
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateCounter() {
        if(timerCount > 0) {
            timerCount = timerCount-1
            timeLabel.text = String(timerCount)
        } else {
            timerCount = defaultTime
            timeLabel.text = String(timerCount)
        }
    }
    
    @IBAction func pausePressed(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
