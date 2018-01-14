//
//  PlannerEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct PlannerEntity : Codable {
    var title : String
    var plannerID : String
    var recipeID : String
    var done : Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case plannerID
        case recipeID
        case done
    }
    
    func getPlanner() -> PlannerEntity? {
        return nil
        // @TODO
    }
    
    func getRecipe() -> SmallRecipeEntity? {
        return nil
        // @TODO
    }
}


