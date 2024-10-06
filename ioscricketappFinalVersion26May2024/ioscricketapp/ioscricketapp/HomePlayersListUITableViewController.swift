//
//  HomePlayersListUITableViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 10/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Reference: ChatGPT to use Delegate to transfer data
class HomePlayersListUITableViewController: UITableViewController {
    
    //Reference: KIT305 Firebase iOS Tutorial MyLO
    var homePlayers = [Players]()
    var enteredHomeTeamName:String?
    
    //for home team
    var enteredHomeNamePreviousView: String?
    
    weak var delegate: MatchPageViewControllerDelegate?
    
    //Reference: KIT305 Firebase iOS Tutorial MyLO
    //updating data using unwind segues
    @IBAction func unwindToHomePlayersList(sender: UIStoryboardSegue) {
        
        //Reference: KIT305 iOS Firebase Tutorial MyLO
        //we could reload from db, but this will use local homePlayer object
        //updates unwind segue
        if let detailScreen = sender.source as? DetailViewController {
            homePlayers[detailScreen.homePlayerIndex!] = detailScreen.homePlayer!
            tableView.reloadData()
        }
        
        
        print("save segue will go here :)")
    }
    
    @IBAction func goingBackToHomePlayersListFromAddSection(sender: UIStoryboardSegue) {
        
        //Reference: KIT305 Firebase iOS update tutorial
        /*if let addHomePlayerScreen = sender.source as? DetailViewController {
            homePlayers[addHomePlayerScreen.homePlayerIndex!] = addHomePlayerScreen.homePlayer!
            tableView.reloadData()
        }*/
        
        //if let addHomePlayerScreen = sender.source as? 
        self.viewDidLoad()
        
        print("save segue will go here from adding players  :)")
    }
    
    @IBAction func backToHomePlayersListAfterDelete(sender: UIStoryboardSegue) {
        self.viewDidLoad()
        print("delete segue goes here :)")
    }
    
    @IBAction func unwindToHomePlayersListWithCancel(sender: UIStoryboardSegue) {
        print("cancelled")
    }

    @IBOutlet var addHomePlayersBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Reference: Firebase iOS Tutorial MyLO KIT305
        //get database connection
        let database = Firestore.firestore()
        let homePlayerCollection = database.collection("homePlayersiOS")
        //to clear the list (avoid displaying doubles)
        homePlayers.removeAll()
        //loads data
        homePlayerCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Players.self)
                    }
                    switch conversionResult {
                        case .success(let homePlayer):
                            print("Home player: \(homePlayer)")
                        
                            self.homePlayers.append(homePlayer)
                        case .failure(let error):
                            print("Error decoding home player: \(error)")
                    }
                }
                
                //TODO: put here
                //currently is working
                //Reference: Lindsay's in-class suggestion
                if self.homePlayers.count == 5 {
                    self.addHomePlayersBtn.isEnabled = false
                } else {
                    self.addHomePlayersBtn.isEnabled = true
                }
                
                self.tableView.reloadData()
            }
        }
        
        
    }
    @IBAction func addHomePlayersBtnTapped(_ sender: UIBarButtonItem) {
        //currently isn't working lol
        /*if homePlayers.count == 5 {
            addHomePlayersBtn.isEnabled = false
        }*/
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Reference: Firebase iOS Tutorial MyLO KIT305
        // our table only consists of 1 section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Reference: Firebase iOS Tutorial MyLO KIT305
        //specify how many rows each section has
        return homePlayers.count
    }
    
    //Reference: KIT305 Firebase iOS tutorial
    //returns new instance of UITableViewCell to show the table's row (determined by parameter indePath)
    //used to populate UILabels of the HomePlayersUITableViewCell with data from homePlayers array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePlayersListUITableViewCell", for: indexPath)
        
        //get the home player for a specific row
        let homePlayer = homePlayers[indexPath.row]
        
        //down-cast cell fro UITableViewCell to cell class HomePlayersUITableViewCell
        // could fail --> we use "if let"
        if let homePlayerCell = cell as? HomePlayersListUITableViewCell {
            //populating the cell
            homePlayerCell.nameLabel.text = homePlayer.name
            homePlayerCell.roleLabel.text = homePlayer.role
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
    
    //Reference: Firebase iOS tutorial KIT305 MyLO
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //checks if this is the segue to the details screen
        if segue.identifier == "ShowHomePlayersDetailSegue" {
            
            //down-cast from UIViewController to DetailViewController (could fail if we didn’t link things up properly)
            guard let detailViewController = segue.destination as? DetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //down-cast from UITableViewCell to HomePlayersUITableViewCell (this could fail if we didn’t link things up properly)
            guard let selectedHomePlayerCell = sender as? HomePlayersListUITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //gets the number of row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
            guard let indexPath = tableView.indexPath(for: selectedHomePlayerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //see which player is selected using the row number
            let selectedHomePlayer = homePlayers[indexPath.row]
            
            //send it to the details screen
            detailViewController.homePlayer = selectedHomePlayer
            detailViewController.homePlayerIndex = indexPath.row
        }
        
        //check if segue identified is addHomePLayerSegue
        if segue.identifier == "AddNewHomePlayerSegue" {
            if let addHomePlayerScreen = segue.destination as? DetailViewController {
                addHomePlayerScreen.enteredHomeTeamName = enteredHomeTeamName
                
                //addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                
               // addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                //addHomePlayerScreen.enteredHomeTeamName = enteredHomeNamePreviousView
                //addHomePlayerScreen.enteredHomeNamePreviousView = enteredHomeTeamName
            }
        }
        
        //check if segue identified is transferHomePlayersToMainScreenSegue
        //to transfer data of registered home players to main screen (MatchPageViewController)
        // i think there is something wrong with the segue made on 18 May 2024
        /*
        if segue.identifier == "transferHomePlayersToMainScreenSegue" {
            if let transferRegisteredHomePlayers = segue.destination as? MatchPageViewController {
                transferRegisteredHomePlayers.registeredHomePlayers = homePlayers
                //Reference: ChatGPT
                transferRegisteredHomePlayers.delegate = self
            }
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear has been called")
        
        if self.isMovingFromParent {
            delegate?.didReceiveData(homePlayers, isAway: false)
        }
    }
    
    
}
