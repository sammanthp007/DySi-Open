//
//  UIViewController.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayMessageToUserUsingAlert(title: String, message: String, style: UIAlertControllerStyle = UIAlertControllerStyle.alert, completion: (() -> Void)?, okButtonText: String, actionStyle: UIAlertActionStyle = UIAlertActionStyle.default, afterHittingAction: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: okButtonText, style: UIAlertActionStyle.default, handler: afterHittingAction)
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
}
