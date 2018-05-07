//
//  Connectivity.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func showAlertIfNotConnectedToInternet(viewController: UIViewController, completion: ((UIAlertAction) -> Void)?) -> Void {
        if !NetworkReachabilityManager()!.isReachable {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completion))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
