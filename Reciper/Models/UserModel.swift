//
//  UserModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class UserModel : FirebaseModel {
    static let shared = UserModel()
    
    var user: User!
    
    var householdModel: HouseholdModel!
    
    override init() {
        super.init()
        user = Auth.auth().currentUser!
        householdModel = HouseholdModel.shared
        
        self.ref = self.db.reference(withPath: "users").child(user.uid)
    }
    
    func userInit() {
        self.allHouseholdIDs(.once) { (households) in
            guard self.currentHouseholdID() == nil else {
                return
            }
            
            var newHouseholdID: String! = nil
            if households.isEmpty {
                let household = HouseholdEntity(id: nil, title: "Mijn househouden", userIDs: [])
                newHouseholdID = self.householdModel.addHousehold(household)
            } else {
                newHouseholdID = households[0]
            }
            self.setCurrentHousehold(newHouseholdID)
        }
    }
    
    // Check if this is the users first signin
    func userExists(with: @escaping (Bool) -> ()) {
        self.check(self.ref, .once) { (userSnap) in
            with(userSnap.exists())
        }
    }
    
    func currentHouseholdID() -> String? {
        return UserDefaults.standard.string(forKey:"currentHousehold")
    }
    
    func setCurrentHousehold(_ householdID: String?) {
        if let id = householdID {
            UserDefaults.standard.set(id, forKey:"currentHousehold")
        }
    }
    
    func allHouseholdIDs(_ observe: ObserveOrOnce = .once, with: @escaping ([String]) -> ()) {
        self.check(self.ref.child("households"), observe) { (results) in
            let households = results.value as? [String: Bool] ?? [:]
            with(Array(households.keys))
        }
    }
    
    func allHouseholds(_ observe: ObserveOrOnce = .once, with: @escaping ([HouseholdEntity]) -> ()) {
        self.allHouseholdIDs(observe) { (results) in
            self.householdModel.getMany(results, with: with)
        }
    }
    
}


