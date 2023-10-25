//
//  BezierBy.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

public class BezierBy: FiniteTimeAction {
    let bezierConfig: BezierConfig
    
    public init (duration: Float, config: BezierConfig) {
        bezierConfig = config
        super.init(duration: duration)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        BezierByState(action: self, target: target, bezierConfig: bezierConfig)
    }
    
    public override func reverse() -> FiniteTimeAction {
        let r = BezierConfig (
            controlPoint1: bezierConfig.controlPoint2 + -bezierConfig.endPosition,
            controlPoint2: bezierConfig.controlPoint1 + -bezierConfig.endPosition,
            endPosition: -bezierConfig.endPosition)
        
        return BezierBy (duration: duration, config: r)
    }
}

class BezierByState: FiniteTimeActionState {
    let bezierConfig: BezierConfig
    var startPosition: SIMD3<Float>
    var previousPosition: SIMD3<Float>
    
    public init (action: BezierBy, target: Entity, bezierConfig: BezierConfig) {
        self.bezierConfig = bezierConfig
        previousPosition = target.position
        startPosition = target.position
        super.init (action: action, target: target)
    }
    
    override func update(time: Float) {
        guard let target else { return }
        
        let xa: Float = 0
        let xb: Float = bezierConfig.controlPoint1.x
        let xc: Float = bezierConfig.controlPoint2.x
        let xd: Float = bezierConfig.endPosition.x
        
        let ya: Float = 0
        let yb: Float = bezierConfig.controlPoint1.y
        let yc: Float = bezierConfig.controlPoint2.y
        let yd: Float = bezierConfig.endPosition.y
        
        let za: Float = 0
        let zb: Float = bezierConfig.controlPoint1.z
        let zc: Float = bezierConfig.controlPoint2.z
        let zd: Float = bezierConfig.endPosition.z
        
        let x: Float = cubicBezier (a: xa, b: xb, c: xc, d: xd, t: time)
        let y: Float = cubicBezier (a: ya, b: yb, c: yc, d: yd, t: time)
        let z: Float = cubicBezier (a: za, b: zb, c: zc, d: zd, t: time)
        
        let currentPos = target.position
        let diff = currentPos - previousPosition
        startPosition = startPosition + diff
        
        let newPos = startPosition + [x, y, z]
        target.position = newPos
        
        previousPosition = newPos
    }
}


/// Defines a bezier segment in 3D space
///
/// Use this to define the bezier paths that either ``BezierBy`` or ``BezierTo`` use.
/// 
public struct BezierConfig {
    /// The first control point
    public var controlPoint1: SIMD3<Float>
    /// The second control point
    public var controlPoint2: SIMD3<Float>
    /// The end position
    public var endPosition: SIMD3<Float>
    
    public init (controlPoint1: SIMD3<Float>, controlPoint2: SIMD3<Float>, endPosition: SIMD3<Float>){
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.endPosition = endPosition
    }
}

