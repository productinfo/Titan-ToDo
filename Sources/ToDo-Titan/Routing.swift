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
            
            var response = "{ }"
            
            if let dict = jsonRepresentation {
                //Our query ran successfully, we should ahve at least an empty array to work with
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    if let jsonString = String(data: json, encoding: .utf8) {
                        response = jsonString
                    }
                    
                } catch {
                    return (req, Response(500))
                }
            }
            
            //Something Failed On Our End, Send Back an Error
            return (req, Response(200, response, [Header(name: "Content-Type", value: "application/json")]))
        }
        
        /// Accept New ToDo Items
        app.post("/") { req, _ in
            
            //Validate JSON (This will fail if the request body cannot convert)
            guard var dict = req.json as? [String: Any] else {
                return (req, Response(400))
            }
            
            //Get String Representations to Store in Postgres
            let json = req.body
            
            //Add to Database, Check for Success
            if let id = ToDoManager().add(json: json) {
                dict["url"] = "/item/\(id)/"
            }
            
            dict["success"] = true
            dict["completed"] = false
            
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                if let response = String(data: data, encoding: .utf8) {
                    return(req, Response(200, response, [Header(name: "Content-Type", value: "application/json")]))
                }
            }
            
            //Bad json was sent to us, tell them it's a bad request
            return (req, Response(400))
        }
        
        /// Delete the ToDos
        app.delete("/") { req, _ in
            
            if ToDoManager().delete() {
                return(req, Response(200))
            }
            
            //If delete fails, return a server error
            return(req, Response(500))
        }
    }
}
