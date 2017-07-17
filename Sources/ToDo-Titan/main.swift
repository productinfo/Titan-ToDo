import Titan
import TitanKituraAdapter
import TitanCORS
import Foundation

let app = Titan()

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
    
    //Validate JSON
    guard var dict = req.json as? [String: Any] else {
        return (req, Response(400))
    }
    
    //Get String Representations to Store in Postgres
    let json = req.body
    
    var success = true
    
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

/// Handle 404 Errors
func send404IfNoMatch(req: RequestType, res: ResponseType) -> (RequestType, ResponseType) {
    var res = res.copy()
    if res.code < 200 {
        res.code = 404
        res.body = "Page Not Found"
    }
    return (req, res)
}

/// use the 404 middleware on all routes and request methods
app.addFunction(send404IfNoMatch)

/// Allow All CORS for API Testing
/// Ensure that you're sending back:
///  - an `access-control-allow-origin: *` header for all requests
///  - an `access-control-allow-headers` header which lists headers such as "Content-Type"
addInsecureCORSSupport(app)

// start the Kitura webserver on port 8000
TitanKituraAdapter.serve(app.app, on: 8000)
