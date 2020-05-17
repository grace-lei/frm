//
//  PartyData.swift
//  frmU
//
//  Created by Lingyue Zhu on 3/24/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseFirestore
import SDWebImage


//Create a struck that stores the INFO for each made party.
class Post {
    //type is the uid of the workspace the posts belong to.
    var friendSpace: friendSpace
    // Title to display.
    var title: String
    // a string saying the location
    var location: String
    // List of Data objects in the collection view
    //* If Data pass current Date, delete the event. (new page)
    var date: [[String]]
    //image the user uploaded, else default type.
    var image: UIImage?
    //username: Get from User.username
    var user: String
    //profile picture. Get from User.profilePic
    var userImage: UIImage?
    // a string saying the description. Get from User.posts
    var description: String
    
    init(friendSpace: friendSpace, title: String, location: String, date: [[String]], image: UIImage?, user: String, userImage: UIImage?, description: String) {
        self.friendSpace = friendSpace
        self.title = title
        self.location = location
        self.date = date
        self.image = image
        self.user = user
        self.userImage = userImage
        self.description = description
        self.friendSpace.addPost(post: self)
    }
    
    func voteTime(Chosendate: String) {
        for i in 0..<date.count {
            if self.date[i][0] == Chosendate {
                var num = Int(date[i][1])!
                num += 1
                self.date[i][1] = "\(num)"
            }
        }
    }
    
    func JustDateString() -> [String] {
        var DateString:[String] = []
        for i in self.date {
            let getDateStr = i[0]
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yy HH:mm"
            let showDate = inputFormatter.date(from: i[0])
            inputFormatter.dateFormat = "MM-dd,HH:mm"
            let resultString = inputFormatter.string(from: showDate!)
            DateString.append(resultString)
        }
        return DateString
    }
    
    //Choose the final Date
    func finalizeDate(Chosendate: String) {
        var newDateList: [[String]] = []
        for i in self.date {
            if i[0] == Chosendate {
                newDateList.append(i)
            }
        }
        self.date = newDateList
        
    }
    
}




//construct fake user Alan for testing.

//test I can see my Post
// all tests below, ignore them.

let dum = Post(friendSpace: Berkeley, title: "movie Party" , location: "Google Hangout", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "movies"), user: "lucy", userImage: UIImage(named: "lucy"), description: "ZOOM Cinema")

let lucyPost = Post(friendSpace: Berkeley, title: "movie Party" , location: "Google Hangout", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "movies"), user: "lucy", userImage: UIImage(named: "lucy"), description: "ZOOM Cinema")



let gracePost = Post(friendSpace: Unit1, title: "game night" , location: "Google Hangout", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "game"), user: "grace", userImage: UIImage(named: "grace"), description: "lets have fun gaming")
let alanPost = Post(friendSpace: CS170, title: "CS170 HW Party" , location: "Zoom", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "dorm"), user: "alan", userImage: UIImage(named: "Alan"), description: "Let's finish MT2 take home exam together!")
let pp1 = Post(friendSpace: CS170, title: "CS170 HW Party2" , location: "Zoom", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "hw"), user: "jerry", userImage: UIImage(named: "alan"), description: "cs170 MT study no")

