import Titan
import TitanKituraAdapter

let app = Titan()

/// Hello World, req is sent to next matching route
app.get("/") { req, _ in
    return (req, Response(200, "Hello World"))
}

/// 2 parameters in URL
app.delete("/item/*/subitem/*") { req, param1, param2, _ in
    let text = "I will delete \(param2) in \(param1)"
    return(req, Response(200, text))
}

/// parse JSON sent via POST, return 400 on parsing error
app.post("/data") { req, _ in
    guard let json = req.json as? [String: Any] else {
        return (req, Response(400))
    }
    return(req, Response(200, "I received \(json)"))
}

/// let’s manipulate the response of all GET routes
/// and yes, that is already a simple example for a middleware!
app.get("*") { req, res in
    var newRes = res.copy()  // res is a constant, so we need to copy
    newRes.body += " and hello from the middleware!"
    return (req, newRes)  // will return "Hello World and hello from the middleware!"
}

/// a quick in-line middleware function to optionally set 404 response code
/// can be used by other routes / functions
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

// start the Kitura webserver on port 8000
TitanKituraAdapter.serve(app.app, on: 8000)
