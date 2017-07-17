//
//  Database.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Rope

enum DBError: Error {
    case ConnectionError
    case QueryError
}

struct PSQL {
    
    typealias PSQLCompletion = (RopeResult) -> Void
    
    func query(_ query: String) throws {
        
        let creds = RopeCredentials(host: "localhost", port: 5432,  dbName: "todo",
                                    user: "dev", password: "dev")
        
        // establish connection using the struct, returns nil on error
        guard let db = try? Rope.connect(credentials: creds) else {
            throw DBError.ConnectionError
        }
        
        guard let _ = try? db.query(query) else {
            throw DBError.QueryError
        }
    }
    
    func query(_ query: String, params: [Any]) throws {
        
        let creds = RopeCredentials(host: "localhost", port: 5432,  dbName: "todo",
                                    user: "dev", password: "dev")
        
        // establish connection using the struct, returns nil on error
        guard let db = try? Rope.connect(credentials: creds) else {
            throw DBError.ConnectionError
        }
        
        guard let _ = try? db.query(query, params: params) else {
            throw DBError.QueryError
        }
    }
    
    func query(_ query: String, completion: PSQLCompletion) throws {
        
        let creds = RopeCredentials(host: "localhost", port: 5432,  dbName: "todo",
                                    user: "dev", password: "dev")
        
        // establish connection using the struct, returns nil on error
        guard let db = try? Rope.connect(credentials: creds) else {
            throw DBError.ConnectionError
        }
        
        do {
            let results = try db.query(query)
            completion(results)
        } catch {
            throw DBError.QueryError
        }
    }
    
    func query(_ query: String, params: [Any], comletion: PSQLCompletion) throws {
        
        let creds = RopeCredentials(host: "localhost", port: 5432,  dbName: "todo",
                                    user: "dev", password: "dev")
        
        // establish connection using the struct, returns nil on error
        guard let db = try? Rope.connect(credentials: creds) else {
            throw DBError.ConnectionError
        }
        
        do {
            let results = try db.query(query, params: params)
            comletion(results)
        } catch {
            throw DBError.QueryError
        }
        
        
    }
    
}