let pp2 = Post(friendSpace: toppa, title: "CS170 HW Party" , location: "Zoom", date:[["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "hw"), user: "tom", userImage: UIImage(named: "alan"), description: "cs170 MT study yes")

let pp3 = Post(friendSpace: DSC, title: "CS170 HW Party" , location: "Zoom", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "hw"), user: "amy", userImage: UIImage(named: "alan"), description: "cs170 MT study yes")

let pp4 = Post(friendSpace: blockchain, title: "CS170 HW Party" , location: "Zoom", date: [["2/3 4pm", "1"], ["2/3 5am", "3"], ["2/26 7pm", "2"], ["2/23 3pm", "5"]], image: UIImage(named: "hw"), user: "selina", userImage: UIImage(named: "lucy"), description: "blockchain")



var dum2 = User(username: "grace", profilePic: UIImage(named: "grace"), uid: "99BA", friends: ["12AB"], typeToPosts:["Unit 1" : [gracePost]], postsHosted: [gracePost], postsJoined: [lucyPost])

var Grace = User(username: "grace", profilePic: UIImage(named: "grace"), uid: "grace", friends: ["alan", "selina"], typeToPosts:["Unit 1" : [gracePost]], postsHosted: [gracePost], postsJoined: [lucyPost])

var Alan = User(username: "alan", profilePic: UIImage(named: "Alan"), uid: "alan", friends: ["grace", "tom", "amy", "jerry", "selina"], typeToPosts: ["CS170" : [alanPost]], postsHosted: [alanPost], postsJoined: [gracePost])

var Amy = User(username: "amy", profilePic: UIImage(named: "Alan"), uid: "amy", friends: ["tom", "jerry", "alan"], typeToPosts: ["CS170" : [alanPost]], postsHosted: [pp3], postsJoined: [gracePost])
var Selina = User(username: "selina", profilePic: UIImage(named: "Alan"), uid: "selina", friends: ["tom", "alan"], typeToPosts: ["CS170" : [alanPost]], postsHosted: [pp4], postsJoined: [alanPost])
var Tom = User(username: "tom", profilePic: UIImage(named: "Alan"), uid: "tom", friends: ["alan","selina", "amy"], typeToPosts: ["CS170" : [alanPost]], postsHosted: [pp2], postsJoined: [gracePost])
var Jerry = User(username: "jerry", profilePic: UIImage(named: "Alan"), uid: "jerry", friends: ["alan", "amy"], typeToPosts: ["CS170" : [pp3, pp1]], postsHosted: [pp1], postsJoined: [gracePost])


var CS170 = friendSpace(uid: "cs170", name: "CS170", people: ["alan", "grace"], image: UIImage(named: "cs170"))
var Berkeley = friendSpace(uid: "berkeley", name: "Berkeley", people: ["alan","grace", "amy", "selina", "tom"], image: UIImage(named: "berkeley"))
var Unit1 = friendSpace(uid: "unit1", name: "Unit1", people: ["grace", "selina"], image: UIImage(named: "dorm"))
var DSC = friendSpace(uid: "dsc", name: "DSC", people: ["alan", "tom"], image: UIImage(named: "dsc"))
var Stats = friendSpace(uid: "stats", name: "Stats", people: ["jerry", "amy"], image: UIImage(named: "stats"))
var blockchain = friendSpace(uid: "blockchain", name: "CS61B", people: ["grace", "selina"], image: UIImage(named: "blockchain"))
var toppa = friendSpace(uid: "toppa", name: "toppa", people: ["alan","grace", "amy", "selina", "tom", "jerry"], image: UIImage(named: "toppa"))

//construct fake user Grace fro testing.

//global variable for this User.
var signedIn = false
var globalUser = Alan

//for getUser in User class
//store uid and username to check if the user is already there
var globalUID = ""
var globalUSERNAME = ""
var globalPICURL: URL?

//change this later to globalUser.
var friendSpacesIn: [friendSpace] = [CS170, Berkeley, Unit1, toppa, DSC, Stats, blockchain]


let db = Firestore.firestore()
let storage = Storage.storage()

//global functions for firebase
//get friend space w/ uid
//implement image later
func retrieveFriendSpaceWithUID(uid: String) -> friendSpace {
    var ThisUid = ""
    var ThisName = ""
    var ThisPeople: [String] = []
    let docRef = db.collection("friendSpace").document(uid)
    var newFriendSpace = CS170
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            ThisUid = uid
            ThisName = document.data()?["name"] as! String
            ThisPeople = document.data()?["people"] as! [String]
            newFriendSpace.uid = ThisUid
            newFriendSpace.name = ThisName
            newFriendSpace.people = ThisPeople
            newFriendSpace = friendSpace(uid: uid, name: ThisName, people: ThisPeople, image: UIImage())
        } else {
            print("Document does not exist")
        }
    }
    return newFriendSpace
}

//global functions for firebase
//retrieve a user with a particular UID
// this only get called when the user is there.
// Make sure to update friendSpace as well.
//also update this user's User.myFriendSpace
func retrieveUser(uid: String) {
    let db = Firestore.firestore()
    var ThisUsername = ""
    var ThisUid = ""
    var ThisFriends: [String] = []
    var ThisTypeToHostedPosts = [String : [String]]()
    var ThisPostsHosted = [String]()
    var ThisPostsJoined = [String]()
    var ThisFriendSpace = [String]()
    var profilePicURL = ""
    var realMyFriendSpace: [friendSpace] = []
    var actualPostsHosted: [Post] = []
    var actualPostsJoined: [Post] = []
    var actualTypeToPosts = [String : [Post]]()
//    var retrievedUser = User(username: ThisUsername, profilePic: UIImage(named: "dorm"), uid: ThisUid, friends: ThisFriends, typeToPosts: actualTypeToPosts, postsHosted: actualPostsHosted, postsJoined: actualPostsJoined)
    let docRef = db.collection("Users").whereField("uid", isEqualTo: uid)
    var newFS = CS170
    docRef.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            if ((querySnapshot?.documents.count)! > 1) {
                print("FUCK! More than one User")
            }
            for document in querySnapshot!.documents {
                ThisUsername = document.data()["username"] as! String
                ThisUid = document.data()["uid"] as! String
                ThisFriends = document.data()["friends"] as! [String]
                ThisTypeToHostedPosts = document.data()["typeToHostedPosts"] as! [String : [String]]
                ThisPostsHosted = document.data()["postsHosted"] as! [String]

                ThisPostsJoined = document.data()["postsJoined"] as! [String]
                ThisFriendSpace = document.data()["myFriendSpace"] as! [String]
                profilePicURL = document.data()["profilePicURL"] as! String
            }
            var ThisImage = UIImage(named: "Alan")
            var imageURL: URL?
               imageURL = URL(string: profilePicURL)
               SDWebImageManager.shared.loadImage(with: imageURL, options: .highPriority, progress: nil) {
                   (image, data, error, cacheType, isFinished, imageUrl) in
                   ThisImage = image
               }
            for fsUID in ThisFriendSpace {
                newFS = friendSpace(uid: fsUID, name: "RANDOM", people: [], image: UIImage())
                print("\(newFS.uid)")
                newFS.refreshNewFriendSpace()
                realMyFriendSpace.append(newFS)
                print("COUNT: \(ThisFriendSpace)")
                print("\(newFS.uid)")
            }
            globalUser.myFriendSpace = realMyFriendSpace
            actualPostsHosted = listdicToPostList(listDic: ThisPostsHosted)
            actualPostsJoined = listdicToPostList(listDic: ThisPostsJoined)
            actualTypeToPosts = backTypeToHostedPosts(tthp: ThisTypeToHostedPosts)
            globalUser.username = ThisUsername
            globalUser.profilePic = ThisImage
            globalUser.uid = ThisUid
            globalUser.friends = ThisFriends
            globalUser.typeToHostedPosts = actualTypeToPosts
            globalUser.postsHosted = actualPostsHosted
            globalUser.postsJoined = actualPostsJoined
//               retrievedUser = User(username: ThisUsername, profilePic: ThisImage, uid: ThisUid, friends: ThisFriends, typeToPosts: actualTypeToPosts, postsHosted: actualPostsHosted, postsJoined: actualPostsJoined)
        }
    }
