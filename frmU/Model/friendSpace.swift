//
//  friendSpace.swift
//  frmU
//
//  Created by Lingyue Zhu on 3/26/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class friendSpace {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    //uid of this friendSpace. In "Your Friends" Friend space, the uid is globalUser.uid
    var uid: String
    //name of this friendSpace
    var name: String
    //Users in this friendSpace
    var people: [String]
    //Posts in this friendSpace
    //still store posts with each User.typeToHostedPosts
    //do not upload this to firestore since we get posts from people
    var posts: [Post] = []
    //image of this friendSpace
    var image: UIImage?

    init(uid: String, name: String, people: [String], image: UIImage?) {
        self.uid = uid
        self.image = image
        self.name = name
        self.people = people
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }
    //take in user's ID and add it to this friendSpace's user list.
    func addPeople (userID: String) {
        people.append(userID)
    }
    
    //create new friend space in firestore collection: friendSpace
    //add image later.
    func uploadNewFriendSpace() {
        let data: [String: Any] = ["uid": self.uid, "name": self.name, "people": self.people
        ]
        db.collection("friendSpace").document(self.uid).setData(data) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        let storageRef = storage.reference(withPath: "friendSpaceImage/\(self.uid).jpg")
        guard let imageData = self.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData)
    }
    
    //after calling refreshData, create ThisFriendSpace with the given strings. So we have a friendSpace with the correct uid. Then call this function to update all other information correctly. Including image. Then fill posts with the correct stuff.
    func refreshNewFriendSpace() {
        //Get data from friendSpace collection
        let docRef = db.collection("friendSpace").whereField("uid", isEqualTo: uid)
        docRef.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            if ((querySnapshot?.documents.count)! > 1) {
                print("FUCK! More than one User")
            }
        for document in querySnapshot!.documents {
            self.name = document.data()["name"] as! String
            self.people = document.data()["people"] as! [String]
            }
        }
        for each in self.people {
            self.getPersonPost(uid: each)
//            if postsList.count > 0 {
//                print("FUCK HAVE POST")
//                for i in postsList {
//                    self.addPost(post: i)
//                    print("ADDED: \(i.title) + 100000")
//                }
//            } else {
//                continue
//            }
        }
            self.storage.reference(withPath: "friendSpaceImage/\(self.uid).jpg").getData(maxSize: 4 * 1024 * 1024) {
            (data, error) in
            if error != nil {
                print("No Picture error")
                print("No What? : \(error)")
            }
            if let data = data {
                let Thisimage = UIImage(data: data)
                self.image = Thisimage
                }
            }
        }
        //get picture for the place.
    }
    
    
    //get each person's postList in this friendSpace type.
    func getPersonPost(uid: String) -> [Post] {
        var ThisTypeToHostedPosts = [String : [String]]()
        var postsList: [Post] = []
        let docRef = db.collection("Users").whereField("uid", isEqualTo: uid)
        docRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if ((querySnapshot?.documents.count)! > 1) {
                    print("FUCK! More than one User")
                }
                for document in querySnapshot!.documents {
                    ThisTypeToHostedPosts = document.data()["typeToHostedPosts"] as! [String : [String]]
                   }
                }
                let actualTypeToPosts = backTypeToHostedPosts(tthp: ThisTypeToHostedPosts)
            //        if let havePosts = actualTypeToPosts[self.uid] {
            //            postsList = havePosts
            //        } else {
            //            print("No Posts for this friend space")
            //            print(self.uid)
            //            postsList = []
            //        }
                    for (type, posts) in actualTypeToPosts {
                        if type == self.uid {
                            postsList = posts
                            for i in posts {
                                self.addPost(post: i)
                                print("HUGECOCK: \(i.description)")
                            }
                            print("Have type:")
                            print(type)
                            print(posts[0].title)
                        } else {
                            print("What type?")
                            print(type)
                        }
                    }

        }
        return postsList
    }
    
}
