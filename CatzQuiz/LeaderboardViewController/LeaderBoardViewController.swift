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
    
    var leaderboard = [Leaderboard]()
    private let adapter = LeaderboardAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = adapter
        tableView.dataSource = adapter
        
        if let data = UserDefaults.standard.object(forKey: "leaderBoard") as? Data {
            leaderboard = (try! PropertyListDecoder().decode([Leaderboard].self, from: data))
        }
        adapter.leaderboard = leaderboard
    }
}