//    print("Second FriendSpace: \(globalUser.myFriendSpace[1].uid)")
}

//refresh this user's information real time.
//implement real time listener later.
//manually update for now. draw data once.
//This function is called everytime we need to update data.
//1. refresh User when add post and add friend.
//2. make sure to update "My Friends" friendSpace
//3. refresh all information in friendSpace too.
//refresh Data for the current user: globalUser
//completion: () -> Any
func refreshData() {

    retrieveUser(uid: globalUID)
}

//helper funcions for retrieve User
//implement image later
//also fetch userImage
//fetch image from storage here.
func string2Post(postUID: String) -> Post {
    var ThisFriendSpace: String = ""
    var ThisTitle: String = ""
    var ThisLocation: String = ""
    var Thisdate = [String: String]()
    var ThisUser: String = ""
    var ThisDescription: String = ""
    var actualFriendSpace: friendSpace = friendSpace(uid: "", name: "", people: [], image: UIImage())
    var Thisimage: String = ""
    var Thisuserimage: String = ""
    var newPost = alanPost
    var nestedList: [[String]] = []
    
    let TAdocRef = db.collection("Posts").whereField("image", isEqualTo: postUID)
    TAdocRef.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            if ((querySnapshot?.documents.count)! > 1) {
                print("FUCK! More than one Post?")
            }
            for document in querySnapshot!.documents {
                ThisFriendSpace = document.data()["friendSpace"] as! String
                ThisTitle = document.data()["title"] as! String
                ThisLocation = document.data()["location"] as! String
                Thisdate = document.data()["date"] as! [String : String]
                ThisUser = document.data()["user"] as! String
                ThisDescription = document.data()["description"] as! String
                actualFriendSpace = retrieveFriendSpaceWithUID(uid: ThisFriendSpace)
                
                Thisimage = document.data()["image"] as! String
                Thisuserimage = document.data()["userImage"] as! String
            }
        }
        for (day, vote) in Thisdate {
            nestedList.append([day, vote])
        }
        newPost.friendSpace = actualFriendSpace
        newPost.title = ThisTitle
        newPost.location = ThisLocation
        newPost.date = nestedList
        newPost.description = ThisDescription
                
                print("Before image1: \(Thisimage)")
                let storageRef = storage.reference(withPath: "postImage/\(Thisimage).jpg")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                    if error != nil {
                        print("error getting post image")
            //            print("imageID: \(Thisimage)")
            //            print("ERROR IS \(error)")
                    }
                    if let data = data {
                        let image = UIImage(data:data)
                        newPost.image = image
                    }
                }
                
                print("Before image2: \(Thisuserimage)")
                let storageRef2 = storage.reference(withPath: "userImage/\(Thisuserimage).jpg")
                   storageRef2.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                       if error != nil {
                           print("error getting post userimage")
            //            print("ERROR IS \(error)")
                       }
                       if let data = data {
                           let image2 = UIImage(data:data)
                           newPost.userImage = image2
                       }
                   }
    }
    
    return newPost
}

//turn listdicTo Post list
func listdicToPostList(listDic: [String] ) -> [Post] {
    var postList: [Post] = []
    for postUID in listDic {
        let disPost = string2Post(postUID: postUID)
        postList.append(disPost)
    }
    return postList
}

//get type to hosted posts from data
func backTypeToHostedPosts (tthp: [String : [String]]) -> [String : [Post]] {
    var dictionary = [String : [Post]]()
    for (type, listPost) in tthp {
        dictionary.updateValue(listdicToPostList(listDic: listPost), forKey: type)
    }
    return dictionary
}
