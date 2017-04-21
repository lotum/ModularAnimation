# ModularAnimation
A small framework that seperates the playback and the animation description from the (UIView-)animation itself.

ModularAnimation gets rid of the drawbacks of UIView.animate():
- Your animation code will be easy to understand
- You will be able to reuse your animation description on different views

## Usage
### the oldfashioned way
```swift
let object = UIView()
    
UIView.animate(
    withDuration: 0,
    delay: 0,
    options: [],
    animations: {
        object.transform.scaledBy(x: 2, y: 2)
},
    completion: { _ in
        UIView.animate(
            withDuration: 0.25,
            delay: 0.25,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 4,
            options: [],
            animations: {
                object.transform = .identity
        },
            completion: { _ in
               UIView.animate(
                    withDuration: 0.4,
                    delay: 0,
                    options: [],
                    animations: {
                        object.alpha = 0
                        object.transform.scaledBy(x: 5, y: 0.1)
                },
                    completion: nil
                )
        }
        )
    }
)
```

### Seperate the playback with ModularAnimation
```swift
let object = UIView()

let scaleUp = BasicAnimationModule(duration: 0) {
    object.transform.scaledBy(x: 2, y: 2)
}
let scaleBack = SpringAnimationModule(duration: 0.25, delay: 0.25, dampingRatio: 0.8, velocity: 4) {
    object.transform = .identity
}
let fadeOut = BasicAnimationModule(duration: 0.4) {
    object.alpha = 0
}
let squeeze = BasicAnimationModule(duration: 0.4) {
    object.transform.scaledBy(x: 5, y: 0.1)
}

// you can do this (similar to before)
scaleUp.play() { _ in
    scaleBack.play() { _ in
        fadeOut.play()
        squeeze.play()
    }
}

// or this to get rid of the completion blocks
let fadeOutAndSqueeze = ParallelAnimation(fadeOut, squeeze)
let serial = SerialAnimation(scaleUp, scaleBack, fadeOutAndSqueeze)
serial.play()
```

### Seperate the animation description
```swift
let description = AnimationAction.serial(
    .scaleEqually(scale: 2),
    .springTransformBack(duration: 0.25),
    .delay(duration: 0.4),
    .parallel(
        .fadeOut(duration: 0.4),
        .scale(x: 5, y: 0.1, duration: 0.4)
    )
)

// use same description on different views
let object1 = UIView()
let object2 = UIView()

object1.animation(description).play()
object2.animation(description).play()
```

All in all you can write this compact and easy to grasp animation code for the view:
```swift
let object = UIView()

object
    .animateSerial(
        .scaleEqually(scale: 2),
        .springTransformBack(duration: 0.25),
        .delay(duration: 0.4),
        .parallel(
            .fadeOut(duration: 0.4),
            .scale(x: 5, y: 0.1, duration: 0.4)
        )
    ).play()
```
