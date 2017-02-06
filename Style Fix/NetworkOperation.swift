//
//  NetworkOperation.swift
//  Anak
//
//  Created by Vidamo on 27/7/2016.
//  Copyright © 2016 Vidamo. All rights reserved.
//

import UIKit
import Alamofire

class NetworkOperation: ConcurrentOperation {

    let URLString: String
    let params: [String: AnyObject]
    let method: HTTPMethod
    let networkOperationCompletionHandler: (_ responseObject: Any?, _ error: Error?) -> ()
    let networkOperationFailureHandler: (_ localizedError: String?) -> ()
    
    weak var request: Alamofire.Request?
    
    init(URLString: String, method: HTTPMethod, params: [String: AnyObject], networkOperationCompletionHandler: @escaping (_ responseObject: Any?, _ error: Error?) -> (), failure networkOperationFailureHandler: @escaping (_ localizedError: String?) -> ()) {
        self.URLString = URLString
        self.method = method
        self.params = params
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        self.networkOperationFailureHandler = networkOperationFailureHandler
        super.init()
    }

    override func main() {
        
        request = Alamofire.request(URLString, method: method, parameters: params)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    if response.result.error?._code != -999 {
                        print("Error: \(response.result.error)")
                        self.networkOperationFailureHandler(response.result.error?.localizedDescription)
                    }
                    return
                }
                
                self.networkOperationCompletionHandler(response.result.value, response.result.error)
                
                self.completeOperation()
        }
    }
    
    override func cancel() {
        request?.cancel()
        super.cancel()
    }
}
