//
//  MatchPageViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 7/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Reference: ChatGPT
//to transfer an array of data using a protocol
protocol MatchPageViewControllerDelegate: AnyObject {
    func didReceiveData(_ data: [Players], isAway:Bool)
    //func didReceiveRecordBallData( _ data: [Match])
}

class MatchPageViewController: UIViewController, MatchPageViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Reference: Programiz "Swift Programming Arrays" and KIT305 Firebase Firestore iOS tutorial
    //initialising array of home players in main screen
    //var registeredHomePlayers = [Players]()
    
    //Reference: ChatGPT
    var registeredHomePlayers: [Players]?
    var registeredAwayPlayers: [Players]?
    
    var recordedBall: [Match]?
    
    //from tutorial sheet iOS
    //setting the second screen
    @IBOutlet var homeTeamLabel: UILabel!
    
    @IBOutlet var awayTeamLabel: UILabel!
    
    // to receive data from previous view
    
    //for home team
    var enteredHomeNamePreviousView: String?
    @IBOutlet var homeTeamNameScoreboard: UILabel!
    
    //for away team
    var enteredAwayNamePreviousView: String?
    @IBOutlet var awayTeamNameScoreboard: UILabel!
    
    //start a new match button
    @IBOutlet var startANewMatchButton: UIButton!
    @IBAction func startANewMatchButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "startNewMatchSegue", sender: self)
    }
    
    @IBOutlet var matchHistoryButton: UIButton!
    /*@IBAction func matchHistoryButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMatchHistorySegue", sender: self)
    }*/
    //to display batting team's score
    @IBOutlet var wicketsLostLabel: UILabel!
    @IBOutlet var scoreSeparator: UILabel!
    @IBOutlet var totalRunCountLabel: UILabel!
    
    @IBOutlet var scoreboardLabel: UILabel!
    
    //to display current over in standard cricket scoreboard format
    @IBOutlet var oversCompletedLabel: UILabel!
    @IBOutlet var overSeparator: UILabel!
    @IBOutlet var ballsDeliveredThisOverLabel: UILabel!
    
    //to display current striker, non-striker and bowler
    @IBOutlet var currentStrikerLabel: UILabel!
    @IBOutlet var currentNonStrikerLabel: UILabel!
    @IBOutlet var currentBowlerLabel: UILabel!
    
    //to display run rate in scoreboard UI
    @IBOutlet var runRateLabel: UILabel!
    
    //to display individual score (depending on the name of current striker
    @IBOutlet var runsScoredByStrikerLabelScoreboard: UILabel!
    @IBOutlet var runsLostByBowlerLabelScoreboard: UILabel!
    
    @IBOutlet var ballsFacedByStrikerLabelScoreboard: UILabel!
    @IBOutlet var ballsDeliveredByBowlerLabelScoreboard: UILabel!
    @IBOutlet var wicketsTakenByBowlerLabelScoreboard: UILabel!
    
    //Reference: iOS Firebase tutorial KIT305
    @IBAction func backFromRecordBall(sender: UIStoryboardSegue) {
        print("segue after user has recorded a ball outcome is here")
        fetchDataAndUpdateScoreboardUI()
    }
    
    //for home team in scoreboard
    var homeTeamScoreboard: String?
    
    //Reference: KIT305 Firebase iOS tutorial
    var matchData : Match?
    
    @IBAction func recordBallBtn(_ sender: Any) {
        
        //every time record ball button is pressed, it adds one more ball to the "balls" array in Firebase Firestore
        //let database = Firestore.firestore()
        //let matchCollection = database.collection("matchiOS")
        
        //Reference: Firebase Firestore documentation
        
        /*do {
            try database.collection("matchiOS").document(matchData!.documentID!).updateData(["balls": FieldValue.arrayUnion([runs + 1])])
        }*/
        
        
        //Reference: iOS Navigation Tutorial MyLO
        self.performSegue(withIdentifier: "goToRecordBall", sender: nil)
    }
    /*@IBAction func homePlayerListBtn(_ sender: Any) {
        //Reference: iOS Navigation Tutorial MyLO
        self.performSegue(withIdentifier: "goToHomePlayersList", sender: nil)
    }
    @IBAction func awayPlayerListBtn(_ sender: Any) {
        //Reference: iOS Navigation Tutorial MyLO
        self.performSegue(withIdentifier: "goToAwayPlayersList", sender: nil)
    }*/
    
    //Reference: KIT305 iOS Firebase Tutorial MyLO
    //to get back to home screen with scoreboad after record ball
    @IBAction func unwindToHomeAfterRecordBall(sender: UIStoryboardSegue) {
        print("we have returned from record ball screen :)")
    }
    
    //Reference: KIT305 iOS Firebase Tutorial MyLO and StackOverflow
    //get back to home screen from home player list
    @IBAction func transferHomePlayersToMainScreenSegue(sender: UIStoryboardSegue) {
        print("We have returned from home player list here")
    }
    
    //Reference: ChatGPT (used during swapping)
    var previousOver: Int = 0
    
    //based on example code of KIT305 CameraExample (MyLO)
    //@IBOutlet weak var imageView: UIImageView!
    
    //for share functionality
    //based on example code of KIT305 SharingExample (MyLO)
    @IBAction func shareButtonTapped(_ sender: Any) {
        //Reference: example code of KIT305 SharingExample (MyLO)
        let shareViewController = UIActivityViewController(activityItems: [homeTeamLabel.text!, awayTeamLabel.text!, currentStrikerLabel.text!, currentNonStrikerLabel.text!, currentBowlerLabel.text!, totalRunCountLabel.text!, wicketsLostLabel.text!, oversCompletedLabel.text!, ballsDeliveredThisOverLabel.text!, runRateLabel.text!], applicationActivities: [])
        shareViewController.popoverPresentationController?.sourceView = (sender as! UIView)
        shareViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
        present(shareViewController, animated: true, completion: nil)
    }
    
    //for gallery option functionality
    //based on example code of KIT305 CameraExample (MyLO)
    /*@IBAction func galleryButtonTapped(_ sender: Any) {
        //Reference: KIT305 sample code (CameraExample) for gallery option
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("Gallery option available")
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Reference: KIT305 sample code (CameraExample) for gallery option
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    //Reference: KIT305 sample code (CameraExample) for gallery option
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //from iOS getting data into second screen tutorial
        //to get data in match page view controller
        self.homeTeamLabel.text = enteredHomeNamePreviousView;
        self.awayTeamLabel.text = enteredAwayNamePreviousView;
        
        //to display playing teams name in scoreboard
        self.homeTeamNameScoreboard.text = enteredHomeNamePreviousView;
        homeTeamNameScoreboard.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        
        self.awayTeamNameScoreboard.text = enteredAwayNamePreviousView;
        awayTeamNameScoreboard.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        
        
        //Reference: ChatGPT
        //add asserts to ensure they are connected
        assert(currentStrikerLabel != nil, "currentStrikerLabel is not connected properly")
        assert(currentNonStrikerLabel != nil, "currentNonStrikerLabel is not connected properly")
        assert(currentBowlerLabel != nil, "currentBowlerLabel is not connected properly")
        
        // display the current striker, non-striker, and bowler's names
        listenForPlayerUpdates(role: "Striker")
        listenForNonStrikerUpdates(role: "Non-striker")
        listenForPlayerUpdates(role: "Bowler")
        
        //to call function for individual score tracking
        //Reference: ChatGPT
        fetchDataForCurrentPlayers()
        
        
        // display the current striker, non-striker, and bowler's names
        //displayPlayerWithRole(role: "Striker")
        
        //displayPlayerWithRole(role: "Non-striker")
        //getNonStrikerName(role: "Non-striker")
        
        //displayPlayerWithRole(role: "Bowler")
        
        //initial scoreboard UI (everything starts at 0)
        
        self.wicketsLostLabel.text = "0"
        wicketsLostLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scoreSeparator.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        self.totalRunCountLabel.text = "0"
        totalRunCountLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        self.ballsDeliveredThisOverLabel.text = "0"
        ballsDeliveredThisOverLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        overSeparator.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.oversCompletedLabel.text = "0"
        oversCompletedLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        
        
        /*self.currentStrikerLabel.text = displayPlayerWithRole(role: "Striker")
        self.currentNonStrikerLabel.text = displayPlayerWithRole(role: "Non-striker")
        self.currentBowlerLabel.text = displayPlayerWithRole(role: "Bowler")*/
        
        //get database connection
        let database = Firestore.firestore()
        print("\nFIRESTORE DATABASE APP CONNECTION HAS BEEN ESTABLISHED \(database.app.name)\n")
        
        //adds data (for home players)
        //from iOS Firebase tutorial
        //(for manually test database for home players list)
        let homePlayersCollection = database.collection("homePlayersiOS")
        /*let landoNorris = Players(name: "Lando Norris", team: "Hobart Hurricanes", role: "Batter")
        do {
            try homePlayersCollection.addDocument(from: landoNorris, completion: { (err) in
                if let err = err {
                    print("Error manually add document for home players list: \(err)")
                } else {
                    print("Successfully add a home player to home players list")
                }
            })
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }*/
        
        //to get the data (based on Firebase iOS tutorial)
        homePlayersCollection.getDocuments() { (result, err) in
            
            //check server error
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //loops throught the result(s)
                for document in result!.documents {
                    //attempts to convert Players object
                    let conversionResult = Result {
                        try document.data(as: Players.self)
                    }
                    
                    //checks if conversionResult is a success or fail
                    switch conversionResult {
                        //no probelms (but could still be nil)
                        case .success(let homePlayer):
                            print("Home players: \(homePlayer)")
                        case .failure(let error):
                            //a 'Players' could not be initialised from Document Snapshot
                            print("Error decoding home players: \(error)")
                    }
                }
            }
        }
        
        //testing for away team list
        //adds data (for away player list)
        //from iOS Firebase tutorial
        //(for manually test database for away players list)
        let awayPlayersCollection = database.collection("awayPlayersiOS")
        /*let lukeSkywalker = Players(name: "Luke Skywalker", team: "Tatooiners", role: "Bowler")
        do {
            try awayPlayersCollection.addDocument(from: lukeSkywalker, completion: { (err) in
                if let err = err {
                    print("Error manually add document for away players list: \(err)")
                } else {
                    print("Successfully add an away player to away players list")
                }
            })
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }*/
        
        //to get the data for away players (based on Firebase iOS tutorial)
        awayPlayersCollection.getDocuments() { (result, err) in
            
            //check for server error
            if let err = err {
                print("Error getting documents for away players list: \(err)")
            } else {
                //loops through the result(s)
                for document in result!.documents {
                    //attempts to convert to Players object
                    let conversionResult = Result {
                        try document.data(as: Players.self)
                    }
                    
                    //checks if conversionResult is a success or fail
                    switch conversionResult {
                        //no problems (but still could be nil)
                        case .success(let awayPlayer):
                            print("Away players: \(awayPlayer)")
                        
                        case .failure(let error):
                            // a 'Players' could not be initialised from Document Snapshot
                            print("Error decoding away players: \(error)")
                    }
                }
            }
        }
        
        
        //Reference: TutorialsPoint
        
        
        //scoreboardLabel.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        /*wicketsLostLabel.font = UIFont.systemFont(ofSize: 19)
        scoreSeparator.font = UIFont.systemFont(ofSize: 19)
        totalRunCountLabel.font = UIFont.systemFont(ofSize: 19)
        
        scoreboardLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)*/
        /*wicketsLostLabel: UILabel!
         @IBOutlet var totalRunCountLabel: UILabel!
         
         //to display current over in standard cricket scoreboard format
         @IBOutlet var oversCompletedLabel: UILabel!
         @IBOutlet var ballsDeliveredThisOverLabel: UILabel!*/
        
        
        
        //checks registeredHomePlayers array
        //Reference: ChatGPT to use Delegate to transfer data
        if let players = registeredHomePlayers {
            for player in players {
                print("Name of registered home player: \(player.name)")
                print("Role of registered home player: \(player.role)")
            }
        } else {
            print("No player is received and registered in registeredHomePlayers array")
        }
        
        if let awayPlayers = registeredAwayPlayers {
            for awayPlayer in awayPlayers {
                print("Name of registered away player: \(awayPlayer.name)")
                print("Role of registered away player: \(awayPlayer.role)")
            }
        } else {
            print("No player is received and registered in registeredAwayPlayers array")
        }
        
        /*if let players = registeredHomePlayers {
            for player in players {
                print("registeredHomePlayers has \(registeredHomePlayers?.count)")
                print("\(String(describing: registeredHomePlayers))")
            }
        } else {
            print("registeredHomePlayers is empty")
        }*/
        
        /*if registeredHomePlayers.isEmpty {
            print("registedHomePlayers array is empty")
        } else {
            print(registeredHomePlayers)
            print("There are \(registeredHomePlayers.count) registered home players")
        }*/
        
        /*print("These are the registered home players \(registeredHomePlayers)")
        print("There are \(registeredHomePlayers.count)")*/
        
        //TODO: to update every time the match page is loaded :)
        //Reference: ChatGPT
        fetchDataAndUpdateScoreboardUI()
        
    }
    
    //Reference: ChatGPT to use Delegate to transfer data
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear is called here")
        
        if self.isMovingToParent {
            //checks if registeredHomePlayers is not nil before continuing
            if let players = registeredHomePlayers {
                //calls delegate method to pass data back
                delegate?.didReceiveData(players)
            } else {
                print("No players received")
            }
        }
    }*/
    
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear has been called")
        
        if self.isMovingFromParent {
            if let players = registeredHomePlayers {
                delegate?.didReceiveData(players)
            }
        }
    }*/
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToHomePlayersList" {
            if let addHomePlayerScreen = segue.destination as? HomePlayersListUITableViewController {
                
                addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                addHomePlayerScreen.delegate = self
                //addHomePlayerScreen.enteredHomeNamePreviousView = enteredHomeNamePreviousView
                //addHomePlayerScreen.enteredHomeNamePreviousView = enteredHomeTeamName
                
//                addHomePlayerScreen.enteredAwayTeamName = enteredAwayNamePreviousView
//                addHomePlayerScreen.enteredHomeTeamName = homeTeamNameField.text!
            }
        }
        
        //checks if segue goes to away player list
        if segue.identifier == "goToAwayPlayersList" {
            if let addAwayPlayerScreen = segue.destination as? AwayPlayersListUITableViewController {
                addAwayPlayerScreen.enteredAwayTeamName = enteredAwayNamePreviousView
                addAwayPlayerScreen.delegate = self
            }
        }
        
        //goToRecordBall
        //pass the match object
        if segue.identifier == "goToRecordBall" {
            if let recordBallScreen = segue.destination as? RecordBallViewController {
                recordBallScreen.scores = matchData
                recordBallScreen.currentStriker = currentStrikerLabel.text!
                recordBallScreen.currentBowler = currentBowlerLabel.text!
                recordBallScreen.currentNonStriker = currentNonStrikerLabel.text!
                recordBallScreen.delegate = self
            }
        }
    }
   
    
    //Reference: ChatGPT and consultation with Lindsay
    func didReceiveData(_ data: [Players], isAway:Bool) {
        print("didReceiveData is called here \(data)")
        if isAway == true {
            self.registeredAwayPlayers = data
            let database = Firestore.firestore()
            
            //Reference: ChatGPT
            /*if var registeredAwayPlayers = registeredAwayPlayers {
                for (index, _) in registeredAwayPlayers.enumerated() {
                    if index == 0 {
                        registeredAwayPlayers[index].role = "Bowler"
                    }
                }
            }*/
            
            //Reference: ChatGPT
            if var registeredAwayPlayers = self.registeredAwayPlayers {
                if registeredAwayPlayers.indices.contains(0) {
                    registeredAwayPlayers[0].role = "Bowler"
                    
                    //updates database
                    updateRoleInFirebase(playerId: registeredAwayPlayers[0].documentID!, role: "Bowler", database: database)
                }
            }
            self.registeredAwayPlayers = data
        } else {
            //Reference: ChatGPT
            /*if var registeredHomePlayers = registeredHomePlayers {
                for (index, _) in registeredHomePlayers.enumerated() {
                    if index == 0 {
                        registeredHomePlayers[index].role = "Striker"
                    } else if index == 1 {
                        registeredHomePlayers[index].role = "Non-Striker"
                    } else {
                        registeredHomePlayers[index].role = "Regular player"
                    }
                }
            }*/
            
            //Reference: ChatGPT
            self.registeredHomePlayers = data
            let database = Firestore.firestore()
            
            if var registeredHomePlayers = self.registeredHomePlayers {
                if registeredHomePlayers.indices.contains(0) {
                    registeredHomePlayers[0].role = "Striker"
                    //updates database
                    updateRoleInFirebase(playerId: registeredHomePlayers[0].documentID!, role: "Striker", database: database)
                }
                
                if registeredHomePlayers.indices.contains(1) {
                    registeredHomePlayers[1].role = "Non-striker"
                    //updates database
                    updateRoleInFirebase(playerId: registeredHomePlayers[1].documentID!, role: "Non-striker", database: database)
                }
            }
            self.registeredHomePlayers = data
        }
        //self.registeredHomePlayers = data
        //tableView.reloadData()
    }
    
    //Reference: ChatGPT
    /*func didReceiveRecordBallData(_ data: [Match]) {
        //TODO: use delegate to transfer record ball data to the main screen here
        self.recordedBall = data
        let database = Firestore.firestore()
        
        //Reference: ChatGPT
        if var recordedBall = self.recordedBall {
            let recordedBallDocumentReference = database.collection("matchiOS")
            
            
        }
        
    }*/
    
    //Reference: ChatGPT to fetch data of recorded ball of this match and update scoreboard UI
    //Fetch data from balls array of a match (document) from firebase and update scoreboard UI. Also handles game logic perhaps? Now OK :)
    func fetchDataAndUpdateScoreboardUI() {
        let database = Firestore.firestore()
        let currentMatchCollection = database.collection("matchiOS")
        let currentMatchReference = currentMatchCollection.document(matchData!.documentID!)
        
        //Reference: ChatGPT
        //to store runs for current striker and bowler
        var runsScoredByCurrStriker = 0
        var runsLostByCurrBowler = 0
        
        //Reference: ChatGPT for hints and based it on how to get runs
        //for balls faced/delivered
        var ballsFacedByCurrStriker = 0
        var ballsDeliveredByCurrBowler = 0
        
        //for wicket
        //double-checked by ChatGPT
        var wicketsTakenByCurrBowler = 0
        
        //get the document
        currentMatchReference.getDocument { (document, error) in
            
            if let document = document, document.exists {
                //Reference: ChatGPT
                //document exists, can update labels in scoreboard UI
                let matchData = document.data()
                if let matchArray = matchData?["balls"] as? [[String: Any]] {
                    
                    //Suggestions from Lindsay during tutorial time
                    let numberOfRuns = matchArray.reduce(0) { result, curr in
                        print(result)
                        print(curr)
                        return result + ((curr["runs"]!) as! Int)
                    }
                    print("number of runs: \(numberOfRuns)")
                    self.totalRunCountLabel.text = "\(numberOfRuns)"
                    
                    //TODO: advanced individual run tracking to be displayed in UI?
                    //Reference: ChatGPT
                    for ballData in matchArray {
                        //let playerName = ballData["name"] as! String
                        let strikerName = ballData["striker"] as! String
                        let bowlerName = ballData["bowler"] as! String
                        let runs = ballData["runs"] as! Int
                        let isWicket = ballData["wickets"] as! String
                        
                        if strikerName == self.currentStrikerLabel.text {
                            runsScoredByCurrStriker += runs
                            ballsFacedByCurrStriker += 1 //increments balls faced by striker each time
                        }
                        if bowlerName == self.currentBowlerLabel.text {
                            runsLostByCurrBowler += runs
                            ballsDeliveredByCurrBowler += 1 //increments balls delivered by bowler each time
                            //check if isWicket is an empty string or not
                            //if it is NOT empty
                            if !isWicket.isEmpty {
                                wicketsTakenByCurrBowler += 1 // increment wickets taken by current bowler
                            }
                        }
                    }
                    self.runsScoredByStrikerLabelScoreboard.text = "\(runsScoredByCurrStriker)"
                    self.runsLostByBowlerLabelScoreboard.text = "\(runsLostByCurrBowler)"
                    
                    // to update label for wickets taken by current bowler
                    self.wicketsTakenByBowlerLabelScoreboard.text = "\(wicketsTakenByCurrBowler)"
                    
                    
                    //to handle and update UI if the user record a dismissal type/wicket is recorded
                    let numberOfWicketsLost = matchArray.reduce(0) { result, curr  in
                        print(result)
                        print(curr)
                        
                        if String(describing: (curr["wickets"]!)) == "" {
                            return result
                        } else {
                            //calls the function to appoint a new batter (striker)
                            self.appointNewStriker()
                            return result + 1
                        }
                    }
                    print("number of wickets lost: \(numberOfWicketsLost)")
                    self.wicketsLostLabel.text = "\(numberOfWicketsLost)"
                    
                    //stop and prompt user to start a new match via alert where 4 wickets has been done/recorded
                    //Refenrence: KIT305 iOS tutorial sheet ("Extending the Program") and Lindsay's suggestion for player deletion alert
                    //if 4 wickets are recorded/have been reached
                    if numberOfWicketsLost == 4 {
                        let alertFourWickets = UIAlertController(
                            title: "Match is OVER",
                            message: "Four (4) wickets have been reached, the game is OVER. Please start a new match.",
                            preferredStyle: UIAlertController.Style.alert)
                        
                        //based on Lindsay's suggestion for player deletion alert
                        alertFourWickets.addAction(UIAlertAction(title: "Start a new match", style: UIAlertAction.Style.default, handler: { _ in
                            //unwinds to match creation screen
                            self.performSegue(withIdentifier: "startNewMatchSegue", sender: self)
                        }))
                        self.present(alertFourWickets, animated: true, completion: nil)
                    }
                    
                    
                    //handles the overs
                    //var everySixBallsCountTracker = 0
                    print("this is matchArray.count: \(matchArray.count)")
                    
                    
                    
                    let over = (matchArray.count - 1) / 6
                    self.oversCompletedLabel.text = "\(over)"
                    
                    //TODO: stop and prompt user to start a new match via alert
                    //Reference: from tutorial sheet iOS KIT305 ("Extending the Program")
                    //if over has reached 5
                    if over == 5 {
                        let alertFiveOvers = UIAlertController(
                            title: "Match is OVER",
                            message: "Five (5) overs have been reached, the match is OVER. Please start a new match.",
                            preferredStyle: UIAlertController.Style.alert)
                        
                        //based on Lindsay's suggestion for player deletion alert
                        alertFiveOvers.addAction(UIAlertAction(title: "Start a new match", style: UIAlertAction.Style.default, handler: { _ in
                            //unwinds to match creation screen
                            self.performSegue(withIdentifier: "startNewMatchSegue", sender: self)
                        }))
                        self.present(alertFiveOvers, animated: true, completion: nil)
                    } /*else if over >= 1 && over <= 4 {
                        //TODO: swap striker and non-striker
                        print("over has not reach 5, this is the current over: \(over)")
                        
                    }*/
                    //for every over in the match
                    else if over >= 1 && over <= 4 {
                        //var previousOver: Int = 0
                        //Reference: ChatGPT
                        if over > self.previousOver {
                            print("swapping players for over: \(over)")
                            print("over has not reach 5, this is the current over: \(over)")
                            //swap between striker and non-striker
                            let temp = self.currentStrikerLabel.text
                            self.currentStrikerLabel.text = self.currentNonStrikerLabel.text
                            self.currentNonStrikerLabel.text = temp
                            
                            //call the function to select bowler (for every over)
                            self.selectNewBowler()
                            
                            //update previousOver
                            self.previousOver = over
                        }
                        
                        
                        
                        
                        
                        /*if over % 6 != 0 {
                            //Reference: ChatGPT
                            /*if over > previousOver {
                                print("over has not reach 5, this is the current over: \(over)")
                                //swap between striker and non-striker
                                let temp = self.currentStrikerLabel.text
                                self.currentStrikerLabel.text = self.currentNonStrikerLabel.text
                                self.currentNonStrikerLabel.text = temp
                                
                                //update previousOver
                                previousOver = over
                            }*/
                            //print("over has not reach 5, this is the current over: \(over)")
                            //swap between striker and non-striker
                            //let temp = self.currentStrikerLabel.text
                            //self.currentStrikerLabel.text = self.currentNonStrikerLabel.text
                            //self.currentNonStrikerLabel.text = temp
                        }*/
                    }
                    
                    /*if over == 5 {
                        //stop and prompt user to start a new match
                    }*/
                    //TODO: Change swapp batters
                    //if over % 6 --> swap batter to non-striker
                    //let everyOver = over % 6
                    
                    
                    
                    let currentBallInOver = (matchArray.count - 1) % 6
                    self.ballsDeliveredThisOverLabel.text = "\(currentBallInOver)"
                    
                    //TODO: for every ball faced/delivered
                    self.ballsFacedByStrikerLabelScoreboard.text = "\(ballsFacedByCurrStriker)"
                    self.ballsDeliveredByBowlerLabelScoreboard.text = "\(ballsDeliveredByCurrBowler)"
                    
                    
                    //TODO: calculating run rate and display in scoreboard UI
                    if over == 0 {
                        self.runRateLabel.text = "\(numberOfRuns)"
                    } else {
                        let overRunRateCalc = (over * 6) + currentBallInOver
                        
                        let runRateCalcDenominator: Double
                        runRateCalcDenominator = Double(overRunRateCalc)/6
                        
                        let calculatedRunRate: Double
                        calculatedRunRate = Double(numberOfRuns) / runRateCalcDenominator
                        
                        //Reference: ChatGPT --> format the run rate to three decimal point
                        let formattedRunRateToThreeDP = String(format: "%.3f", calculatedRunRate)
                        
                        self.runRateLabel.text = "\(formattedRunRateToThreeDP)"
                    }
                    
                    
                    
                    /*if over != 0 {
                        let denominatorForRunRate = ((over * 6) + currentBallInOver) / 6
                        let calculatedRunRate: Double
                        calculatedRunRate = Double(numberOfRuns / denominatorForRunRate)
                        self.runRateLabel.text = "\(calculatedRunRate)"
                        /*let overToCalculateRunRate = over * 6
                        let calculatedRunRate = numberOfRuns / (overToCalculateRunRate + currentBallInOver)
                        self.runRateLabel.text = "\(calculatedRunRate)"*/
                    } else if over == 0 {
                        self.runRateLabel.text = "\(numberOfRuns)"
                    }*/
                    /*let overBalls = over * 6
                    if over != 0 {
                        let calculatedBalls = (over * 6) + currentBallInOver
                        let calculatedRunRate = numberOfRuns / (calculatedBalls / 6)
                        //let calculatedRunRate = numberOfRuns / ((over * 6 + currentBallInOver)/6)
                        self.runRateLabel.text = "\(calculatedRunRate)"
                    }*/
                    
                    
                    
                    //matchArray.count - 1 % 6 == 0
                    
                    /*if matchArray.count % 6 == 0 {
                        everySixBallsCountTracker += 1
                        
                        DispatchQueue.main.async {
                            self.oversCompletedLabel.text = "\(everySixBallsCountTracker)"
                        }
                    }*/
                    
                   /*
                    
                    if let latestElementInBallsArray = matchArray.last {
                        //check if "runs" field exists and is an integer
                        if let runs = latestElementInBallsArray["runs"] as? Int {
                            //update totalRunCountLabel based on the latest element in the balls array
                            DispatchQueue.main.async {
                                
                                //attempt to update from the second latest element in the array
                                //self.totalRunCountLabel.text = "\(matchArray[matchArray.count - 2])"
                                
                                if let currentTotalRunCount = Int(self.totalRunCountLabel.text ?? "0") {
                                    let newTotalRunCount = currentTotalRunCount + runs
                                    print("This is the newest total run count\(newTotalRunCount)")
                                    self.totalRunCountLabel.text = "\(newTotalRunCount)"
                                }
                                //self.totalRunCountLabel.text = "\(runs)"
                            }
                        }
                        //checks if "wickets" field exists and is a String and whether it is an empty string or not
                        if let wickets = latestElementInBallsArray["wickets"] as? String {
                            //update wicketsLostLabel based on the latest element in the balls array
                            DispatchQueue.main.async {
                                if wickets.isEmpty {
                                    if let currentWicketLostCount =
                                        Int(self.wicketsLostLabel.text ?? "0") {
                                        self.wicketsLostLabel.text = "\(currentWicketLostCount)"
                                    }
                                    //self
                                } else if !wickets.isEmpty {
                                    if let currentWicketLostCount = Int(self.wicketsLostLabel.text ?? "0") {
                                        let newWicketLostCount = currentWicketLostCount + 1
                                        self.wicketsLostLabel.text = "\(newWicketLostCount)"
                                    }
                                }
                            }
                        }
                        //TODO: not working well as it starts at 1 immediately due to index 0 in the array (initial index) is divisible by 6
                        //to update oversCompleted based on the number of elements in balls array
                        var everySixBallsCountTracker = 0
                        print("this is matchArray.count: \(matchArray.count)")
                        if matchArray.count % 6 == 0 {
                            everySixBallsCountTracker += 1
                            
                            DispatchQueue.main.async {
                                self.oversCompletedLabel.text = "\(everySixBallsCountTracker)"
                            }
                        }
                        
                        //TODO: if overs completed has reached 5, game is over
                        if self.oversCompletedLabel.text == "5" {
                            
                        }
                        
                        //iterate through the array, reference: ChatGPT
                        
                        /*for (index, _) in matchArray.enumerated() {
                            //check if index is divisible by 6 (for every 6 elements (balls))
                            if match % 6 == 0 {
                                everySixBallsCountTracker += 1
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.oversCompletedLabel.text = "\(everySixBallsCountTracker)"
                        }*/
                        
                        
                        /*for (index, element) in matchArray.enumerated() {
                            //check if index is divisible by 6 (for every 6 element)
                            if index % 6 == 0 {
                                everySixBallsCountTracker += 1
                                //Update the oversCompleted based on everySixBallsCountTracker
                                DispatchQueue.main.async {
                                    self.oversCompletedLabel.text = "\(everySixBallsCountTracker)"
                                }
                            }
                        }*/
                        
                        /*DispatchQueue.main.async {
                            
                            self.oversCompletedLabel.text = "\(matchArray.count - 1)"
                        }*/
                    }*/
                }
            } else {
                //Document does not exist or an error has occured
                print("Match document does not exist or error has occured: \(error?.localizedDescription ?? "Unknown error")")
            }
            
            /*if let document = document, document.exists {
                //document exists, UI can be updated in the scoreboard
                let matchData = document.data()
                if let mactchArray = matchData?["balls"] as? [Int] {
                    //sort the array in descending order to get the newest/latest element first
                    let sortedMatchElement = mactchArray.sorted(by: { $0 > $1 })
                    if let newestMatchElement = sortedMatchElement.first {
                        
                        //checks if wickets field is an empty string or not in the element of balls array
                        
                        
                        //update labels with newest element of the array
                        /*DispatchQueue.main.async {
                            self.totalRunCountLabel.text = "\(newestMatchElement)"
                            
                            
                            //self.ballsDeliveredThisOverLabel.text = matchData?["balls"].count
                            
                            
                            
                            /*self.wicketsLostLabel.text = "0"
                             wicketsLostLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
                             scoreSeparator.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
                             self.totalRunCountLabel.text = "0"
                             totalRunCountLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
                             
                             self.ballsDeliveredThisOverLabel.text = "0"
                             ballsDeliveredThisOverLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                             overSeparator.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                             self.oversCompletedLabel.text = "0"
                             oversCompletedLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)*/
                        }*/
                    }
                }
            } else {
                //Document does not exist or an error has occured
                print("Match document does not exist or error has occured: \(error?.localizedDescription ?? "Unknown error")")
            }*/
        }
    }
    
    
    //Reference: ChatGPT
    //to update player role in firebase firestore
    func updateRoleInFirebase(playerId: String, role: String, database: Firestore) {
        let playerReference = database.collection("homePlayersiOS").document(playerId)
        playerReference.updateData(["role": role]) { error in
            if let error = error {
                print("Error updating player role in Firebase: \(error)")
            } else {
                print("Player role has been successfully updated for player with ID \(playerId)")
            }
        }
        
        let awayPlayerReference = database.collection("awayPlayersiOS").document(playerId)
        awayPlayerReference.updateData(["role": role]) { error in
            if let error = error {
                print("Error while updating player role for away player in Firebase: \(error)")
            } else {
                print("Player role has been successfully updated for away player with ID \(playerId)")
            }
        }
    }

    //Reference: ChatGPT
    //to display player's name for current bowler and striker
    //to fix issue with displaying current bowler and striker names when data is empty
    func listenForPlayerUpdates(role: String) {
        let database = Firestore.firestore()
        let homePlayerReference = database.collection("homePlayersiOS")
        let awayPlayerReference = database.collection("awayPlayersiOS")
        var labelToUpdate: UILabel?
        
        switch role {
            case "Striker":
                labelToUpdate = self.currentStrikerLabel
            case "Bowler":
                labelToUpdate = self.currentBowlerLabel
            default:
                print("Invalid role: \(role)")
                return
        }
        
        homePlayerReference.whereField("role", isEqualTo: role).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting players with role \(role) from homePlayersiOS: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No player found with role \(role) in homePlayersiOS")
                    return
                }
                if let foundName = documents.first?.data(), let playerName = foundName["name"] as? String {
                    
                    print("Found player in homePlayersiOS with role \(role): \(playerName)")
                    DispatchQueue.main.async {
                        labelToUpdate?.text = playerName
                    }
                } else {
                    print("No player name with role \(role) found in homePlayersiOS")
                }
            }
        }
        
        awayPlayerReference.whereField("role", isEqualTo:  role).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting players with role \(role) from awayPlayersiOS: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No player found with role \(role) in awayPlayersiOS")
                    return
                }
                if let foundBowlerName = documents.first?.data(), let playerName = foundBowlerName["name"] as? String {
                    print("Found player in awayPlayersiOS with role \(role): \(playerName)")
                    DispatchQueue.main.async {
                        labelToUpdate?.text = playerName
                    }
                } else {
                    print("No player name with role \(role) found in awayPlayersiOS")
                }
            }
        }
    }
    
    //Reference: ChatGPT
    //to fix issue with displaying current non-striker name when data is empty
    func listenForNonStrikerUpdates(role: String) {
        let database = Firestore.firestore()
        let homePlayerCollection = database.collection("homePlayersiOS")
        
        homePlayerCollection.whereField("role", isEqualTo: role).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting non-striker document: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No non-striker found")
                    return
                }
                for document in documents {
                    if let nonStrikerName = document.data()["name"] as? String {
                        print("Found non-striker: \(nonStrikerName)")
                        DispatchQueue.main.async {
                            self.currentNonStrikerLabel.text = nonStrikerName
                        }
                        break
                    }
                }
            }
        }
    }
    
    
    //Reference: ChatGPT
    func displayPlayerWithRole(role: String) {
            let database = Firestore.firestore()
            let homePlayerReference = database.collection("homePlayersiOS")
            let awayPlayerReference = database.collection("awayPlayersiOS")
            var labelToUpdate: UILabel?
           
            switch role {
            case "Striker":
                labelToUpdate = self.currentStrikerLabel
            case "Bowler":
                labelToUpdate = self.currentBowlerLabel
            default:
                print("Invalid role: \(role)")
                return
            }
           
            homePlayerReference.whereField("role", isEqualTo: role).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in getting players with role \(role) from homePlayersiOS: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No player found with role \(role) in homePlayersiOS")
                        return
                    }
                   
                    if let foundName = documents.first?.data(), let playerName = foundName["name"] as? String {
                        print("Found player in homePlayersiOS with role \(role): \(playerName)")
                        DispatchQueue.main.async {
                            labelToUpdate?.text = playerName
                        }
                    } else {
                        print("No player name with role \(role) found in homePlayersiOS")
                    }
                }
            }
           
            awayPlayerReference.whereField("role", isEqualTo: role).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in getting players with role \(role) from awayPlayersiOS: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No player found with role \(role) in awayPlayersiOS")
                        return
                    }
                   
                    if let foundBowlerName = documents.first?.data(), let playerName = foundBowlerName["name"] as? String {
                        print("Found player in awayPlayersiOS with role \(role): \(playerName)")
                        DispatchQueue.main.async {
                            labelToUpdate?.text = playerName
                        }
                    } else {
                        print("No player name with role \(role) found in awayPlayersiOS")
                    }
                }
            }
        }
    
    func displayPlayerWithRole1(role: String) {
        let database = Firestore.firestore()
        let homePlayerReference = database.collection("homePlayersiOS")
        
        homePlayerReference.whereField("role", isEqualTo: role).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error in getting players with role \(role): \(error)")
            } else {
                //check any returned document
                guard let documents = querySnapshot?.documents else {
                    print("No player found with role \(role)")
                    return
                }
                
                if let foundName = documents.first?.data() {
                    //updates UI
                    if let playerName = foundName["name"] as? String {
                        //Reference: ChatGPT
                        //ensures it updates in main thread
                        DispatchQueue.main.async {
                            self.currentStrikerLabel.text = playerName
                        }
                        //self.currentStrikerLabel.text = playerName
                    } else {
                        print("No player name with role \(role) found")
                    }
                } else {
                    print("No player with role \(role) found")
                }
            }
        }
        
        let awayPlayerReference = database.collection("awayPlayersiOS")
        awayPlayerReference.whereField("role", isEqualTo: role).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error in getting players with role \(role): \(error)")
            } else {
                //check any returned document
                guard let documents = querySnapshot?.documents else {
                    print("No player found with role \(role)")
                    return
                }
                
                if let foundBowlerName = documents.first?.data() {
                    //updates UI
                    if let bowlerName = foundBowlerName["name"] as? String {
                        //Reference: ChatGPT
                        //ensures it updates in main thread
                        DispatchQueue.main.async {
                            self.currentBowlerLabel.text = bowlerName
                        }
                        //self.currentBowlerLabel.text = bowlerName
                    } else {
                        print("No player name with role \(role) found")
                    }
                } else {
                    print("No player with role \(role) found")
                }
            }
        }
    }
    
    //Reference: ChatGPT
    //a function to get the non-striker name displayed in the screen
    func getNonStrikerName(role: String) {
            let database = Firestore.firestore()
            let homePlayerCollection = database.collection("homePlayersiOS")
            let findNonStriker = homePlayerCollection.whereField("role", isEqualTo: role)
           
            findNonStriker.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting non-striker document: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let nonStrikerName = document.data()["name"] as? String {
                            print("Found non-striker: \(nonStrikerName)")
                            DispatchQueue.main.async {
                                self.currentNonStrikerLabel.text = nonStrikerName
                            }
                            break
                        }
                    }
                }
            }
        }
    
    //Reference: ChatGPT
    //a function that is used to display score(s) based on the current players
    func fetchDataForCurrentPlayers() {
        let database = Firestore.firestore()
        let playingStriker = currentStrikerLabel.text ?? ""
        let playingBowler = currentBowlerLabel.text ?? ""
        
        //construct query to get necessary data (based on the names of current striker and bowler in scoreboard UI) from Firebase
        database.collection("matchiOS").whereField("name", in: [playingStriker, playingBowler]).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    //extract player name and runs
                    let playerName = data["name"] as! String
                    let runs = data["runs"] as! Int
                    
                    //update UI accordingly
                    DispatchQueue.main.async {
                        if playerName == playingStriker {
                            //update runs scored by current striker
                            self.runsScoredByStrikerLabelScoreboard.text = "\(runs)"
                        } else if playerName == playingBowler {
                            //update runs lost by current bowler
                            self.runsLostByBowlerLabelScoreboard.text = "\(runs)"
                        }
                    }
                }
            }
        }
    }
    
    
    func getNonStrikerName1(role: String) {
        let database = Firestore.firestore()
        let homePlayerCollection = database.collection("homePlayersiOS")
        let findNonStriker = homePlayerCollection.whereField("role", isEqualTo: role)
        
        findNonStriker.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting non-striker document: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if let nonStrikerName = document.data()["name"] as? String {
                        //Reference: ChatGPT
                        //ensures it updates in main thread
                        DispatchQueue.main.async {
                            self.currentNonStrikerLabel.text = nonStrikerName
                        }
                        //self.currentNonStrikerLabel.text = nonStrikerName
                        break
                    }
                }
            }
        }
    }
    
    //Reference: ChatGPT
    // a function to appoint a new bowler
    func selectNewBowler() {
        let database = Firestore.firestore()
        let awayPlayerReference = database.collection("awayPlayersiOS")
        
        //add an additional filter for "Regular player" role
        awayPlayerReference.whereField("role", isEqualTo: "Regular player").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error in getting regular players: \(error)")
            } else {
                //check for any returned document
                guard let documents = querySnapshot?.documents else {
                    print("No bowlers found")
                    return
                }
                
                //ensure previously selected bowler is not repeated
                //extract player names from documents
                var awayPlayerNames = documents.compactMap { $0["name"] as? String}
                
                //shuffle the player names with Regular player role to randomize selection
                awayPlayerNames.shuffle()
                
                //ensure previously selected bowler is not repeated
                if let previousBowler = self.currentBowlerLabel.text,
                   let index = awayPlayerNames.firstIndex(of: previousBowler) {
                    //move previous bowler name at the end of the list
                    awayPlayerNames.remove(at: index)
                    awayPlayerNames.append(previousBowler)
                }
                
                //select the first player from the shuffled list
                if let selectedBowler = awayPlayerNames.first {
                    //update UI with selected bowler's name
                    self.currentBowlerLabel.text = selectedBowler
                } else {
                    print("no bowlers found in away player collection. Please check firebase")
                }
                
            }
        }
    }
    
    //Reference: ChatGPT
    //a function to appoint a new striker
    func appointNewStriker() {
        let database = Firestore.firestore()
        let homePlayerCollection = database.collection("homePlayersiOS")
        
        homePlayerCollection.whereField("role", isEqualTo: "Regular player").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting regular players: \(error)")
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No regular player found")
                return
            }
            
            //get the name of current striker
            let currentStrikerName = self.currentStrikerLabel.text!
            
            //find the index of the current striker in the documents array
            let currentIndex = documents.firstIndex(where: { ($0.data()["name"] as? String) == currentStrikerName}) ?? 0
            
            let nextIndex = (currentIndex + 1) % documents.count
            
            //get the name of the next regular player
            let newStrikerName = documents[nextIndex]["name"] as! String
            self.currentStrikerLabel.text = newStrikerName
            print("New striker is updated, which is \(newStrikerName)")
            
            
            /*var currentStrikerIndex = 0
            if let currentStriker = self.currentStrikerLabel.text,
               let index = documents.firstIndex(where: { ($0.data()["name"] as? String) == currentStriker }) {
                currentStrikerIndex = (index + 1) % documents.count
                //currentStrikerIndex = index
            }
            
            //get the name of the next regular player
            let newStriker = documents[currentStrikerIndex]["name"] as! String
            self.currentStrikerLabel.text = newStriker
            print("New striker is updated, which is \(newStriker)")*/
        }
    }
}
