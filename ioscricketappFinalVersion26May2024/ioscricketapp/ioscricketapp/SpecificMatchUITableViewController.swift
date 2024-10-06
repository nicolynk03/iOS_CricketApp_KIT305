//
//  SpecificMatchUITableViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class SpecificMatchUITableViewController: UITableViewController {
    //Reference: KIT305 Firebase iOS tutorial
    var specificMatch = [Match]()
    //Reference: KIT305 iOS Firebase Tutorial MyLO
    var matchRecord : Match?
    var matchRecordIndex : Int?
    
    var matchDetails: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Reference: ChatGPT
        title = "\(matchRecord?.homeTeam ?? "") vs. \(matchRecord?.awayTeam ?? "")"
        //calls the function to displays details of a selected match (in previous table view)
        loadSpecificMatchDetails()
        
        
        
        
        //Reference: iOS Firebase tutorial KIT305 and ChatGPT
        /*let database = Firestore.firestore()
        let matchDocument = database.collection("matchiOS").document(matchRecord!.documentID!)
        
        matchDocument.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                do {
                    let match = try document.data(as: Match.self)
                    print("Match: \(match)")
                    self.specificMatch.append(match)
                    self.tableView.reloadData()
                } catch let error {
                    print("Error decoding match: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }*/
        
        
        /*let database = Firestore.firestore()
        let matchCollection = database.collection("matchiOS").document(matchRecord!.documentID!)
        matchCollection.getDocument() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    switch conversionResult {
                    case .success(let match):
                        print("Match: \(match)")
                        self.matches.append(match)
                    case .failure(let error):
                        // A `Movie` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding match: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }*/
        
        /*matchCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Match.self)
                    }
                    switch conversionResult {
                    case .success(let match):
                        print("Match: \(match)")
                        self.matches.append(match)
                    case .failure(let error):
                        // A `Movie` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding match: \(error)")
                    }
                }
                self.tableView.reloadData()*/
        
        
        
        
        
        //Reference: iOS Firebase tutorial KIT305
        /*@IBOutlet var batterNameLabelMatchHistoryRecord: UIStackView!
         @IBOutlet var bowlerNameLabelMatchHistoryRecord: UIStackView!
         @IBOutlet var runsLabelMatchHistoryRecord: UILabel!
         @IBOutlet var wicketsLabelMatchHistoryRecord: UILabel!*/
        
        if let displaySpecificMatchRecord = matchRecord {
            //Reference: KIT305 iOS Firebase Tutorial
            //SpecificMatchUITableViewCell().batterNameLabelMatchHistoryRecord.text =
            /*if let displayAwayPlayer = awayPlayer {
                self.navigationItem.title = displayAwayPlayer.name
                newAwayPlayerName.text = displayAwayPlayer.name
            }*/
            //SpecificMatchUITableViewCell().batterNameLabelMatchHistoryRecord.text = displaySpecificMatchRecord
            //Specific
            //batterNameLa
            //SpecificMatchUITableViewCell().batterNameLabelMatchHistoryRecord.text = displaySpecificMatchRecord.homeTeam
        }
        
        
        
        //let database = Firestore.firestore()
        //let matchCollection = database.collection("matchiOS")
        //let specificMatchRef = matchCollection.getDocuments(specificMatch.d)
        
        //let database = Firestore.firestore()
        
        
        /*database.collection("awayPlayersiOS").document(awayPlayer!.documentID!).setData(from: awayPlayer!){ err in*/
    }

    // MARK: - Table view data source
    
    //Reference: ChatGPT and KIT305 MyLO Firebase iOS tutorial
    func loadSpecificMatchDetails() {
        guard let match = matchRecord else { return }
        let database = Firestore.firestore()
        let matchCollection = database.collection("matchiOS")
        let currentMatchReference = matchCollection.document(match.documentID!)
        
        currentMatchReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let matchData = document.data()
                if let matchArray = matchData?["balls"] as? [[String: Any]] {
                    self.matchDetails = matchArray
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Reference: iOS Firebase tutorial KIT305
        //we only need 1 section for the view of match history list
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Reference: iOS Firebase tutorial KIT305
        //specified how many rows we have in each section
        //return matchDetails.count
        return max(matchDetails.count - 1, 0)
    }
    
    //Reference: ChatGPT and Lindsay's suggestion
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificMatchUITableViewCell", for: indexPath) as! SpecificMatchUITableViewCell
        let matchDetail = matchDetails[indexPath.row]
        
        let batterName = matchDetail["striker"] as? String ?? "Unknown striker"
        let bowlerName = matchDetail["bowler"] as? String ?? "Unknown bowler"
        let nonStrikerName = matchDetail["nonStriker"] as? String ?? "Unknown non-striker"
        let totalRuns = matchDetail["runs"] as? Int ?? 0
        let wicketsLost = matchDetail["wickets"] as? String ?? "No wicket"
        //let wicketsLost = matchDetail["wickets"] as? Int ?? 0
        
        /*var wicketLost = 0
        if let wicketString = matchDetail["wickets"] as? String, !wicketString.isEmpty {
            wicketLost = Int(wicketString) ?? 0
        } else if let wicketRecord = matchDetail["wickets"] as? Int {
            wicketLost = wicketRecord
        }*/
        
        cell.batterNameLabelMatchHistoryRecord.text = batterName
        cell.bowlerNameLabelMatchHistoryRecord.text = bowlerName
        cell.nonStrikerLabelMatchHistoryRecord.text = nonStrikerName
        cell.runsLabelMatchHistoryRecord.text = "\(totalRuns)"
        cell.wicketsLabelMatchHistoryRecord.text = "\(wicketsLost)"
        
        if wicketsLost.isEmpty {
            cell.wicketsLabelMatchHistoryRecord.text = "No wicket is recorded in this ball"
        }
        
        return cell
    }
    
    
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Reference: iOS Firebase tutorial KIT305
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHistoryUITableViewCell", for: indexPath)
        
        //get the match for this row
        let match = matches[indexPath.row]
        
        //down-cast the cell from UITableViewCell to our cell class MatchHistoryUITableViewCell
        //note: could fail, so we use an if let.
        if let matchCell = cell as? MatchHistoryUITableViewCell {
            //populate the cell
            matchCell.HomeTeamNameMatchHistory.text = match.homeTeam
            matchCell.AwayTeamNameMatchHistory.text = match.awayTeam
            
            let database = Firestore.firestore()
            let matchCollection = database.collection("matchiOS")
            let currentMatchReference = matchCollection.document(match.documentID!)
            
            //get document
            currentMatchReference.getDocument { (document, error) in
                if let document = document, document.exists {
                    //Reference: calculating wickets in main screen with scoreboard
                    let matchData = document.data()
                    if let matchArray = matchData?["balls"] as? [[String: Any]] {
                        //TODO: copy the thing to calculate wicket here
                        let numberOfWicketsLost = matchArray.reduce(0) { result, curr in
                            print(result)
                            print(curr)
                            
                            if String(describing: (curr["wickets"]!)) == "" {
                                return result
                            } else {
                                return result + 1
                            }
                        }
                        print("number of wickets lost: \(numberOfWicketsLost)")
                        matchCell.WicketLostLabelMatchHistory.text = "\(numberOfWicketsLost)"
                        
                        //get the total runs to be displayed in match history
                        let numberOfRuns = matchArray.reduce(0) { result, curr in
                            print(result)
                            print(curr)
                            return result + ((curr["runs"]!) as! Int)
                        }
                        print("number of runs: \(numberOfRuns)")
                        matchCell.TotalRunsLabelMatchHistory.text = "\(numberOfRuns)"
                    }
                }
            }
        }
        
        return cell
    }*/
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
