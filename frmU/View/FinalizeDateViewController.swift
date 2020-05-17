//
//  FinalizeDateViewController.swift
//  frmU
//
//  Created by Lingyue Zhu on 4/30/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class FinalizeDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chosenPost: Post = alanPost
    var chosenTime: String = ""
    @IBOutlet weak var showDates: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDates.delegate = self
        showDates.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func FinalizeAction(_ sender: Any) {
        chosenPost.finalizeDate(Chosendate: chosenTime)
        globalUser.updateUser()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenPost.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let dateDisplaying = chosenPost.date[index]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myDateCell", for: indexPath) as? FinalizeDateTableViewCell {
            cell.myDate.text = "Time: \(dateDisplaying[0])"
            cell.numPeople.text = "People Voting: \(dateDisplaying[1])"
            print("Have Posts: \(chosenPost.title)")
            return cell
        } else {
            print("No Posts: \(chosenPost.title)")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let dateDisplaying = chosenPost.date[index]
        chosenTime = dateDisplaying[0]
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
