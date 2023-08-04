//
//  SequenceAction.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Runs actions sequentially.  When one completes, it executes the next one
public class SequenceAction: FiniteTimeAction {
    let action1, action2: FiniteTimeAction
    var cancel: ((SequenceActionState) -> ())? = nil
    
    /// Creates a new sequence action
    /// - Parameters:
    ///   - action1: The first action to run
    ///   - action2: The second action to run
    public init (first: FiniteTimeAction, second: FiniteTimeAction) {
        self.action1 = first
        self.action2 = second

        super.init(duration: action1.duration + action2.duration)
    }
    
    /// Creates an action from the list of provided actions
    /// - Parameter actions: A sequence of actions to run
    public convenience init (_ actions: FiniteTimeAction...) {
        self.init(actions.compactMap { $0 })
    }
    
    /// Creates an action from the list of provided actions
    /// - Parameter actions: A sequence of actions to run
    public init (_ actions: [FiniteTimeAction]) {
        var prev: FiniteTimeAction? = nil
        
        var combinedDuration: Float = 0
        var count = 0
        for action in actions {
            if prev == nil {
                prev = action
            }
            combinedDuration += action.duration
            count += 1
        }
        if count == 0 {
            action1 = ActionInstant()
            action2 = ActionInstant()
        } else if count == 1 {
            action1 = prev!
            action2 = ExtraAction(duration: 0)
        } else {
            // Basically what we are doing here is creating a whole bunch of
            // nested Sequences from the actions.
            
            for i in 1..<count-1 {
                prev = SequenceAction (first: prev!, second: actions[i])
            }

            action1 = prev!
            action2 = actions [actions.count-1]
        }
        super.init(duration: combinedDuration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return SequenceActionState (action: self, target: target)
    }

    public override func reverse() -> FiniteTimeAction {
        SequenceAction (first: action2.reverse(), second: action1.reverse())
    }
}

class SequenceActionState: FiniteTimeActionState {
    enum ActiveAction {
        case none
        case first
        case second
    }
    let cancel: ((SequenceActionState) -> ())?
    let action1, action2: FiniteTimeAction
    var action1state, action2state: ActionState?
    let hasInfiniteAction: Bool
    let split: Float
    var last: ActiveAction
    
    init(action: SequenceAction, target: Entity) {
        self.cancel = action.cancel
        action1 = action.action1
        action2 = action.action2
        hasInfiniteAction = action1 is RepeatForever || action2 is RepeatForever
        split = action1.duration / action.duration
        last = .none
        super.init(action: action, target: target)
    }
    
    override var isDone: Bool {
        if hasInfiniteAction {
            if last == .first && action1 is RepeatForever { return false }
            if last == .second && action2 is RepeatForever { return false }
        }
        return super.isDone
    }
        
    override func stop() {
        switch last {
        case .none:
            return
        case .first:
            action1state?.stop ()
        case .second:
            action2state?.stop ()
        }
    }
    
    override func step(dt: Float) {
        switch last {
        case .none:
            super.step (dt: dt)
        case .first:
            if action1 is RepeatForever {
                action1state?.step (dt: dt)
            } else {
                super.step(dt: dt)
            }
        case .second:
            if action2 is RepeatForever {
                action2state?.step (dt: dt)
            } else {
                super.step(dt: dt)
            }
        }
    }
    
    override func update(time: Float) {
        guard let target else { return }
        var found: ActiveAction
        let foundState: ActionState?
        var new_t: Float
        
        if time < split {
            found = .first
            foundState = action1state
            if split != 0 {
                new_t = time / split
            } else {
                new_t = 1
            }
        } else {
            found = .second
            foundState = action2state
            if split == 1 {
                new_t = 1
            } else {
                new_t = (time - split) / (1-split)
            }
        }
        
        if found == .second {
            if last == .none {
                // action1 was skipped, execute it
                action1state = action1.startAction(target: target) as? FiniteTimeActionState
                action1state?.update (time: 1)
                action1state?.stop ()
            } else if last == .first {
                action1state?.update (time: 1)
                action1state?.stop ()
            }
        } else if found == .first && last == .second {
            // Reverse mode ?
            // XXX: Bug. this case doesn't contemplate when _last==-1, found=0 and in "reverse mode"
            // since it will require a hack to know if an action is on reverse mode or not.
            // "step" should be overriden, and the "reverseMode" value propagated to inner Sequences.
            action2state?.update (time: 0)
            action2state?.stop ()
        }
        
        // Last action found and it is done.
        if found == last && foundState?.isDone ?? true {
            return
        }
        
        // Last action found and it is done
        if found != last {
            switch found {
            case .none:
                break
            case .first:
                action1state = action1.startAction(target: target)
                action1state?.update(time: new_t)
            case .second:
                action2state = action.startAction(target: target)
                action2state?.update(time: new_t)
            }
        }
        foundState?.update(time: new_t)
        last = found
    }
}
