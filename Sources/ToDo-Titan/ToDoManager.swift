//
//  ToDo.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Rope

struct ToDoManager {
    
    func add(json: String) -> Bool {
        
        var result = true
        
        do {
            try PSQL().query("INSERT INTO items (data) VALUES ($1)", params: [json])
        } catch {
            result = false
        }
        
        return result
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
    
    func read() -> [String: Any]? {
        
        var returnValue = [String: Any]()
        var items = [[String: Any]]()
        
        do {
            try PSQL().query("SELECT * FROM ITEMS") {
                result in
                
                for row in result.rows() {
                    
                    dump(row)
                    
                    //Items MUST have an ID AND a title
                    if let id = row["id"] as? Int, let title = row["title"] as? String {
                        
                        var item = [String: Any]()
                        
                        item["id"] = id
                        item["title"] = title
                    
                        items.append(item)
                    }
                }
            }
        } catch {
            return nil
        }
        
        if !items.isEmpty {
            returnValue["items"] = items
        }
        
        dump(returnValue)
        
        return returnValue
        
    }
    
}
