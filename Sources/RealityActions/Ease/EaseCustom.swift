//
//  EaseCustom.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// An easing function that can be controlled by passing a function that computes the desired interpolation
public class EaseCustom: ActionEase {
    let easeFunc: (Float) -> Float
    
    /// Constructs a custom easing function
    /// - Parameters:
    ///   - action: The action to act on
    ///   - easeFunc: A custom function that takes a floating point value between 0 and 1 representing the time for the easing,
    ///   and which should return a value betwee 0 and 1 for how this time is altered.
    public init (action: FiniteTimeAction, _ easeFunc: @escaping (Float)-> Float) {
        self.easeFunc = easeFunc
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseCustomState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        return ReverseTime (action: self)
    }
}

class EaseCustomState: ActionEaseState {
    let easeFunc: (Float) -> Float
    
    init? (action: EaseCustom, target: Entity) {
        self.easeFunc = action.easeFunc
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: easeFunc (time))
    }
}
