//
//  BezierTo.swift
//  
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Action to update the position of an Entity along a bezier path
public class BezierTo: BezierBy {
    
    /// Creates an instance of the BezierTo action, the position will be updated from the entity's
    /// stated position.
    ///
    /// - Parameters:
    ///   - duration: How long will the transition take place
    ///   - config: Configuration specifying the two control points and the end position
    public override init (duration: Float, config: BezierConfig) {
        super.init(duration: duration, config: config)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        BezierByState(action: self, target: target, bezierConfig: self.bezierConfig)
    }
}

class BezierToState: BezierByState {
    public init (action: BezierTo, target: Entity) {
        let p = target.position
        let tConfig = BezierConfig(
            controlPoint1: action.bezierConfig.controlPoint1 - p,
            controlPoint2: action.bezierConfig.controlPoint2 - p,
            endPosition: action.bezierConfig.endPosition - p)
        super.init (action: action, target: target, bezierConfig: tConfig)
    }
}
