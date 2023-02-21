import '../src/signals.dart';

void main(List<String> arguments) {
  print("1. create signal");
  final signal = Signals.createSignal<int>(0);

  print("2. create reaction");
  Signals.createEffect(() => print("The count is ${signal.read()}"));

  print("3. Set count to 5");
  signal.write(5);

  print("4. Set count to 10");
  signal.write(10);

  print("1. Create");
  final firstNameSignal = Signals.createSignal("John");
  final lasNameSignal = Signals.createSignal("Smith");
  final showFullNameSignal = Signals.createSignal(true);

  final displayName = Signals.createMemo(() {
    if (!showFullNameSignal.read()) {
      return firstNameSignal.read();
    }
    return "${firstNameSignal.read()} ${lasNameSignal.read()}";
  });

  Signals.createEffect(() => print("My name is ${displayName()}"));

  print("2. Set showFullName: false ");
  showFullNameSignal.write(false);

  print("3. Change lastName");
  lasNameSignal.write("Legend");

  print("4. Set showFullName: true");
  showFullNameSignal.write(true);
}
