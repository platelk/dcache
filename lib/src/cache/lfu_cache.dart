part of dcache;

class LfuCache<K, V> extends SimpleCache<K, V> {
  LfuCache({required Storage<K, V> storage, OnEvict<K, V>? onEvict})
      : super(storage: storage, onEvict: onEvict);

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    var values = _internalStorage.values;
    values.sort((a, b) => a.use.compareTo(b.use));
    return values.take(size).toList();
  }
}