//
//  ToDo.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Rope
import Foundation

struct ToDoManager {
    
    func add(json: String) -> Int? {
        
        var id: Int? = nil
        
        do {
            try PSQL().query("INSERT INTO items (data) VALUES ($1) RETURNING id", params: [json]) {
                result in
                
                for row in result.rows() {
                    id = row["id"] as? Int
                }
            }
        } catch {
            return nil
        }
        
        return id
    }
    
    func delete() -> Bool {
        
        var result = true
        
        do  {
            try PSQL().query("DELETE FROM items")
        } catch {
            result = false
        }
        
        return result
    }
    
    func getAll() -> [[String: Any]]? {
        
        var items = [[String: Any]]()
        
        do {
            try PSQL().query("SELECT * FROM ITEMS") {
                result in
                
                for row in result.rows() {
                    
                    // Items MUST have an ID, json data that was originally stored form the initial post request, and completed value
                    // JSON data should have at least a "title" in it
                    if let id = row["id"] as? Int, let data = row["data"] as? [String: Any] {
                        
                        //Copy item data for injection
                        var item = data
                        
                        // Inject id based url into item to send as JSON
                        item["url"] = "http://localhost:8000/item/\(id)/"
                        
                        items.append(item)
                    }
                }
            }
        } catch {
            return nil
        }
        
        return items
        
    }
    
    func getItem(forID id: Int) -> [String: Any]? {
        
        var json: [String: Any]? = nil
        
        do {
            try PSQL().query("SELECT * FROM ITEMS WHERE ID = $1", params: ["\(id)"]) {
                result in
                
                for row in result.rows() {
                    
                    // Items MUST have an ID, json data that was originally stored form the initial post request, and completed value
                    // JSON data should have at least a "title" in it
                    if let id = row["id"] as? Int, let data = row["data"] as? [String: Any] {
                        
                        //Copy item data for injection
                        var item = data
                        
                        // Inject id based url into item to send as JSON
                        item["url"] = "http://localhost:8000/item/\(id)/"
                        
                        json = item
                    }
                }
            }
        } catch {
            return nil
        }
        
        return json
    }
    
    func updateItem(forID id: Int, withItem item: [String: Any]) -> (Bool, String) {
        
        var success = false
        var jsonString = ""
        
        do {
            let data = try JSONSerialization.data(withJSONObject: item, options: [])
            if let json = String(data: data, encoding: .utf8) {
                try PSQL().query("UPDATE items SET data = $1 WHERE id = $2", params: ["\(json)", "\(id)"])
                success = true
                jsonString = json
            }
        } catch {
            success = false
        }
        print(jsonString)
        return (success, jsonString)
        
    }
    
    func deleteItem(withID id: Int) -> Bool {
        
        var success = false
        
        do {
            try PSQL().query("DELETE FROM items WHERE id = $1", params: ["\(id)"])
            success = true
        } catch {
            success = false
        }
        
        return success
        
    }
    
}
