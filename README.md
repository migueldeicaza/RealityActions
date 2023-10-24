RealityActions brings the popular [Cocos2D-style action
framework](https://docs.cocos2d-x.org/cocos2d-x/v3/en/actions/) to
Entities in RealityKit.

To use, reference this module from SwiftPM:

```
https://github.com/migueldeicaza/RealityActions
```

To use the framework, you must first register the Action framework
with RealityKit, at your program startup make sure you have something
like this:

```swift
ActionManagerSystem.registerSystem()
```

Then, you can execute one of the many available actions on your
entities, this is a snippet that moves an entity in a game:

```
class SmallPlate: Weapon {
    override var reloadDuration: Duration { .milliseconds(450) }
    override var damage: Int { 10 }

    override func fire (byPlayer: Bool) async {
        //let distance: Float = 10
        guard let parent = await entity.parent else {
            return
        }

        @Sendable func fire (to: SIMD3<Float>) async {
            let bullet = await createRigidBullet(byPlayer: byPlayer, size: size)
            await bullet.addChild(smallPlateEntity.clone(recursive: true))

            await parent.addChild(bullet)

            await bullet.run(MoveBy(duration: 3, delta: to))
            await bullet.removeAllActions()
            await bullet.removeFromParent()
        }
        await fire (to: [Float.random(in: -3...3), -2, 0])
    }
}
```

This one makes a small airplane rotate every 5 seconds:

```
        airplane.start (RepeatForever (
            DelayTime(duration: 5),
            EaseBackOut(
                RotateBy(duration: 1, deltaAngles: SIMD3<Float> (0, 0, 360)))))

```

# History

The action framework originated sometime with Cocos2D.  Cocos2D
sprawled various different efforts, among those a port to .NET, which
lead to [CocosSharp](https://github.com/mono/CocosSharp), and later
this was ported to the 3D engine
[UrhoSharp](https://github.com/xamarin/urho).

I ported the UrhoSharp codebase that added some 3D capabilities and
added various neat features using Async to Swift and RealityKit.