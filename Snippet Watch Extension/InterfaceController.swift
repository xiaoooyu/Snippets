//
//  InterfaceController.swift
//  Snippet Watch Extension
//
//  Created by Yin Xiaoyu on 4/12/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func createNewSnippet() {
        tryToGetText()
    }
    
    func tryToGetText() {
        presentTextInputController(withSuggestions: ["Test"], allowedInputMode: .plain, completion: processResults)
    }
    
    func processResults(results: [Any]?) {
        guard let r = results?[0], let string = r as? String else {
            return
        }
        
        let processText = { (text:String) in
            print("processText: \(text)")
        }
        
        let confirmContext = ConfirmationInterfaceController.ConfirmationContext(
            textString: string, confirmAction: processText, tryAgainAction: tryToGetText)
        
        pushController(withName: "confirmation", context: confirmContext)
    }
}
