# Dart Signals Proposal
Simple initial proposal to use signals in dart, base on Ryan Carniato [porst](https://dev.to/ryansolid/a-hands-on-introduction-to-fine-grained-reactivity-3ndf) about building fine reactivity.

---
## Features
- createSignal
- createEffect
- createMemo

```dart
    //import Signals
    final mySignal = Signals.createSignal<int>(0);
    //create an effect
    Signals.createEffect((_) => print("signal value = ${mySignal.read()}"));
    //update value
    mySignal.write(2);

    mySignal.write(4);
```
For another example see bin/dart_signals.dart
