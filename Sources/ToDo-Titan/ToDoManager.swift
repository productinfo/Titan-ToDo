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
    
    func deleteAll() -> Bool {
        
        var result = false
        
        do  {
            try PSQL().query("DELETE FROM items")
            result = true
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
                    
                    // Items will have an ID, json data that was originally stored form the initial post request
                    if let id = row["id"] as? Int, var item = row["data"] as? [String: Any] {
                        
                        // Inject id based url into item to send as JSON
                        item["url"] = "\(Config().hostname)/item/\(id)/"
                        
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
                    
                    // Items will have an ID, json data that was originally stored form the initial post request
                    if let id = row["id"] as? Int, var item = row["data"] as? [String: Any] {
                        
                        // Inject id based url into item to send as JSON
                        item["url"] = "\(Config().hostname)/item/\(id)/"
                        
                        json = item
                    }
                }
            }
        } catch {
            json = nil
        }
        
        return json
    }
    
    func updateItem(forID id: Int, withItem item: [String: Any]) -> String? {
        
        var jsonString: String? = nil
        
        do {
            if let json = makeJSONString(item) {
                try PSQL().query("UPDATE items SET data = $1 WHERE id = $2", params: ["\(json)", "\(id)"])
                jsonString = json
            }
        } catch {
            jsonString = nil
        }
        
        return jsonString
        
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
