//
//  LeaderboardAdapter.swift
//  CatzQuiz
//
//  Created by pelikandr on 21/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var leaderboard = [Leaderboard]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        let text = ("Score: \(leaderboard[indexPath.row].score) \t Date: \(leaderboard[indexPath.row].date)")
        cell.textLabel?.text = text
        return cell
    }
    
}
