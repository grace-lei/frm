//
//  VoteTimeViewController.swift
//  frmU
//
//  Created by Grace Lei on 3/27/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class VoteTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postToJoin: Post? = alanPost
    
    @IBOutlet weak var voteTimeTableView: UITableView!
    
    @IBOutlet weak var sendInviteButton: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

         voteTimeTableView.delegate = self
        voteTimeTableView.dataSource = self
        voteTimeTableView.allowsMultipleSelection = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = postToJoin {
            return p.date.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
       if let cell = tableView.dequeueReusableCell(withIdentifier: "voteTimeCell", for: indexPath) as? VoteTimeTableViewCell, let p = postToJoin {
        let t = p.date[index]
        cell.possibleTime.text = t[0]
        cell.currentVote.text = "current vote: \(t[1])"
           return cell

       } else {
           return UITableViewCell()
       }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let index = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: "voteTimeCell", for: indexPath) as? VoteTimeTableViewCell, let p = postToJoin {
            let nowV = Int(p.date[index][1])!
            cell.currentVote.text = "current vote: \(nowV)"
            p.date[index][1] = String(Int(p.date[index][1])!+1)
            globalUser.updateUser()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if let p = postToJoin {
            p.date[index][1] = String(Int(p.date[index][1])!-1)
            globalUser.updateUser()
        }
    }
}
