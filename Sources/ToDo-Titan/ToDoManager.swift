//
//  ToDo.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Rope

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
                    if let id = row["id"] as? Int, let data = row["data"] as? [String: Any], let completed = row["completed"] as? Bool {
                        
                        //Copy item data for injection
                        var item = data
                        
                        // Inject row id into item
                        item["id"] = id
                        item["completed"] = completed
                        item["url"] = "/item/\(id)/"
                        
                        items.append(item)
                    }
                }
            }
        } catch {
            return nil
        }
        
        return items
        
    }
    
    func getLastInsertedId() -> Int? {
        
        var id: Int? = nil
        
        do {
            try PSQL().query("SELECT currval('items_id_seq')") {
                result in
                
                for row in result.rows() {
                    
                }
            }
        } catch {
            return nil
        }
        
        return id
        
    }
    
}
