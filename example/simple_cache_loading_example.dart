import 'package:dcache/dcache.dart';

void main() {
  Cache c = new SimpleCache<int, int>(storage: new SimpleStorage(size: 20))
    ..loader = (key, oldValue) => key*10
  ;

    print(c.get(4)); // 40
    print(c.get(5)); // 50
    print(c.containsKey(6)); // false
}