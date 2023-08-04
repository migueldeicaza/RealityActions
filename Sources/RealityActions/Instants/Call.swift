//
//  Call.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// An action that calls a user-provided method when it is triggered
public class Call: ActionInstant {
    let callback: ()->()
    
    /// Creates the call action, that will invoke the method specified when it is triggered
    /// - Parameter callback: The method to invoke when the action is triggered
    public init (_ callback: @escaping ()->()) {
        self.callback = callback
    }
    
    override func startAction(target: Entity) -> ActionState? {
        CallState (action: self, target: target)
    }    
}

class CallState: ActionInstantState {
    let call: Call
    
    init(action: Call, target: Entity) {
        self.call = action
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        call.callback ()
    }
}

