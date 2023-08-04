//
//  ActionTween.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// ActionTween is an action that lets you update any property of an object.
public class ActionTween: FiniteTimeAction {
    public let from: Float
    public let to: Float
    public let tweenAction: (Float) -> ()

    
    /// Invokes your custom code for the specified duration interpolating the values from `from` to `to`
    /// - Parameters:
    ///   - duration: The time that this action will run for
    ///   - from: Initial value
    ///   - to: Final value
    ///   - tweenAction: The callback that will be invoked repeatedly with the computed value in the range `from`..`to` interpolated into the duration.
    public init (duration: Float, from: Float, to: Float, tweenAction: @escaping (Float)->())
    {
        self.to = to
        self.from = from
        self.tweenAction = tweenAction
        super.init(duration: duration)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        ActionTweenState(action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        ActionTween(duration: duration, from: to, to: from, tweenAction: tweenAction)
    }
}
    
class ActionTweenState : FiniteTimeActionState
{
    let at: ActionTween
    let delta: Float
    
    public init (action: ActionTween, target: Entity) {
        at = action
        delta = at.to - at.from
        super.init (action: action, target: target)
    }
    
    override func update(time: Float) {
        let amt = at.to - delta * (1 - time)
        at.tweenAction (amt)
    }
}
