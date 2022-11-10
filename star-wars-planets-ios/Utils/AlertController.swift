//
//  AlertController.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import UIKit

final class AlertController {

    private var vc: UIViewController!

    init(_ vc: UIViewController?) {
        self.vc = vc
    }

    func alert(title: String?, message: String, actions: [UIAlertAction], completion: (() -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }

        self.vc.present(alertController, animated: true, completion: completion)
    }
}
