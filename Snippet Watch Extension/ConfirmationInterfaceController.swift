//
//  ConfirmationInterfaceController.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 4/12/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import WatchKit
import Foundation


class ConfirmationInterfaceController: WKInterfaceController {
    
    @IBOutlet var resultLabel: WKInterfaceLabel!
    
    class ConfirmationContext {
        let textString: String
        let confirmAction: (String) -> Void
        let tryAgainActioin: () -> Void
        
        init(textString: String, confirmAction: @escaping (String) -> Void, tryAgainAction: @escaping () -> Void) {
            self.textString = textString
            self.confirmAction = confirmAction
            self.tryAgainActioin = tryAgainAction
        }
    }
    
    var currentContext: ConfirmationContext?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let c = context as? ConfirmationContext {
            currentContext = c;
            resultLabel.setText(c.textString)
        }
        // Configure interface objects here.
    }

    @IBAction func confirmText() {
        popToRootController()
        
        if let context = currentContext {
            context.confirmAction(context.textString)
        }
    }
    
    @IBAction func tryAgain() {
        popToRootController()
        
        if let context = currentContext {
            context.tryAgainActioin()
        }
    }
    
    @IBAction func cancel() {
        popToRootController()
    }
}
