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
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 4,
            options: [],
            animations: {
                object.transform = .identity
        },
            completion: { _ in
               UIView.animate(
                    withDuration: 0.4,
                    delay: 0.25,
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
let scaleBack = SpringAnimationModule(duration: 0.25, dampingRatio: 0.8, velocity: 4) {
    object.transform = .identity
}
let fadeOutAndSqueeze = BasicAnimationModule(duration: 0.4, delay: 0.25) {
    object.alpha = 0
    object.transform.scaledBy(x: 5, y: 0.1)
}

// you can do this (similar to before)
scaleUp.play() { _ in
    scaleBack.play() { _ in
        fadeOutAndSqueeze.play()
    }
}

// or this to get rid of the completion blocks
let serial = SerialAnimation(scaleUp, scaleBack, fadeOutAndSqueeze)
serial.play()

