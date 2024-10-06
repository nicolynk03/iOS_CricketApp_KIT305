//
//  Match.swift
//  ioscricketapp
//
//  Created by mobiledev on 14/5/2024.
//

//import Foundation
//Reference: Firebase iOS KIT305 tutorial from MyLO
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Reference: ChatGPT, making Swift struct to have an array
struct scoreDetails : Codable {
    var runs: Int32
    var wickets: String
    var striker: String
    var nonStriker: String
    var bowler: String
}


public struct Match : Codable {
    @DocumentID var documentID:String?
    var homeTeam:String
    var awayTeam:String
    //Reference: ChatGPT, making Swift struct to have an array
    var balls:[scoreDetails]
}
