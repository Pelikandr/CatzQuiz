//
//  ViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 15/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        navigationController?.setNavigationBarHidden(true, animated: animated)
        enableView()
        progressView.isHidden = true
        
        let bgColor = UIColor.randomLight()
        let buttonsColor = bgColor.inverse()
        view.backgroundColor = bgColor
        [playButton, learnButton, leaderboardButton].forEach({ $0.setTitleColor(buttonsColor, for: .normal) })
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.clearCache()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if let next = segue.destination as? QuizViewController {
            next.questions = questions
        }
    }
    
    @IBAction func onLearn(_ sender: Any) {
    }
    
    @IBAction func onPlay(_ sender: Any) {
        progressView.progress = 0
        progressView.isHidden = false
        disableView()
        questions.removeAll()
        prepareGameData()
    }
        
    // MARK: - Private
    
    private var questions = [Question]()
    
    private func prepareGameData() {
        getAllBreeds { [weak self] (breeds: [Breed]) in
            guard let self = self else { return }
            self.updateProgress()
            
            var allAnswers = [[Breed]]()
            for _ in 0..<10 {
                var answers = [Breed]()
                var breedsCopy = breeds
                for _ in 0..<4 {
                    let randInd = Int.random(in: 0..<breedsCopy.count)
                    answers.append(breedsCopy[randInd])
                    breedsCopy.remove(at: randInd)
                }
                allAnswers.append(answers)
            }
            self.generateQuestions(with: allAnswers)
        }
    }
    
    private func generateQuestions(with allAnswers: [[Breed]]) {
        let dispatchGroup = DispatchGroup()
        for answers in allAnswers {
            let rightIndex = Int.random(in: 0..<answers.count)
            let rightBreedID = answers[rightIndex].id
            var resAnswers = [Answer]()
            for i in 0..<answers.count {
                let breed = answers[i]
                resAnswers.append(Answer(title: breed.name, isRight: i==rightIndex))
            }
            dispatchGroup.enter()
            getImage(with: rightBreedID) { [weak self] (image: CatImage) in
                self?.updateProgress()
                
                self?.saveImage(with: image.url) { [weak self] (localURL: URL) in
                    self?.updateProgress()
                    let question = Question(imageURL: localURL, answers: resAnswers, imageSize: Size(width: image.width, height: image.height))
                    self?.questions.append(question)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.playGame()
        }
    }
    
    private func updateProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress += 0.04
        }
    }
    
    private func playGame() {
        progressView.progress = 1
        performSegue(withIdentifier: "PlayQuizSegue", sender: self)
    }
    
    private func getAllBreeds(completion: (([Breed]) -> Void)?) {
        Network.shared.getAllBreeds { (error: Error?, data: [Breed]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let data = data {
                completion?(data)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    private func getImage(with breedID: String, completion: ((CatImage) -> Void)?) {
        Network.shared.getImage(with: breedID) { (error: Error?, image: [CatImage]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let image = image?.first {
                completion?(image)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    private func saveImage(with url: String, completion: ((URL) -> Void)?) {
        Network.shared.saveImage(from: url) { (error: Error?, localURL: URL?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let localURL = localURL {
                completion?(localURL)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    private func disableView() {
        learnButton.isEnabled = false
        playButton.isEnabled = false
        leaderboardButton.isEnabled = false
    }
    
    private func enableView() {
        learnButton.isEnabled = true
        playButton.isEnabled = true
        leaderboardButton.isEnabled = true
    }
    
    private func clearCache() {
        if let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory( at: path, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    do {
                        try FileManager.default.removeItem(at: file)
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
}

