//
//  LoginViewController.swift
//  frmU
//
//  Created by Lingyue Zhu on 3/25/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseFirestore
import SDWebImage

//for the first page.
class LoginViewController: UIViewController{
    @IBOutlet weak var signInButton: GIDSignInButton!

    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var welcomeCenterConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var partyupButton: UITextField!
    @IBOutlet weak var partyupButtonCenterConstraints: NSLayoutConstraint!
    
    //firebase
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }


    @IBAction func logIn(_ sender: Any) {
        if (signedIn == false) {
            welcome.text = "Sign In With Google First!"
            welcome.reloadInputViews()
        } else {
            self.getUser()
            SDWebImageManager.shared.loadImage(with: globalPICURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                globalUser.profilePic = image}

//            globalUser.createNewUser()
            performSegue(withIdentifier: "logIn", sender: sender)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        partyupButtonCenterConstraints.constant = 0
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        welcomeCenterConstraints.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 1,
                       options: [],
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        partyupButtonCenterConstraints.constant -= view.bounds.width
        welcomeCenterConstraints.constant -= view.bounds.width
    }
    
       //helper:
        //change Post to dictionary to store in firebase.
    func post2dic(post: Post, postUID: String) {
//            var dictionary : [String : Any] = [:]
//            dictionary.updateValue(post.friendSpace.uid, forKey: "type")
//            dictionary.updateValue(post.title, forKey: "title")
//            dictionary.updateValue(post.location, forKey: "location")
//            dictionary.updateValue(post.date, forKey: "date")
//            dictionary.updateValue(post.user, forKey: "user")
//            //get post's image's uuid when add.
//    //        dictionary.updateValue(<#T##value: [String]##[String]#>, forKey: "image")
//            //get userImage's uuid when add.
//    //        dictionary.updateValue(<#T##value: [String]##[String]#>, forKey: "userImage")
//            dictionary.updateValue(post.description, forKey: "description")
//            return dictionary
            let image = post.image
            
            //upload image for post.
            let storageRef = storage.reference(withPath: "postImage/\(postUID).jpg")
            guard let imageData = image?.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.putData(imageData)
            
            //upload image for post's userImage
            let storageRef2 = storage.reference(withPath: "userImage/\(globalUID).jpg")
            guard let imageData2 = globalUser.profilePic?.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetadata2 = StorageMetadata.init()
            uploadMetadata2.contentType = "image/jpeg"
            storageRef2.putData(imageData2)
            var dateDictionary = [String: String]()
            for d in post.date {
                dateDictionary.updateValue(d[1], forKey: d[0])
            }
        let data: [String: Any] = ["friendSpace": post.friendSpace.uid, "title": post.title, "location": post.location, "date": dateDictionary, "image": postUID, "user": post.user, "userImage": globalUID, "description": post.description]
            //            var ref: DocumentReference? = nil
            db.collection("Posts").document(postUID).setData(data) {err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
        }
        
        //helper change post list to a list of dictionaries.
        func postlist2dic (posts: [Post]) -> [String] {
            var uidsOfPosts: [String] = []
            for each in posts {
                let postUID = UUID.init().uuidString
                post2dic(post: each, postUID: postUID)
                uidsOfPosts.append(postUID)
            }
            print("reached 99")
            return uidsOfPosts
        }
    
    func convertTypeToHostedPosts (posts: [String : [Post]]) -> [String : [String]] {
        var dictionary = [String : [String]]()
        for (type, listPost) in posts {
            dictionary.updateValue(postlist2dic(posts: listPost), forKey: type)
        }
        return dictionary
    }
        
        func createNewUser() {
    //        globalUser = User(username: globalUSERNAME, profilePic: UIImage(named: "Alan"), uid: globalUID, friends: [], typeToPosts: [String : [Post]](), postsHosted: [], postsJoined: [])
            //above for real app
            //for testing, use fake user below
            globalUser = User(username: globalUSERNAME, profilePic: UIImage(named: "Alan"), uid: globalUID, friends: [globalUID], typeToPosts: [String : [Post]](), postsHosted: [], postsJoined: [])
            //add myFriendSpace later, now default it to something.
            let data: [String: Any] = [
                "username": globalUser.username, "uid": globalUser.uid, "friends": globalUser.friends,
                "typeToHostedPosts": convertTypeToHostedPosts(posts: globalUser.typeToHostedPosts), "postsHosted": postlist2dic(posts: globalUser.postsHosted), "postsJoined": postlist2dic(posts: globalUser.postsJoined), "myFriendSpace": [globalUser.myFriendSpace[0].uid], "profilePicURL": globalPICURL?.absoluteString]
//            var ref: DocumentReference? = nil
            db.collection("Users").document(globalUID).setData(data) {err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            print("create User success")
            //Then add each User's "My Friends" friendspace to firebase
            globalUser.myFriendSpace[0].uploadNewFriendSpace()
            
        }
        //Create User if not created in the table.
        //Get user from the user table if the user is in the table.
        func getUser() {
            
            //Fetch the User with the globalUID
            let userDocument = db.collection("Users").whereField("uid", isEqualTo: globalUID)
            userDocument.getDocuments { (userQuerySnap, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                } else {
                    
                    //count the no. of documents returned
                    guard let queryCount = userQuerySnap?.documents.count else {
                        return
                    }
                    
                    if queryCount == 0 {
                        //If documents count is zero that means there is no User available and we need to create a new instance of this user with the globalUID and globalUSERNAME.
                        self.createNewUser()
                        print("FUCKNO")
                    }
                }
                
            }
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
