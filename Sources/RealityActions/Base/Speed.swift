//
//  Speed.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Changes the speed by which the nested action is executed
public class Speed: BaseAction {
    public var speedFactor: Float
    
    var innerAction: FiniteTimeAction
    
    /// Creates a new instance of the Speed action
    /// - Parameters:
    ///   - action: Action that will be sped up
    ///   - speedFactor: factor by which time is modified.   For example, the value 2 makes things go twice as fast,
    ///   while the value .1 makes things ten times slower
    public init (action: FiniteTimeAction, speedFactor: Float) {
        innerAction = action
        self.speedFactor = speedFactor
    }
    
    override func startAction (target: Entity) -> ActionState? {
        return SpeedState (action: self, target: target)
    }
    
    public func reverse() -> Speed {
        Speed (action: innerAction.reverse(), speedFactor: speedFactor)
    }
}

class SpeedState: ActionState
{
    var speed: Float
    var innerActionState: FiniteTimeActionState
    
    override var isDone: Bool {
        innerActionState.isDone
    }
    
    init? (action: Speed, target: Entity)
    {
        guard let inner = action.innerAction.startAction(target: target) as? FiniteTimeActionState else {
            return nil
        }
        innerActionState = inner
        self.speed = action.speedFactor
        super.init(action: action, target: target)
    }
    
    override func stop () {
        innerActionState.stop ()
        super.stop()
    }
    
    override func step(dt: Float) {
        innerActionState.step(dt: dt * speed)
    }
}
