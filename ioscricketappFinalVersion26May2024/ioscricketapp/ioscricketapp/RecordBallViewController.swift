//
//  RecordBallViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 11/5/2024.
// Reference: KIT305 Firebase tutorials
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecordBallViewController: UIViewController {
    
    //Reference: KIT305 Firebase iOS tutorial MyLO
    //var scores = [Match]()
    var scores : Match?
    
    //to store ball records of the document in an array and be delivered by Delegate to main screen with scoreboard
    var ballRecords = [Match]()
    
    weak var delegate: MatchPageViewControllerDelegate?
    
    var currentStriker: String?
    var currentBowler: String?
    var currentNonStriker: String?
    
    var enteredAwayTeamName: String?


    @IBOutlet var wicketDismissalTypeButton: UIButton!
    
    @IBOutlet var increaseTotalRunByOneButton: UIButton!
    @IBAction func increaseTotalRunByOnePressed(_ sender: Any) {
        //TODO: database init here
        let database = Firestore.firestore()
        //Reference: KIT305 iOS Firebase Tutorial and ChatGPT
        //TODO: find a way to update the elements of the array using .setData instead of .arrayUnion
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 Firebase iOS tutorial
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class week 12
                if let document = result, document.exists {
                    
                    let conversionResult = Result
                    {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult
                    {
                      //no problems (but could still be nil)
                      case .success(var match):
                        if !match.balls.isEmpty {
                            match.balls[match.balls.count - 1].runs += 1
                            match.balls[match.balls.count - 1].striker = self.currentStriker!
                            match.balls[match.balls.count - 1].bowler = self.currentBowler!
                            match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                        } else {
                            print("array is empty")
                        }
                          
                        match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                        //TODO: Update here
                        do {
                            try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("match document has been successfully updated")
                                    //Referencee: KIT305 Firebase iOS tutorial
                                    self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                }
                            }
                        } catch { print("Error updating match array document \(error)") }
                        
                      case .failure(let error):
                          // A `Movie` value could not be initialized from the DocumentSnapshot.
                          print("Error decoding movie: \(error)")
                    }
                }
            }
        }
        
        
        /*do {
            try database.collection("matchiOS").document(scores!.documentID!).updateData(["runs": FieldValue.increment(Int32(1))])
        }*/
        /*do {
            try database.collection("matchiOS").document(scores!.documentID!).updateData(["balls": FieldValue.arrayUnion([runs = 1])])
        }*/
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
        //matchData!.
        
        
    }
    
    @IBOutlet var increaseTotalRunByTwoButton: UIButton!
    @IBAction func increaseTotalRunByTwoPressed(_ sender: Any) {
        
        //Reference: ChatGPT, KIT305 iOS tutorials, and Lake
        let database = Firestore.firestore()
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 iOS Firebase
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorials, Lake during tutorial class in week 12
                if let document = result, document.exists {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult {
                        //no problems but could still be nil
                        case.success(var match):
                            if !match.balls.isEmpty {
                                match.balls[match.balls.count - 1].runs += 2
                                match.balls[match.balls.count - 1].striker = self.currentStriker!
                                match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                            } else {
                                print("Array is empty")
                            }
                            
                            match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                            //TODO: Update here
                            do {
                                try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("match document has been successfully updated when increasing runs by 2")
                                        //Referencee: KIT305 Firebase iOS tutorial
                                        self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                    }
                                }
                            } catch { print("Error updating match array document \(error)")}
                        case .failure(let error):
                            //a 'Match' value cannot be initialised from DocumentSnapshot
                            print("Error decoding match: \(error)")
                    }
                }
            }
        }
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
    }
    
    
    @IBOutlet var increaseTotalRunByThreeButton: UIButton!
    @IBAction func increaseTotalRunByThreePressed(_ sender: Any) {
        
        //Reference: ChatGPT, KIT305 iOS tutorials, and Lake
        let database = Firestore.firestore()
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 iOS Firebase
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorials, Lake during tutorial class in week 12
                if let document = result, document.exists {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult {
                        //no problems but could still be nil
                        case.success(var match):
                            if !match.balls.isEmpty {
                                match.balls[match.balls.count - 1].runs += 3
                                match.balls[match.balls.count - 1].striker = self.currentStriker!
                                match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                            } else {
                                print("Array is empty")
                            }
                            
                            match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                            //TODO: Update here
                            do {
                                try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("match document has been successfully updated when increasing runs by 3")
                                        //Referencee: KIT305 Firebase iOS tutorial
                                        self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                    }
                                }
                            } catch { print("Error updating match array document \(error)")}
                        case .failure(let error):
                            //a 'Match' value cannot be initialised from DocumentSnapshot
                            print("Error decoding match: \(error)")
                    }
                }
            }
        }
        
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
    }
    
    
    @IBOutlet var increaseTotalRunByFourButton: UIButton!
    @IBAction func increaseTotalRunByFourPressed(_ sender: Any) {
        
        //Reference: ChatGPT, KIT305 iOS tutorials, and Lake
        let database = Firestore.firestore()
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 iOS Firebase
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorials, Lake during tutorial class in week 12
                if let document = result, document.exists {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult {
                        //no problems but could still be nil
                        case.success(var match):
                            if !match.balls.isEmpty {
                                match.balls[match.balls.count - 1].runs += 4
                                match.balls[match.balls.count - 1].striker = self.currentStriker!
                                match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                            } else {
                                print("Array is empty")
                            }
                            
                            match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                            //TODO: Update here
                            do {
                                try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("match document has been successfully updated when increasing runs by 4")
                                        //Referencee: KIT305 Firebase iOS tutorial
                                        self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                    }
                                }
                            } catch { print("Error updating match array document \(error)")}
                        case .failure(let error):
                            //a 'Match' value cannot be initialised from DocumentSnapshot
                            print("Error decoding match: \(error)")
                    }
                }
            }
        }
        
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
    }
    
    
    @IBOutlet var increaseTotalRunByFiveButton: UIButton!
    @IBAction func increaseTotalRunByFivePressed(_ sender: Any) {
        //Reference: ChatGPT, KIT305 iOS tutorials, and Lake
        let database = Firestore.firestore()
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 iOS Firebase
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorials, Lake during tutorial class in week 12
                if let document = result, document.exists {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult {
                        //no problems but could still be nil
                        case.success(var match):
                            if !match.balls.isEmpty {
                                match.balls[match.balls.count - 1].runs += 5
                                match.balls[match.balls.count - 1].striker = self.currentStriker!
                                match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                            } else {
                                print("Array is empty")
                            }
                            
                            match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                            //TODO: Update here
                            do {
                                try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("match document has been successfully updated when increasing runs by 5")
                                        //Referencee: KIT305 Firebase iOS tutorial
                                        self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                    }
                                }
                            } catch { print("Error updating match array document \(error)")}
                        case .failure(let error):
                            //a 'Match' value cannot be initialised from DocumentSnapshot
                            print("Error decoding match: \(error)")
                    }
                }
            }
        }
        
        
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
    }
    
    
    @IBOutlet var zeroDotBallButton: UIButton!
    @IBAction func increaseTotalRunByZeroPressed(_ sender: Any) {
        
        //Reference: ChatGPT, KIT305 iOS tutorials, and Lake
        let database = Firestore.firestore()
        let matchDocumentCollection = database.collection("matchiOS")
        let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
        
        //gets the document
        matchDocumentReference.getDocument() { (result, err) in
            //checks for server error
            //Reference: KIT305 iOS Firebase
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //Reference: ChatGPT, KIT305 iOS tutorials, Lake during tutorial class in week 12
                if let document = result, document.exists {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    switch conversionResult {
                        //no problems but could still be nil
                        case.success(var match):
                            if !match.balls.isEmpty {
                                match.balls[match.balls.count - 1].runs += 0
                                match.balls[match.balls.count - 1].striker = self.currentStriker!
                                match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                            } else {
                                print("Array is empty")
                            }
                            
                            match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                        
                            //TODO: Update here
                            do {
                                try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("match document has been successfully updated when increasing runs by 0")
                                        //Referencee: KIT305 Firebase iOS tutorial
                                        self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
                                    }
                                }
                            } catch { print("Error updating match array document \(error)")}
                        case .failure(let error):
                            //a 'Match' value cannot be initialised from DocumentSnapshot
                            print("Error decoding match: \(error)")
                    }
                }
            }
        }
        
        
        //Referencee: KIT305 Firebase iOS tutorial
        //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Reference: UICode (YouTube) - Popup Button - Xcode 13.2 - Swift 5.2
        //followed the whole tutorial
        //calls function for dimissal type record
        setPopUpButton()
        
        //gettingMatchData()
    }
    
    //Reference: UICode (YouTube) - Popup Button - Xcode 13.2 - Swift 5.2
    //followed the whole tutorial
    //pop up button function for dimissal type record
    func setPopUpButton() {
        
        //Reference: ChatGPT
        //ChatGPT is used to modify the pop up button function to utilise segue to bring user back to main screen after recording dismissal type of a wicket
        
        //original optionClosure
        /*let optionClosure = {(action : UIAction) in
            print(action.title)
        }*/
        
        //Reference: ChatGPT
        let optionClosure = { [weak self] (action : UIAction) in
            guard let self = self else { return }
            
            //perform segue in each option (when selected by user)
            switch action.title {
                case "Bowled":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollection = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class week 12
                            if let document = result, document.exists {
                                
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                    //no probelms here but could be nil
                                    case .success(var match):
                                        //TODO: here if it success
                                        if !match.balls.isEmpty {
                                            match.balls[match.balls.count - 1].wickets = "Bowled"
                                            match.balls[match.balls.count - 1].striker = self.currentStriker!
                                            match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                            match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                        } else {
                                            print("Array is empty")
                                        }
                                    
                                        //creates new element in the array
                                        match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                        //TODO: update here
                                        do {
                                            try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                                
                                                if let err = err {
                                                    print("Error updating document: \(err)")
                                                } else {
                                                    print("match document has been updated successfully")
                                                    self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                                }
                                            }
                                        } catch { print("Error updating match array document \(error)")}
                                    case .failure(let error):
                                        //TODO: If fails
                                        //a 'Match' value cannot be initialised from the DocumentSnapshot
                                        print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Caught":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollection = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: KIT305 iOS tutorial, ChatGPT, and Lake during tutorial class in week 12
                            if let document = result, document.exists {
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                    //no problems here but could still be nil
                                    case .success(var match):
                                        //TODO: If successful
                                    if !match.balls.isEmpty {
                                        match.balls[match.balls.count - 1].wickets = "Caught"
                                        match.balls[match.balls.count - 1].striker = self.currentStriker!
                                        match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                        match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                        
                                    } else {
                                        print("Array is empty")
                                    }
                                    
                                    //creates new element in the array
                                    match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                    //TODO: update here
                                    do {
                                        try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                            
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("match document has been updated successfully")
                                                self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                            }
                                        }
                                    } catch { print("Error updating match array document\(error)")}
                                    case .failure(let error):
                                        //TODO: If it fails
                                        //a 'match' value cannot be initialised from DocumentSnapshot
                                        print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Caught and Bowled":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollection = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollection.document(scores!.documentID!)
                
                    //gets document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class week 12
                            if let document = result, document.exists {
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                    //no problems here but could be nil
                                    case .success(var match):
                                        //TODO: if success
                                    if !match.balls.isEmpty {
                                        match.balls[match.balls.count - 1].wickets = "Caught and Bowled"
                                        match.balls[match.balls.count - 1].striker = self.currentStriker!
                                        match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                        match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                    } else {
                                        print("Array is empty")
                                    }
                                    
                                    //creates a new element in the array
                                    match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                    //TODO: update database here
                                    do {
                                        try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                            
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("match document has been updated successfully")
                                                self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                            }
                                        }
                                    } catch { print ("Error updating match array document \(error)")}
                                    case .failure(let error):
                                        //TODO: if it fails
                                        // a 'match' value cannot be initialised from DocumentSnapshot
                                        print("error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Leg Before Wicket (LBW)":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS firebase tutorial and ChatGPT
                    let matchDocumentCollcetion = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollcetion.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class in week 12
                            if let document = result, document.exists {
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                case .success(var match):
                                    //TODO: if successful
                                    if !match.balls.isEmpty {
                                        match.balls[match.balls.count - 1].wickets = "Leg Before Wicket (LBW)"
                                        match.balls[match.balls.count - 1].striker = self.currentStriker!
                                        match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                        match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                    } else {
                                        print("Array is empty")
                                    }
                                    
                                    //creates a new element in the array "balls"
                                    match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                    //TODO: update database here
                                    do {
                                        try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                            
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Match document has been updated successfully")
                                                self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                            }
                                        }
                                    } catch { print("Error updating match array document \(error)")}
                                case .failure(let error):
                                    //TODO: If it fails
                                    //a 'Match' valye cannot be initialsied from DocumentSnapshot
                                    print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                    
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Run Out":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollcetion = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollcetion.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class of week 12
                            if let document = result, document.exists {
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                case .success(var match):
                                    //TODO: here if it success
                                    if !match.balls.isEmpty {
                                        match.balls[match.balls.count - 1].wickets = "Run Out"
                                        match.balls[match.balls.count - 1].striker = self.currentStriker!
                                        match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                        match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                    } else {
                                        print("Array is empty")
                                    }
                                    
                                    //creates a new element in the array
                                    match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                    //TODO: update database here
                                    do {
                                        try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                            
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("match document has been updated successfully")
                                                self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                            }
                                        }
                                    } catch { print("Error updating match array documnet \(error)")}
                                case .failure(let error):
                                    //TODO: if fails
                                    //a 'Match' value cannot be initialised from DocumentSnapshot
                                    print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Hit Wicket":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollcetion = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollcetion.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result, err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorials, and Lake during week 12 tutorial class
                            if let document = result, document.exists {
                                
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                //TODO: do switch here
                                switch conversionResult {
                                    case .success(var match):
                                        //TODO: if successful
                                        if !match.balls.isEmpty {
                                            match.balls[match.balls.count - 1].wickets = "Hit Wicket"
                                            match.balls[match.balls.count - 1].striker = self.currentStriker!
                                            match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                            match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                        } else {
                                            print("Array is empty")
                                        }
                                    
                                        //creates a new element in the array
                                        match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                        //TODO: update database here
                                        do {
                                            try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                                
                                                if let err = err {
                                                    print("Error updating document: \(err)")
                                                } else {
                                                    print("match document has been updated successfully")
                                                    self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                                }
                                            }
                                        } catch { print("Error updating match array document \(error)")}
                                    case .failure(let error):
                                        //TODO: if it fails
                                        //A 'Match' value cannot be initialised from DocumentSnapshot
                                        print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                case "Stumping":
                    //Reference: KIT305 iOS tutorials, Lake in week 12 tutorial class, and ChatGPT
                    let database = Firestore.firestore()
                    //Reference: KIT305 iOS Firebase tutorial and ChatGPT
                    let matchDocumentCollcetion = database.collection("matchiOS")
                    let matchDocumentReference = matchDocumentCollcetion.document(scores!.documentID!)
                
                    //gets the document
                    matchDocumentReference.getDocument() { (result,err) in
                        //checks for server error
                        //Reference: KIT305 Firebase iOS tutorial
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //Reference: ChatGPT, KIT305 iOS tutorial, and Lake during tutorial class of week 12
                            if let document = result, document.exists {
                                let conversionResult = Result {
                                    try document.data(as: Match.self)
                                }
                                
                                switch conversionResult {
                                    case.success(var match):
                                        //TODO: if successful
                                    if !match.balls.isEmpty {
                                        match.balls[match.balls.count - 1].wickets = "Stumping"
                                        match.balls[match.balls.count - 1].striker = self.currentStriker!
                                        match.balls[match.balls.count - 1].bowler = self.currentBowler!
                                        match.balls[match.balls.count - 1].nonStriker = self.currentNonStriker!
                                    } else {
                                        print("Array is empty")
                                    }
                                    
                                    //creates a new element in the array
                                    match.balls.append(scoreDetails(runs: 0, wickets: "", striker: "", nonStriker: "", bowler: ""))
                                    
                                    //TODO: update database here
                                    do {
                                        try database.collection("matchiOS").document(self.scores!.documentID!).setData(from: match) { err in
                                            
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Match document has been updated successfully")
                                                self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                                            }
                                        }
                                    } catch { print("Error updating match array document \(error)")}
                                    
                                    case .failure(let error):
                                        //TODO: if fails
                                        //a 'Match' value cannot be initialised from DocumentSnapshot
                                        print("Error decoding a match: \(error)")
                                }
                            }
                        }
                    }
                    //self.performSegue(withIdentifier: "afterRecordedAnBallOutcomeSegue", sender: nil)
                default:
                    break
            }
        }
        
        wicketDismissalTypeButton.menu = UIMenu(children : [
            UIAction(title: "Bowled", state: .on, handler: optionClosure),
            UIAction(title: "Caught", handler: optionClosure),
            UIAction(title: "Caught and Bowled", handler: optionClosure),
            UIAction(title: "Leg Before Wicket (LBW)", handler: optionClosure),
            UIAction(title: "Run Out", handler: optionClosure),
            UIAction(title: "Hit Wicket", handler: optionClosure),
            UIAction(title: "Stumping", handler: optionClosure)])
        
        wicketDismissalTypeButton.showsMenuAsPrimaryAction = true
        wicketDismissalTypeButton.changesSelectionAsPrimaryAction = true
    }
    
    //TODO: make a function to get data from Firebase Firestore perhaps?
    /*func gettingMatchData() {
        //Reference: KIT305 Firebase iOS tutorial
        let database = Firestore.firestore()
        let matchCollection = database.collection("matchiOS")
        
        matchCollection.getDocuments() { (result, err) in
            
            //check for server error
            if let err = err {
                print("Error getting match data documnets: \(err)")
            } else {
                //loops through the result
                for document in result!.documents {
                    //attempts to covert to Match object
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    
                    //checks if conversionResult is a success or a failure
                    switch conversionResult {
                        //no problems here (could still be nil)
                        case .success(let matchData):
                            print("Match data: \(matchData)")
                        
                        case .failure(let error):
                            //a 'Match" value cannot be initialsied from DocumentSnapshot
                            print("Error decoding match data: \(error)")
                    }
                }
            }
        }
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Reference: ChatGPT and Lindsay
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear has been called in RecordBallViewController")
        
        if self.isMovingFromParent {
            delegate?.didReceiveRecordBallData(ballRecords)
        }
    }*/

}
