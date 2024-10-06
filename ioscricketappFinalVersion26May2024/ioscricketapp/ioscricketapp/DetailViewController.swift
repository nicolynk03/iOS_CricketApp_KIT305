//
//  DetailViewController.swift
//  ioscricketapp
//
//  Created by mobiledev on 11/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Gallery option functionality
//Reference: KIT305 sample code CameraExample
class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var newNameLabel: UITextField!
    @IBOutlet var newPlayerNameLabel: UITextField!
    
    //Reference: KIT305 Firebase iOS tutorial
    var homePlayer : Players?
    var homePlayerIndex: Int?
    
    var enteredHomeNamePreviousView: String?
    
    //Reference: KIT305 Firebase iOS tutorial
    @IBOutlet var enteredHomeTeamLabel: UILabel!
    
    var enteredHomeTeamName: String?
    
    @IBAction func addHomePlayer(_ sender: Any) {
        //Reference: KIT305 Firebase iOS tutorial MyLO
        let database = Firestore.firestore()
        let homePlayerCollection = database.collection("homePlayersiOS")
        
        //var homePlayerName: String
        //var homePlayerRole: String
        //var homePlayerTeam: String
        
        //homePlayer!.name = newPlayerNameLabel.text!
        //homePlayer!.role = "Regular player"
        //homePlayer!.team = enteredHomeTeamName!
        //self.enteredHomeTeamLabel.text = enteredHomeTeamName;
        
        //homePlayerName = homePlayer!.name
        //homePlayerRole = homePlayer!.role
        //homePlayerTeam = homePlayer!.team
        
        
        let newHomePlayer = Players(name: newPlayerNameLabel.text!, team: enteredHomeTeamName ?? "\(String(describing: enteredHomeTeamName))", role: "Regular player")
        
        do {
            try homePlayerCollection.addDocument(from: newHomePlayer, completion: { (err) in
                
                if let err = err {
                    print("Error adding new home player to Firebase: \(err)")
                } else {
                    print("Successfully add new home player to Firebase")
                    //Reference: KIT305 Firebase iOS tutorial MyLO
                    self.performSegue(withIdentifier: "addSegue", sender: sender)
                }
            })
        } catch let error {
            print("Error while writing home player to Firestore: \(error)")
        }
        
    }
    @IBAction func deletePlayer(_ sender: Any) {
        //Reference: KIT305 iOS tutorial
        //create an alert view
        /*let alert = UIAlertController(title: "Confirm deletion", message: "Are you sure you would like to delete this player?", preferredStyle: UIAlertController.Style.alert)
        
        //add action (button)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))*/
        //display the alert box
        //Reference: from tutorial sheet iOS KIT305 ("Extending the Program")
        //kind of working but not really and it deletes the whole thing either way, maybe due to the position? --> also see the displayed player name in the alert box
        let alert = UIAlertController(
            title: "Confirm to delete player",
            message: "Are you sure you would like to delete \( newNameLabel.text!)? This action is IRREVERSIBLE", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.cancel,
                                      handler: nil))
        //Reference: Reddit "Performing Segue After User Interacts with Alert View" (ios_game_dev)
        alert.addAction(UIAlertAction(title: "Delete this player",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
            let database = Firestore.firestore()
            self.homePlayer!.name = self.newNameLabel.text!
            
            do {
                //Reference: Firebase documentation
                //Reference: iOS Firebase tutorial KIT305 MyLO
                //Reference: suggestions and fixes from Lindsay
                try database.collection("homePlayersiOS").document(self.homePlayer!.documentID!).delete(){ [self] err in
                    
                    if let err = err {
                        print("Error whilst deleting home player: \(err)")
                    } else {
                        print("The home player has been deleted successfully")
                        
                        
                        print("The home player HAS been deleted successfully")
                        
                        self.performSegue(withIdentifier: "deleteHomePlayerSegue", sender: sender)                    //show alert
                        //self.performSegue(withIdentifier: "deleteHomePlayerSegue", sender: sender)
                        
                        //self.performSegue(withIdentifier: "saveSegue", sender: sender)
                        //self.performSegue(withIdentifier: "saveHomePlayerChangeSegue", sender: sender)
                        //self.performSegue
                    }
                }
            } catch { print("Error deleting the document \(error)")}
        }))
        self.present(alert, animated: true, completion: nil)
        //Reference: Firebase documentation
        //database.collection("homePlayersiOS").document(homePlayer!.documentID!).delete()
        
    }
    @IBAction func onSave(_ sender: Any) {
        //Reference: iOS Firebase Tutorial
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let database = Firestore.firestore()
        
        homePlayer!.name = newNameLabel.text!
        do {
            //update data in Firebase Firestore (from lectures and tutorial sheet in MyLO)
            try database.collection("homePlayersiOS").document(homePlayer!.documentID!).setData(from: homePlayer!){ err in
                
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated for home players")
                    //this code triggers unwind segue manually
                    self.performSegue(withIdentifier: "saveHomePlayerChangeSegue", sender: sender)
                }
            }
        } catch { print("Error updating document \(error)")}
    }
    
    //Gallery option functionality
    //Reference: KIT305 sample code CameraExample
    @IBOutlet weak var imageView: UIImageView!
    
    //Gallery option functionality
    //Reference: KIT305 sample code CameraExample
    @IBAction func galleryButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("Gallery option available")
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Gallery option functionality
    //Reference: KIT305 sample code CameraExample
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    //Gallery option functionality
    //Reference: KIT305 sample code CameraExample
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Reference: KIT305 Firebase iOS tutorial
        if let displayHomePlayer = homePlayer {
            self.navigationItem.title = displayHomePlayer.name
            newNameLabel.text = displayHomePlayer.name
        }
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
