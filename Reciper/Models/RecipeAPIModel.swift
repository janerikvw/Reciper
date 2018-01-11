//
//  RecipeAPIModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeAPIModel {
    static let shared = RecipeAPIModel()
    
    let baseURL = URL(string: "http://reciper.janerik.net/")!
    
    func search(searchTerm: String,
                dishType: String = "all",
                tags: String = "",
                maxTiming: Int? = nil,
                totalResults: Int = 20,
                startResults: Int = 0,
                completion: @escaping (SearchRecipeResultsEntity?
        ) -> Void) {
        
        let searchBaseURL = baseURL.appendingPathComponent("search")
        
        // Append search terms
        var componentsURL = URLComponents(url: searchBaseURL, resolvingAgainstBaseURL: true)!
        componentsURL.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "s", value: String(startResults)),
            URLQueryItem(name: "n", value: String(totalResults))
        ]
        let searchURL = componentsURL.url!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let searchResults = try? jsonDecoder.decode(SearchRecipeResultsEntity.self, from: data) {
                completion(searchResults)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getRecipe(recipeID: String, completion: @escaping (FullRecipeEntity?) -> Void) {
        let recipeURL = baseURL.appendingPathComponent("single").appendingPathComponent(recipeID)
        let task = URLSession.shared.dataTask(with: recipeURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let recipe = try? jsonDecoder.decode(FullRecipeEntity.self, from: data) {
                completion(recipe)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
}