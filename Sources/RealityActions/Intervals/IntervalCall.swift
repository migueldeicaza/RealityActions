//
//  IntervalCall.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Calls a user-provided method over the specified time span, useful as a method to call inside the easing functions
public class IntervalCall: FiniteTimeAction {
    let callback: (Float)-> ()
    
    
    /// Initializes an `IntervalCall`
    /// - Parameters:
    ///   - duration: Time period in which the callback will be invoked
    ///   - callback: The method that will be invoked, it takes a float parameter in the range 0...1.0 representing the time
    public init (duration: Float, _ callback: @escaping (Float) -> ()) {
        self.callback = callback
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return IntervalCallState (action: self, target: target)
    }
}

class IntervalCallState: FiniteTimeActionState {
    let callback: (Float) -> ()
    
    init(action: IntervalCall, target: Entity) {
        self.callback = action.callback
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard target != nil else { return }

        callback (time)
    }
}
