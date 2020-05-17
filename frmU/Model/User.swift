//
//  Account.swift
//  frmU
//
//  Created by Lingyue Zhu on 3/24/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


class User {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    //Get username from Google account Name?
    //name to display on virtual parties.
    var username: String
    //posts are each users' post in a list of posts.
    //The virtual parties interface will access this later.
    var profilePic: UIImage?
    
    //each account has an uid.
    var uid: String
    //friends be list of uids.
    var friends: [String]
    
    // Map post categories to corresponding hosted posts.
    // If the post
    // Store posts here.
    var typeToHostedPosts: [String : [Post]]
    
    var postsHosted: [Post]
    
    var postsJoined: [Post]
    
    var myFriendSpace: [friendSpace]
    
    init(username: String, profilePic: UIImage?, uid: String, friends: [String], typeToPosts: [String : [Post]], postsHosted: [Post], postsJoined: [Post]) {
        self.username = username
        self.profilePic = profilePic
        self.uid = uid
        self.friends = friends
        self.typeToHostedPosts = typeToPosts
        self.postsHosted = postsHosted
        self.postsJoined = postsJoined
        //When add friends, makesure update this friendSpace's friend.
        self.myFriendSpace = [friendSpace(uid: self.uid, name: "My Friends", people: self.friends, image: self.profilePic)]
    }
    
    //func to add friendspace
    func addFriendSpace(disfriendSpace: friendSpace) {
        myFriendSpace.append(disfriendSpace)
    }
    
    //function to join posts
    func joinPosts (joinedPost: Post) {
        self.postsJoined.append(joinedPost)
        updateUser()
    }
    
    // return friends of self
    func getFriends() -> [User] {
        if uid == "12AB" {
            return [Grace]
        } else if uid == "99BA" {
            return [Alan]
        }
        return []
    }
    
    // return all posts of given type
    func allPostsOfType(type: String) -> [Post] {
        var posts : [Post] = []
        if let p = self.typeToHostedPosts[type] {
            for i in p {
                posts.append(i)
            }
        }

        for f in getFriends() {
            if let p = f.typeToHostedPosts[type] {
                for i in p {
                    posts.append(i)
                }
            }
        }
        return posts
    }
    
    //gurantteed: The user is already in the collection.
    //access the user and change data.
    func updateUser() {
        let userRef = db.collection("Users").document(globalUID)
        var fsLIST: [String] = []
        for i in self.myFriendSpace {
            fsLIST.append(i.uid)
        }
        userRef.updateData(["username": self.username, "uid": self.uid, "friends": self.friends,
        "typeToHostedPosts": convertTypeToHostedPosts(posts: self.typeToHostedPosts), "postsHosted": postlist2dic(posts: self.postsHosted), "postsJoined": postlist2dic(posts: self.postsJoined), "myFriendSpace": fsLIST, "profilePicURL": globalPICURL?.absoluteString
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //helper:
            //change Post to dictionary to store in firebase.
        func post2dic(post: Post, postUID: String) {
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
                return uidsOfPosts
            }
        
        func convertTypeToHostedPosts (posts: [String : [Post]]) -> [String : [String]] {
            var dictionary = [String : [String]]()
            for (type, listPost) in posts {
                dictionary.updateValue(postlist2dic(posts: listPost), forKey: type)
            }
            return dictionary
        }
}
