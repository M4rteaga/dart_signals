typedef Read<T> = T Function();
typedef Write<T> = Function(T nextValue);

class CreateSignal<T> {
  final Read<T> read;
  final Write<T> write;

  CreateSignal(this.read, this.write);
}

class Running {
  final Function(Running self) executeFn;
  final Set dependencies;
  late Function execute;

  Running(this.executeFn, this.dependencies) {
    execute = () => executeFn(this);
  }
}

class Signals {
  static final List _context = [];
  Signals();

  static _subscribe<T>(running, Set<T> subscription) {
    subscription.add(running);
    running.dependencies.add(subscription);
  }

  static CreateSignal<T> createSignal<T>(T value) {
    final Set subscriptions = {};

    T read() {
      if (_context.isNotEmpty) {
        final running = _context.last;
        if (running != null) {
          _subscribe(running, subscriptions);
        }
      }
      return value;
    }

    write(T nextValue) {
      value = nextValue;

      for (final sub in Set.from(subscriptions)) {
        sub.execute();
      }
    }

    return CreateSignal<T>(read, write);
  }

  static _cleanup(Running running) {
    for (final Set dep in running.dependencies) {
      // print(dep.runtimeType);
      dep.remove(running);
    }
    running.dependencies.clear();
  }

  static createEffect(Function fn) {
    final Running effect = Running((Running self) {
      _cleanup(self);
      _context.add(self);
      try {
        fn();
      } finally {
        _context.removeLast();
      }
    }, {});

    effect.execute();
  }

  static createMemo(fn) {
    final signal = createSignal(fn);
    createEffect(() => signal.write(fn()));
    return signal.read;
  }
}
