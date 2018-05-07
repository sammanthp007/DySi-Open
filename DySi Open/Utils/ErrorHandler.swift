//
//  ErrorHandler.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/7/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

let ErrorHandler = _ErrorHandler()

class _ErrorHandler {
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
