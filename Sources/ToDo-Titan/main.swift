import Titan
import TitanKituraAdapter
import TitanCORS

let app = Titan()

/// Add Our API Routes
Router().makeRoutes(app)

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
