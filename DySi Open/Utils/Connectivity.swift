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

    /**
     Display to user on device using alert view that they are not connected to the internet
     - Parameter viewController: The view controller the alert view is presented on
     - Parameter completion: The callback closure to call after user taps "Ok"
     */
    class func showAlertIfNotConnectedToInternet(viewController: UIViewController, completion: ((UIAlertAction) -> Void)?) -> Void {
        if !NetworkReachabilityManager()!.isReachable {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completion))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
