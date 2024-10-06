//
//  MatchHistoryUITableViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 25/5/2024.
//
//Reference: iOS Firebase tutorial KIT305
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class MatchHistoryUITableViewController: UITableViewController {
    //Reference: iOS Firebase tutorial KIT305
    var matches = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        //Reference: iOS Firebase tutorial KIT305
        let database = Firestore.firestore()
        let matchCollection = database.collection("matchiOS")
        matchCollection.getDocuments() { (result, err) in
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
        }
    }

    // MARK: - Table view data source

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
        return matches.count
    }
    
    //Reference: iOS Firebase tutorial KIT305
    //returning new instance of MatchHistoryUITableViewCell which shows a given row of the table (determined by the parameter indexPath).
    //we populate MatchHistoryUITableViewCell with data from matches array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Reference: KIT305 iOS Firebase Tutorial
        //to pass through the selected awayPlayer when a table cell is tapped on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //Reference: KIT305 iOS Firebase Tutorial
        super.prepare(for: segue, sender: sender)
        
        //checks if the segue is the segue to go to specific match record screen or not
        if segue.identifier == "specificMatchDetailSegue" {
            
            //Reference: ChatGPT
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMatch = matches[indexPath.row]
                let specificMatchScreen = segue.destination as! SpecificMatchUITableViewController
                specificMatchScreen.matchRecord = selectedMatch
            }
            
            
            //down-cast from UIViewController to SpecificMatchUITableViewController (this could fail if we didn’t link things up properly)
            /*guard let specificMatchUITableViewController = segue.destination as? SpecificMatchUITableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //down-cast from UITableViewCell to SpecificMatchUITableViewCell (this could fail if we didn’t link things up properly)
            guard let selectedMatchRecordCell = sender as? SpecificMatchUITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //get the number of row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
            guard let indexPath = tableView.indexPath(for: selectedMatchRecordCell) else {
                fatalError("The selected cell is not displayed by the table")
            }
            //tell us which away player is selected using the row number
            let selectedMatchRecord = matches[indexPath.row]
            
            //send in to SpecificMatchUITableViewController
            specificMatchUITableViewController.matchRecord = selectedMatchRecord
            specificMatchUITableViewController.matchRecordIndex = indexPath.row*/
        }
         
        
    }

}
