//
//  Leaderboard.swift
//  CatzQuiz
//
//  Created by pelikandr on 21/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation
import UIKit

class LeaderBoardViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let adapter = LeaderboardAdapter()
    
    @UserDefault(key: "leaderBoard", defaultValue: []) var leaderboard: [Leaderboard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = adapter
        tableView.dataSource = adapter

        view.backgroundColor = UIColor.randomLight()
        tableView.backgroundColor = view.backgroundColor
        
        adapter.leaderboard = leaderboard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(backToMenu))
    }
    
    @objc func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onMenu(_ sender: Any) {
        let superview = self.presentingViewController
        self.dismiss(animated: true) { [weak wSuperview = superview] in
            wSuperview?.dismiss(animated: true, completion: nil)
        }
    }
}
