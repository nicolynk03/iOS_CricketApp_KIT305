//
//  ViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 5/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    @IBOutlet var homeTeamNameField: UITextField!
    
    @IBAction func enteredHomeTeamName(_ sender: Any) {
        
        print("User typed \(homeTeamNameField.text!)")
        
        //from iOS tutorial MyLO
        //self.performSegue(withIdentifier: "goToMatchScreen", sender: nil)
    }
    @IBOutlet var awayTeamNameField: UITextField!
    @IBAction func enteredAwayTeamName(_ sender: Any) {
        
        print("User typed \(awayTeamNameField.text!) for the away team")
        
        
        
        //from iOS tutorial MyLO
        //self.performSegue(withIdentifier: "goToMatchScreen", sender: nil)
    }
    
    //Reference: KIT305 Firebase iOS tutorial
    var matchData : Match?
    
    @IBOutlet var startMatchHomeScreenBtn: UIButton!
    @IBAction func startMatchHomeScreenBtnPressed(_ sender: Any) {
        //Reference: StackOverflow "How to check if a text field is empty or not in Swift"
        if let homeTeam = homeTeamNameField.text, !homeTeam.isEmpty, let awayTeam = awayTeamNameField.text, !awayTeam.isEmpty {
            //if both fields are not empty
            let homeTeam = homeTeamNameField.text
            let awayTeam = awayTeamNameField.text
            
            let initialScore = scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: "")
            
            //let initialScore = scoreDetails(striker: "", nonStriker: "", bowler: "")
            matchData = Match(homeTeam: homeTeam!, awayTeam: awayTeam!, balls: [initialScore])
            
            saveMatch(matchData!)
        }
    }
    
    //Reference: KIT305 iOS Firebase Segue Tutorial
    @IBAction func unwindToStartMatchScreen(sender: UIStoryboardSegue) {
        print("Start a new match after going from main scoreboard screen")
    }
    
    //Reference: ChatGPT to create functions to save data with arrays
    func saveMatch(_ match: Match) {
        
        //from KIT305 iOS Firebase tutorial
        let database = Firestore.firestore()
        let matchCollection = database.collection("matchiOS")
        
        do {
            let newMatchDocument = try matchCollection.addDocument(from: match, completion: { (err) in
                if let err = err {
                    print("Error adding match document: \(err)")
                } else {
                    print("Successfully created a match")
                    
                    
                    
                    //from iOS tutorial MyLO
                    self.performSegue(withIdentifier: "goToMatchScreen", sender: nil)
                }
            })
            matchData?.documentID = newMatchDocument.documentID
        } catch let error {
            print("Error writing match to Firestore: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //for database connection to Firebase Firestore
        //from iOS Firebase tutorial
        let database = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(database.app.name)\n")
    }
    
    //to send data to Match View Controller
    //from iOS sending data to second screen tutorial
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMatchScreen" {
            
            if let secondScreen = segue.destination as? MatchPageViewController {
                secondScreen.enteredHomeNamePreviousView = homeTeamNameField.text!
                secondScreen.enteredAwayNamePreviousView = awayTeamNameField.text!
                
                
                //todo: send the match object to the next screen
                secondScreen.matchData = matchData
            }
        }
        
        if segue.identifier == "AddNewHomePlayerSegue" {
            if let addHomePlayerScreen = segue.destination as? DetailViewController {
                addHomePlayerScreen.enteredHomeTeamName = homeTeamNameField.text!
              //addHomePlayerScreen.enteredHomeTeamName = homeTeamNameField.text!
            }
        }
        
    }


}

