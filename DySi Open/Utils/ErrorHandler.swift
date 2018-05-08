//
//  ErrorHandler.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/7/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

let ErrorHandler = _ErrorHandler()

/// A utility function to handle error based on error domain and error code
class _ErrorHandler {
    /**
     Displays user friendly error on device screen based on error domain and error code.
     If the error domain or code cannot be found, the display on device will fall to fallback values.
     - Parameter viewController: The UIViewController the alert view will be on
     - Parameter error: Error that gets translated to user friendly message
     - Parameter completion: The callback closure to call after user taps "Ok"
     */
    func displayErrorOnDeviceScreen(viewController: UIViewController, error: Error?, completion: ((UIAlertAction) -> Void)? = nil) -> Void {
        var displayableErrorTitle: String = Constants.CustomErrors.Fallback.title
        var displayableErrorMessage: String = Constants.CustomErrors.Fallback.message
        
        if let error = error as NSError? {
            if let errorMessage = Constants.CustomErrors.NSErrorToDisplayableMessage[error.domain]?[error.code] {
                displayableErrorTitle = errorMessage.title
                displayableErrorMessage = errorMessage.message
            }
        }
        
        viewController.displayMessageToUserUsingAlert(title: displayableErrorTitle, message: displayableErrorMessage, completion: nil, okButtonText: "Ok", afterHittingAction: completion)
    }
}
