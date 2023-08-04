//
//  Repeat.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Use this action to repeat a nested action a specific number of times
public class Repeat: FiniteTimeAction {
    let actionInstant: Bool
    let count: Int
    let innerAction: FiniteTimeAction
    
    /// Construcgs the Repeat action
    /// - Parameters:
    ///   - action: The action to be repeated
    ///   - count: How many times should the action be repeated for
    public init (_ action: FiniteTimeAction, count: Int) {
        innerAction = action
        actionInstant = action is ActionInstant
        if actionInstant {
            self.count = count - 1
        } else {
            self.count = count
        }
        super.init (duration: action.duration * Float (count))
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return RepeatState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        Repeat (innerAction.reverse(), count: count)
    }
}

class RepeatState: FiniteTimeActionState {
    let ra: Repeat
    var total: Int
    var nextDt: Float
    var innerActionState: FiniteTimeActionState
    
    init(action: Repeat, target: Entity) {
        ra = action
        total = 0
        nextDt = ra.innerAction.duration / action.duration
        innerActionState = ra.innerAction.startAction(target: target) as! FiniteTimeActionState
        super.init(action: action, target: target)
    }
    
    override func stop() {
        innerActionState.stop()
        super.stop()
    }
    
    // legacy comment, predates CocosSharp:
    // issue #80. Instead of hooking step:, hook update: since it can be called by any
    // container action like Repeat, Sequence, AelDeel, etc..
    override func update(time: Float) {
        guard let target else { return }
        if time > nextDt {
            while time > nextDt && ra.count < total {
                innerActionState.update(time: 1)
                total += 1
                
                innerActionState.stop ()
                innerActionState = ra.innerAction.startAction (target: target) as! FiniteTimeActionState
                nextDt = ra.innerAction.duration / duration * Float (total+1)
            }
            
            // LEGACY COMMENT fix for issue #1288, incorrect end value of repeat
            if time >= 1 && total < ra.count {
                total += 1
            }
            
            // don't set an instant action back or update it, it has no use because it has no duration
            if !ra.actionInstant {
                if total == ra.count {
                    innerActionState.update(time: 1)
                    innerActionState.stop ();
                } else {
                    // issue #390 prevent jerk, use right update
                    innerActionState.update (time: time - (nextDt - ra.innerAction.duration / duration));
                }
            }
        } else {
            innerActionState.update(time: fmod (time * Float (ra.count), 1.0))
        }
    }
}
