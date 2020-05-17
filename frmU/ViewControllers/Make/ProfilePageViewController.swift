//
//  ProfilePageViewController.swift
//  frmU
//
//  Created by Grace Lei on 3/25/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myUsername: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        //
    }
    
    @IBAction func myFriendsButtonPressed(_ sender: Any) {
        //
    }
    
    @IBOutlet weak var eventsHostedTableView: UITableView!
    
    
    @IBOutlet weak var eventsJoinedTableView: UITableView!
    
    
    @IBAction func finalizeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "finalize", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if let identifier = segue.identifier {
            if identifier == "finalize" {
             if let dest = segue.destination as? FinalizeDateViewController, let but = sender as? UIButton {
                dest.chosenPost = globalUser.postsHosted[but.tag]
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.image = globalUser.profilePic
        myUsername.text = globalUser.username
        eventsHostedTableView.delegate = self
        eventsHostedTableView.dataSource = self
       
        eventsJoinedTableView.delegate = self
        eventsJoinedTableView.dataSource = self
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventsHostedTableView.reloadData()
        eventsJoinedTableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
    
    //this function is temporary for checking.
    @IBAction func myFriends(_ sender: Any) {
        print("--------myFriends PRESSED--------")
        print("Check Global User: ---------------")
        print("myfriendSpace #: \(globalUser.myFriendSpace.count)")
        print("First FriendSpace: \(globalUser.myFriendSpace[0].uid)")
        print("Second FriendSpace: \(globalUser.myFriendSpace[1].uid)")
        print("PostTypeToSomething: \(globalUser.typeToHostedPosts.keys)")
        let myPost = globalUser.typeToHostedPosts["05F91593-EC45-4E39-9ECC-8904715ADAB9"]?[0]
        print("PostToDisplay: \(myPost?.title)")
        print("myFriendSpaceValue: \(globalUser.myFriendSpace[1].posts.count) or \(globalUser.myFriendSpace[0].posts.count)")
        print("ExtraPeople: \(globalUser.myFriendSpace[1].people) + \(globalUser.myFriendSpace[0].people)")
        print("Extra: \(globalUser.myFriendSpace[1].name) or \(globalUser.myFriendSpace[0].name)")
        print()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == eventsHostedTableView {
            return globalUser.postsHosted.count
        } else {
            return globalUser.postsJoined.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        switch tableView {
        case eventsJoinedTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventsJoinedCell", for: indexPath) as? EventsJoinedTableViewCell {
                 let index = indexPath.item
                cell.partyNameLabel.text = globalUser.postsJoined[index].title
                if globalUser.postsJoined[index].date.count == 1 {
                    cell.partyTimeLabel.text = "Time: " +  globalUser.postsJoined[index].date[0][0]
                } else {
                    cell.partyTimeLabel.text = "Time: TBD"
                }
                cellToReturn = cell
                }
            
        case eventsHostedTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventsHostedCell", for: indexPath) as? EventsHostedTableViewCell {
                     let index = indexPath.item
                cell.partyNameLabel.text = globalUser.postsHosted[index].title
                if globalUser.postsHosted[index].date.count == 1 {
                    cell.partyTimeLabel.text = "Time: " +  globalUser.postsHosted[index].date[0][0]
                } else {
                    cell.partyTimeLabel.text = "Time: TBD"
                }
                cellToReturn = cell


            }
        default:
            return cellToReturn
        }
        return cellToReturn
    }
    
    @IBAction func logOut(_ sender: Any) {
        print(globalUser.username)
        GIDSignIn.sharedInstance()?.signOut()
        signedIn = false
        performSegue(withIdentifier: "logout", sender: sender)
    }
    
    
    
}
