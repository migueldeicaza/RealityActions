# RealityActions

Action can change properties on a RealityKit Entity in a number of ways. 

Action objects allow the transformation of the entity properties in time.
As an example, you can direct movement, rotations and color changes over
a period of time on an entity.

## Overview

## Topics

### Orchestration

- ``ActionManager``

### Base Types

All actions in RealityAction derive from ``BaseAction``, which provides a ``BaseAction/tag`` property
that can be used to identify the action.  

The ``FiniteTimeAction`` version is for actions that have a time duration, while the 
``Speed`` ones can alter the execution speed of their actions.

- ``BaseAction``
- ``FiniteTimeAction``
- ``Speed``

### Easing Functions
 

- ``ActionEase``
- ``EaseBackIn``
- ``EaseBackInOut``
- ``EaseBackOut``
- ``EaseBounceIn``
- ``EaseBounceInOut``
- ``EaseBounceOut``
- ``EaseCustom``
- ``EaseElastic``
- ``EaseElasticIn``
- ``EaseElasticInOut``
- ``EaseElasticOut``
- ``EaseExponentialIn``
- ``EaseExponentialInOut``
- ``EaseExponentialOut``
- ``EaseIn``
- ``EaseInOut``
- ``EaseOut``
- ``EaseRateAction``
- ``EaseSinIn``
- ``EaseSinInOut``
- ``EaseSinOut``

### Instants

- ``ActionInstant``
- ``ApplyTransform``
- ``Call``
- ``Hide``
- ``Place``
- ``RemoveSelf``
- ``Show``
- ``ToggleVisibility``

### Intervals

- ``ActionTween``
- ``BezierBy``
- ``BezierTo``
- ``Blink``
- ``DelayTime``
- ``IntervalCall``
- ``JumpBy``
- ``JumpTo``
- ``MoveBy``
- ``MoveTo``
- ``Parallel``
- ``Repeat``
- ``RepeatForever``
- ``ReverseTime``
- ``RotateBy``
- ``RotateTo``
- ``ScaleBy``
- ``ScaleTo``
- ``SequenceAction``
- ``Spawn``
