//
//  CreatePartyTypeViewController.swift
//  frmU
//
//  Created by Grace Lei on 3/25/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class CreatePartyTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var imagePickerController: UIImagePickerController!
    
    var chosenPartyType:friendSpace?
    
    @IBOutlet weak var typeRemainderLabel: UILabel!
    
    
    @IBOutlet weak var partyTypeCollectionView: UICollectionView!
    
    var chosen = false
    
    
    // chosen party image
    @IBOutlet weak var imageLabel: UIImageView!
    
   
    @IBAction func fromCameraButtonPressed(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func fromPhotosButtonPressed(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func toPartyDetailsView(_ sender: UIButton) {
        if (chosen) {
             performSegue(withIdentifier: "createToDetails", sender: sender)
        } else {
            typeRemainderLabel.text = "Please select friend space!"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partyTypeCollectionView.delegate = self
        partyTypeCollectionView.dataSource = self
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        refreshData()
        partyTypeCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if let identifier = segue.identifier {
            if identifier == "createToDetails" {
             if let dest = segue.destination as? MakeDetailViewController {
                 dest.image = self.imageLabel.image
                 dest.type = chosenPartyType
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalUser.myFriendSpace.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partyTypeCell", for: indexPath) as? PartyTypeCollectionViewCell {
//            globalUser.myFriendSpace[index].refreshNewFriendSpace()
            cell.partyImage.image = globalUser.myFriendSpace[index].image
            cell.typeNameLabel.text = globalUser.myFriendSpace[index].name
            cell.typeBackgroundLabel .layer.cornerRadius = cell.typeBackgroundLabel.frame.width / 2
            cell.typeBackgroundLabel.layer.borderWidth = 1
            cell.typeBackgroundLabel.alpha = 0.5
                                  cell.typeBackgroundLabel.layer.masksToBounds = false
           return cell
        }
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let index = indexPath.item
        imageLabel.image = globalUser.myFriendSpace[index].image
           chosenPartyType = globalUser.myFriendSpace[index]
        chosen = true
       }
    
}

// helper function to convert emoji to image
extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 25)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension CreatePartyTypeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let ima = info[.originalImage] as? UIImage {
            self.imageLabel.image = ima
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
