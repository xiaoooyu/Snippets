//
//  InterfaceController.swift
//  Snippet Watch Extension
//
//  Created by Yin Xiaoyu on 4/12/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    var session: WCSession?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session = WCSession.default()
        if let _session = session {
            _session.delegate = self
            _session.activate()
        }
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
            let info = ["textData": text]
            if let _session = self.session {
               _session.sendMessage(info, replyHandler: nil, errorHandler: nil)
            }
            
            print("processText: \(text)")
        }
        
        let confirmContext = ConfirmationInterfaceController.ConfirmationContext(
            textString: string, confirmAction: processText, tryAgainAction: tryToGetText)
        
        pushController(withName: "confirmation", context: confirmContext)
    }
}

// MARK: WCSessionDelegate
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
}
