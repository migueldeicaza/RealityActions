//
//  RepeatForever.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Repeats the nested action forever
public class RepeatForever: FiniteTimeAction {
    let innerAction: FiniteTimeAction
    
    /// Initializes the RepeatForever from a variable list of actions
    /// - Parameter actions: a variable argument list
    public convenience init? (_ actions: FiniteTimeAction...) {
        self.init(actions.compactMap {$0})
    }
    
    /// Initializes the RepeatForever from a variable list of actions
    /// - Parameter actions: an array of actions
    public init (_ actions: [FiniteTimeAction]) {
        innerAction = SequenceAction(actions)
        super.init(duration: 0)
    }
    
    /// Initializes the RepeatForever from a single action
    /// - Parameter action: the action to repeat
    public init (action: FiniteTimeAction) {
        innerAction = action
        super.init (duration: 0)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        RepeatForeverState(action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        RepeatForever(action: innerAction.reverse())
    }
}

class RepeatForeverState: FiniteTimeActionState {
    let innerAction: FiniteTimeAction
    var innerActionState: FiniteTimeActionState
    
    init(action: RepeatForever, target: Entity) {
        innerAction = action.innerAction
        innerActionState = innerAction.startAction(target: target) as! FiniteTimeActionState
        super.init(action: action, target: target)
    }
    
    override func step(dt: Float) {
        guard let target else { return }
        innerActionState.step(dt: dt)
        if innerActionState.isDone {
            let diff = innerActionState.elapsed - innerActionState.duration
            innerActionState = innerAction.startAction(target: target) as! FiniteTimeActionState
            innerActionState.step (dt: 0)
            innerActionState.step (dt: diff)
        }
    }
    
    override var isDone: Bool { false }
}
