//
//  UIViewController.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Display to the user on their device any message using alert view
     - Parameter title: The title of the alert view
     - Parameter message: The body of the alert view
     - Parameter style: The style of the alert view
     - Parameter completion: The completion handler is called after the viewDidAppear(_:) method is called on the presented view controller.
     - Parameter okButtonText: The text to replace "Ok" action
     - Parameter actionStyle: Additional styling information to apply to the button
     - Parameter afterHittingAction: The callback closure to run upon user taps "Ok" button
     */
    @objc func displayMessageToUserUsingAlert(title: String, message: String, style: UIAlertControllerStyle = UIAlertControllerStyle.alert, completion: (() -> Void)?, okButtonText: String, actionStyle: UIAlertActionStyle = UIAlertActionStyle.default, afterHittingAction: ((UIAlertAction) -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: okButtonText, style: actionStyle, handler: afterHittingAction)
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
}
