//
//  Blink.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Action to blink the target based on the duration
public class Blink: FiniteTimeAction {
    let count: Int
    public init (duration: Float, count: Int) {
        self.count = count
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return BlinkState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        return Blink (duration: duration, count: count)
    }
}

class BlinkState: FiniteTimeActionState {
    let count: Int
    var originalState: Bool
    
    init(action: Blink, target: Entity) {
        count = action.count
        originalState = target.isEnabled
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        guard !isDone else { return }
        let slice = 1.0 / Float(count)
        let m = fmod (time, slice)
        target.isEnabled = m > (slice/2)
    }
    
    override func stop() {
        target?.isEnabled = originalState
        super.stop()
    }
}
