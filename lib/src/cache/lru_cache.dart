part of dcache;

class LruCache<K, V> extends SimpleCache<K, V> {
  LruCache({required Storage<K, V> storage, OnEvict<K, V>? onEvict})
      : super(storage: storage, onEvict: onEvict);

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    var values = _internalStorage.values;
    values.sort((a, b) => a.lastUse.compareTo(b.lastUse));
    return values.take(size).toList();
  }
}
