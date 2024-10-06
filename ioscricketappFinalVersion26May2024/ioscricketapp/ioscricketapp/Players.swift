//
//  Players.swift
//  ioscricketapp
//
//  Created by mobiledev on 7/5/2024.
//

//import Foundation
//content of this file is from iOS firebase tutorial
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Players : Codable {
    @DocumentID var documentID:String?
    var name:String
    var team:String
    var role:String
}
