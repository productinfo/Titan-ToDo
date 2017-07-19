//
//  Routing.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Titan
import Foundation

struct Router {
    func makeRoutes(_ app: Titan) {
        
        /// Default route returns all items
        app.get("/") { req, _ in
            
            // Get an array of json objects representing all todo items in the database
            if let dict = ToDoManager().getAll() {
                if let jsonString = makeJSONString(dict) {
                    return (req, Response(200, jsonString, [Header(name: "Content-Type", value: "application/json")]))
                }
            }
            
            // We failed to get a dictionary with all items, send back an error
            return (req, Response(500))
        }
        
        
        /// Accept New Items
        app.post("/") { req, _ in
            
            guard var dict = req.json as? [String: Any] else {
                // Bad json was sent to us, tell them it's a bad request
                return (req, Response(400))
            }
            
            guard dict["title"] != nil else {
                // This is not a valid todo item, which must at least contain a title
                return (req, Response(400))
            }
            
            // Default the new item as not completed
            dict["completed"] = false
            
            // Get new json string to store in postgres including new completed status
            if let json = makeJSONString(dict) {
                
                // Add to database, get new id if successful
                if let id = ToDoManager().add(json: json) {
                    
                    // Prepare to return it by injecting a URL with the new id
                    dict["url"] = "http://34.229.61.202/item/\(id)/"
                    
                    // Return the new object to the requester as json
                    if let response = makeJSONString(dict) {
                        return(req, Response(200, response, [Header(name: "Content-Type", value: "application/json")]))
                    }
                }
                
            }
            
            // Something went wrong
            return (req, Response(500))
        }
        
        
        /// Delete Everything
        app.delete("/") { req, _ in
            
            if ToDoManager().deleteAll() {
                return(req, Response(200))
            }
            
            // Delete failed, send server error
            return(req, Response(500))
        }
        
        // Get Individual ToDo Items
        app.get("/item/*") {
            req, param, _ in
            
            if let id = Int(param) {
                if let dict = ToDoManager().getItem(forID: id) {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        if let jsonString = String(data: json, encoding: .utf8) {
                            return (req, Response(200, jsonString, [Header(name: "Content-Type", value: "application/json")]))
                        }
                    } catch {
                        // We messed up somewhere
                        return(req, Response(500))
                    }
                }
                
            }
            
            // We didn't get a valid item id, yell at the requester
            return(req, Response(400))
        }
        
        
        // Update Individual Item
        app.patch("/item/*") {
            req, param, _ in
            
            // Validate JSON (This will fail if the request body cannot convert)
            guard var dict = req.json as? [String: Any] else {
                // Bad json was sent to us, tell them it's a bad request
                return (req, Response(400))
            }
            
            // Make sure we have a valid ID to update
            if let id = Int(param) {
                
                if let originalItem = ToDoManager().getItem(forID: id) {
                    var newItem = originalItem
                    
                    if let completed = dict["completed"] as? Bool {
                        newItem["completed"] = completed
                    }
                    
                    if let order = dict["order"] as? Int {
                        newItem["order"] = order
                    }
                    
                    if let title = dict["title"] as? String {
                        newItem["title"] = title
                    }
                    
                    if let updatedItem = ToDoManager().updateItem(forID: id, withItem: newItem) {
                        return (req, Response(200, updatedItem, [Header(name: "Content-Type", value: "application/json")]))
                    }
                }
                
            }
            
            //We had invalid JSON or the URL ID was bad, yell at the requester
            return(req, Response(400))
        }
        
        
        /// Delete Individual Item
        app.delete("/item/*") {
            req, param, _ in
            
            // Check for a valid ID to work with
            if let id = Int(param) {
                if ToDoManager().deleteItem(withID: id) {
                    return(req, Response(200))
                } else {
                    return (req, Response(500))
                }
            }
            
            //We had an invalid URL ID, yell at the requester
            return(req, Response(400))
        }
    }
}
