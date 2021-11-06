part of dcache;

class TlruCache<K, V> extends SimpleCache<K, V> {
  TlruCache(
      {required Storage<K, V> storage,
      OnEvict<K, V>? onEvict,
      Duration? expiration})
      : super(storage: storage, onEvict: onEvict) {
    _expiration = expiration ?? Duration.zero;
  }

  @override
  LoaderFunc<K, V>? _loaderFunc;

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    var values = _internalStorage.values.cast<TlruCacheEntry<K, V>>();
    values.sort((a, b) => a.lastUse.compareTo(b.lastUse));
    values.sort((a, b) => a.compare(b));
    return values.take(size).toList();
  }

  /// internal [set]
  @override
  Cache<K, V> _set(K key, FutureOr<V> element) {
    TlruCacheEntry<K, V> entry;
    if (element is Future<V>) {
      entry = TlruCacheEntry<K, V>(key, null, DateTime.now(), _expiration!);
      entry.updating = true;
      element.then((e) {
        entry.updating = false;
        entry.value = e;
      });
    } else {
      entry = TlruCacheEntry<K, V>(key, element, DateTime.now(), _expiration!);
    }
    _internalStorage[key] = entry;
    return this;
  }
}
