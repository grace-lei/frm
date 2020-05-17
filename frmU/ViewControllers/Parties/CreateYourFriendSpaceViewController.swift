//
//  CreateYourFriendSpaceViewController.swift
//  frmU
//
//  Created by Grace Lei on 3/27/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class CreateYourFriendSpaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

   
    
    var imagePickerController: UIImagePickerController!
    
    var newFriendSpace = friendSpace(uid: Grace.uid, name: "PLZ NO", people: [], image: UIImage(named: "dorm"))
    
    @IBOutlet weak var image: UIImageView!
    
    
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var inviteFriends: UITableView!
    
    @IBAction func fromCameraButtonPressed(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func fromPhotosButtonPressed(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        if let t = self.name.text {
            newFriendSpace.name = t
            newFriendSpace.image = self.image.image
            newFriendSpace.uid = UUID.init().uuidString
            //implement add friends later.
            newFriendSpace.people = [globalUser.uid]
            globalUser.addFriendSpace(disfriendSpace: newFriendSpace)
            globalUser.updateUser()
            newFriendSpace.uploadNewFriendSpace()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        self.name.delegate = self
        self.image.image = UIImage(named: "default")
        super.viewDidLoad()
        inviteFriends.dataSource = self
        inviteFriends.delegate = self
        inviteFriends.allowsMultipleSelection = true
         self.imagePickerController = UIImagePickerController()
          self.imagePickerController.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              textField.resignFirstResponder()
              return true
       }
       
   private func configureTapGesture() {
       let tapGesture = UITapGestureRecognizer(target:self, action: #selector(CreateYourFriendSpaceViewController.handleTap))
       view.addGestureRecognizer(tapGesture)
   }
   
   @objc func handleTap() {
       view.endEditing(true)
   }
       
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
       let friend = globalUser.friends[index]
       if let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell {
        //implement later
//        cell.friendName.text = globalUser.useridToUser(friend).username
//        cell.friendProfileImage.image = vP.useridToUser(friend).profilePic
           return cell

       } else {
           return UITableViewCell()
       }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let index = indexPath.row
        let friend = globalUser.friends[index]
        self.newFriendSpace.addPeople(userID: friend)

        if let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .red
            cell.selectedBackgroundView = backgroundView
        }
    }
}


extension CreateYourFriendSpaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let ima = info[.originalImage] as? UIImage {
            self.image.image = ima
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
