//
//  AwayPlayersListUITableViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 11/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AwayPlayersListUITableViewController: UITableViewController {
    
    //Reference: KIT305 Firebase iOS tutorial MyLO
    var awayPlayers = [Players]()
    var enteredAwayTeamName: String?
    
    weak var delegate: MatchPageViewControllerDelegate?
    
    //Reference: KIT305 Firebase iOS tutorial MyLO
    @IBAction func unwindToAwayPlayersList(sender: UIStoryboardSegue) {
        // we reload from local away player
        if let detailScreenAway = sender.source as? AwayDetailViewController {
            awayPlayers[detailScreenAway.awayPlayerIndex!] = detailScreenAway.awayPlayer!
            tableView.reloadData()
        }
        print("save segue will come here :)")
    }
    
    @IBAction func goingBackToAwayPlayersListFromAddSection(sender: UIStoryboardSegue) {
        
        //Reference: KIT305 Firebase iOS update tutorial
        /*if let addHomePlayerScreen = sender.source as? DetailViewController {
            homePlayers[addHomePlayerScreen.homePlayerIndex!] = addHomePlayerScreen.homePlayer!
            tableView.reloadData()
        }*/
        
        //if let addHomePlayerScreen = sender.source as?
        self.viewDidLoad()
        
        print("save segue will go here from adding players  :)")
    }
    
    @IBAction func backToAwayPlayersListAfterDelete(sender: UIStoryboardSegue) {
        self.viewDidLoad()
        print("delete segue goes here :)")
    }
    
    @IBAction func unwindToAwayPlayersListWithCancel(sender: UIStoryboardSegue) {
        print("cancelled")
    }

    @IBOutlet var addAwayPlayersBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Reference: KIT305 Firebase iOS tutorial
        let database = Firestore.firestore()
        let awayPlayersCollection = database.collection("awayPlayersiOS")
        //to clear the list (avoid displaying doubles)
        awayPlayers.removeAll()
        awayPlayersCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Players.self)
                    } 
                    switch conversionResult {
                        case .success(let awayPlayer):
                            print("Away player: \(awayPlayer)")
                    
                            self.awayPlayers.append(awayPlayer)
                    
                        case .failure(let error):
                            //An 'away player' value cannot be initialised from DocumentSnapshot
                            print("Error decoding away player: \(error)")
                    }
                }
                
                //enable or disable the add button depending of the number of players in the away team
                if self.awayPlayers.count == 5 {
                    self.addAwayPlayersBtn.isEnabled = false
                } else {
                    self.addAwayPlayersBtn.isEnabled = true
                }
                
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Reference: KIT305 Firebase iOS tutorial
        //We only have one section for the table view
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Reference: KIT305 Firebase iOS tutorial
        return awayPlayers.count
    }
    
    //Reference: KIT305 Firebase iOS tutorial MyLO
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AwayPlayersListUITableViewCell", for: indexPath)
        
        //get the away player for a specific row
        let awayPlayer = awayPlayers[indexPath.row]
        
        //down-cast the cell from AwayPlayersListUITableViewCell to cell class AwayPlayersListUITableViewCell
        //could fail, so we use an "if let"
        if let awayPlayerCell = cell as? AwayPlayersListUITableViewCell {
            
            //populating the cell
            awayPlayerCell.awayNameLabel.text = awayPlayer.name
            awayPlayerCell.awayRoleLabel.text = awayPlayer.role
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Reference: KIT305 iOS Firebase Tutorial
    //to pass through the selected awayPlayer when a table cell is tapped on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //checks if the segue is the segue to the details screen for away players
        if segue.identifier == "ShowAwayPlayerDetailSegue" {
            
            //down-cast from UIViewController to AwayDetailViewController (this could fail if we didn’t link things up properly)
            guard let awayDetailViewController = segue.destination as? AwayDetailViewController else {
                
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //down-cast from UITableViewCell to AwayPlayersUITableViewCell (this could fail if we didn’t link things up properly)
            guard let selectedAwayPlayerCell = sender as? AwayPlayersListUITableViewCell else {
                
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //get the number of row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
            guard let indexPath = tableView.indexPath(for: selectedAwayPlayerCell) else {
                
                fatalError("The selected cell is not displayed by the table")
            }
            
            //tell us which away player is selected using the row number
            let selectedAwayPlayer = awayPlayers[indexPath.row]
            
            //send in to AwayDetailViewController
            awayDetailViewController.awayPlayer = selectedAwayPlayer
            awayDetailViewController.awayPlayerIndex = indexPath.row
            
        }
        
        //check if segue identified is addHomePLayerSegue
        if segue.identifier == "AddNewAwayPlayerSegue" {
            if let addAwayPlayerScreen = segue.destination as? AwayDetailViewController {
                addAwayPlayerScreen.enteredAwayTeamName = enteredAwayTeamName
                
                //addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                
               // addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                //addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                //addHomePlayerScreen.enteredHomeNamePreviousView = enteredHomeTeamName
            }
        }
        
    }
    
    //Reference: Consultation with Lindsay
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear has been called from away player list")
        
        if self.isMovingFromParent {
            delegate?.didReceiveData(awayPlayers, isAway: true)
        }
    }

}
