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
        
        /// Default Route
        app.get("/") { req, _ in
            let jsonRepresentation = ToDoManager().getAll()
            
            if let dict = jsonRepresentation {
                //Our query ran successfully, we should ahve at least an empty array to work with
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    if let jsonString = String(data: json, encoding: .utf8) {
                        return (req, Response(200, jsonString, [Header(name: "Content-Type", value: "application/json")]))
                    }
                    
                } catch {
                    //Something Failed On Our End, Send Back an Error
                    return (req, Response(500))
                }
            }
            
            //Something Failed On Our End, Send Back an Error
            return (req, Response(500))
        }
        
        /// Accept New ToDo Items
        app.post("/") { req, _ in
            
            // Validate JSON (This will fail if the request body cannot convert)
            guard var dict = req.json as? [String: Any] else {
                // Bad json was sent to us, tell them it's a bad request
                return (req, Response(400))
            }
            
            // Default New ToDo to Not Completed
            dict["completed"] = false
            
            // Get String Representations to Store in Postgres
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                if let json = String(data: data, encoding: .utf8) {
                    // Add to Database, Check for Success
                    if let id = ToDoManager().add(json: json) {
                        dict["url"] = "http://localhost:8000/item/\(id)/"
                        
                        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                            if let response = String(data: data, encoding: .utf8) {
                                return(req, Response(200, response, [Header(name: "Content-Type", value: "application/json")]))
                            }
                        }
                    }
                    
                }

            } catch {
                // Something Went Wrong
                return (req, Response(500))
            }
            
            // Something Went Wrong
            return (req, Response(500))
        }
        
        /// Delete the ToDos
        app.delete("/") { req, _ in
            
            if ToDoManager().delete() {
                return(req, Response(200))
            }
            
            //If delete fails, return a server error
            return(req, Response(500))
        }
        
        // Get Individual ToDo Items
        app.get("/item/*") {
            req, param, _ in
            
            //Get Item with ID
            if let id = Int(param) {
                if let dict = ToDoManager().getItem(forID: id) {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        if let jsonString = String(data: json, encoding: .utf8) {
                            return (req, Response(200, jsonString, [Header(name: "Content-Type", value: "application/json")]))
                        }
                    } catch {
                        return(req, Response(500))
                    }
                }
                
            }
            
            //Placeholder
            return(req, Response(400))
        }
    }
}
