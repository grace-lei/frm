//
//  VirtualPartyViewController.swift
//  frmU
//
//  Created by Grace Lei on 3/24/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class VirtualPartyViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    var selectedType: friendSpace = globalUser.myFriendSpace[0]
    var selectedPost:Post?
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var postTableView: UITableView!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self

        postTableView.delegate = self
        postTableView.dataSource = self
        typeCollectionView.reloadData()
        postTableView.reloadData()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        typeCollectionView.reloadData()
        postTableView.reloadData()
    }
    
    //reload data. IMPLEMENTATION
    func reloadData () {
        typeCollectionView.reloadData()
        postTableView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(globalUser.myFriendSpace.count+1)
        return globalUser.myFriendSpace.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        if (index == globalUser.myFriendSpace.count) {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createNewFriendSpaceCell", for: indexPath) as? CreateNewFSCollectionViewCell {
                cell.CreateNewLabel.text = "➕"
                cell.CreateNewBackground.layer.cornerRadius = cell.CreateNewBackground.frame.width / 2
                           cell.CreateNewBackground.layer.borderWidth = 1
                           cell.CreateNewBackground.layer.masksToBounds = false
                cell.CreateNewBackground.backgroundColor = .yellow
                cell.CreateNewBackground.alpha = 0.6
                return cell

            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as? TypeCollectionViewCell {
                cell.typeLabel.text = globalUser.myFriendSpace[index].name
//
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if (index == globalUser.myFriendSpace.count) {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createNewFriendSpaceCell", for: indexPath) as? CreateNewFSCollectionViewCell {
                performSegue(withIdentifier: "toCreateNewFriendSpace", sender: cell)
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as? TypeCollectionViewCell {
                selectedType = globalUser.myFriendSpace[index]
                postTableView.reloadData()
                self.navigationItem.title = selectedType.name
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedType.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let postDisplaying = selectedType.posts[index]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell {
            cell.partyName.text = postDisplaying.title
            cell.times1 = postDisplaying.JustDateString()
            cell.hostImage.image = postDisplaying.userImage
            cell.hostName.text = postDisplaying.user
            cell.postImage.image = postDisplaying.image
            cell.descriptionLabel.text = "Descrption: \(postDisplaying.description)"
            cell.locationLabel.text = "@ \(postDisplaying.location)"
            
//            cell.joinLabel.tag = index
            
            return cell

        } else {
            return UITableViewCell()
        }
    }

    @IBAction func joinButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toVoteTime", sender: self)
    }
    
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        self.selectedPost = selectedType.posts[index]
//        performSegue(withIdentifier: "toVoteTime", sender: self.selectedPost)
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
           if let identifier = segue.identifier {
               if identifier == "toVoteTime" {
                if let dest = segue.destination as? VoteTimeViewController, let but = sender as? UIButton {
                    dest.postToJoin = selectedType.posts[but.tag]
                    globalUser.joinPosts(joinedPost: selectedType.posts[but.tag])
                   }
               }
           }
       }
}
