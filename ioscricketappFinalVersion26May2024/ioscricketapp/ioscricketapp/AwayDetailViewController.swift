//
//  AwayDetailViewController.swift
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
class AwayDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Reference: KIT305 iOS Firebase Tutorial MyLO
    var awayPlayer : Players?
    var awayPlayerIndex : Int?
    @IBOutlet var newAwayPlayerNameLabel: UITextField!
    
    
    var enteredAwayTeamName: String?
    @IBAction func addAwayPlayer(_ sender: Any) {
        //Reference: KIT305 Firebase iOS tutorial MyLO
        let database = Firestore.firestore()
        let awayPlayerCollection = database.collection("awayPlayersiOS")

        let newAwayPlayer = Players(name: newAwayPlayerNameLabel.text!, team: enteredAwayTeamName ?? "\(String(describing: enteredAwayTeamName))", role: "Regular player")
        
        do {
            try awayPlayerCollection.addDocument(from: newAwayPlayer, completion: { (err) in
                
                if let err = err {
                    print("Error adding new away player to Firebase: \(err)")
                } else {
                    print("Successfully add new away player to Firebase")
                    //Reference: KIT305 Firebase iOS tutorial MyLO
                    self.performSegue(withIdentifier: "addAwayPlayerSegue", sender: sender)
                }
            })
        } catch let error {
            print("Error while writing away player to Firestore: \(error)")
        }
    }
    
    @IBOutlet var newAwayPlayerName: UITextField!
    @IBAction func onSaveAwayPlayerChanges(_ sender: Any) {
        //Reference: iOS Firebase KIT305 Tutorial MyLO
        let database = Firestore.firestore()
        
        awayPlayer!.name = newAwayPlayerName.text!
        
        do {
            //updates data in Firebase Firestore (code from lectures and tutorial sheet)
            try database.collection("awayPlayersiOS").document(awayPlayer!.documentID!).setData(from: awayPlayer!){ err in
                
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    //this code will triger unwind segue manually
                    self.performSegue(withIdentifier: "saveAwaySegue", sender: sender)
                }
            }
        } catch { print("Error updating document \(error)")}
    }
    @IBAction func deleteAwayPlayer(_ sender: Any) {
        
        //display the alert box
        //Reference: from tutorial sheet iOS KIT305 ("Extending the Program")
        //kind of working but not really and it deletes the whole thing either way, maybe due to the position? --> also see the displayed player name in the alert box
        let alert = UIAlertController(
            title: "Confirm to delete player",
            message: "Are you sure you would like to delete \(newAwayPlayerName.text!)? This action is IRREVERSIBLE", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.cancel,
                                      handler: nil))
        //Reference: Reddit "Performing Segue After User Interacts with Alert View" (ios_game_dev)
        alert.addAction(UIAlertAction(title: "Delete this player",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
            //get database connection
            let database = Firestore.firestore()
            self.awayPlayer!.name = self.newAwayPlayerName.text!
            
            do {
                //Reference: Firebase documentation
                //Reference: iOS Firebase tutorial KIT305 MyLO
                try database.collection("awayPlayersiOS").document(self.awayPlayer!.documentID!).delete(){ [self] err in
                    
                    if let err = err {
                        print("Error whilst deleting away player: \(err)")
                    } else {
                        print("The away player has been deleted successfully")
                        
                        self.performSegue(withIdentifier: "deleteAwayPlayerSegue", sender: sender)
                    }
                }
            } catch { print("Error deleting the document \(error)")}
            self.performSegue(withIdentifier: "deleteAwayPlayerSegue", sender: sender)
        }))
        //show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //TODO: gallery option here
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
        
        //Reference: KIT305 iOS Firebase Tutorial
        if let displayAwayPlayer = awayPlayer {
            self.navigationItem.title = displayAwayPlayer.name
            newAwayPlayerName.text = displayAwayPlayer.name
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
