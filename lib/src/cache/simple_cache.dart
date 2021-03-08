part of dcache;

/// SimpleCache is a basic cache implementation without any particular logic
/// than appending keys in the storage, and remove first inserted keys when storage is full
class SimpleCache<K, V> extends Cache<K, V> {
  SimpleCache({required Storage<K, V> storage, OnEvict<K, V>? onEvict}) : super(storage, onEvict: onEvict);

  @override
  CacheEntry<K, V>? _get(K key) {
    return _internalStorage[key];
  }

  @override
  SimpleCache<K, V> clear() {
    _internalStorage.clear();
    return this;
  }

  @override
  int get length => _internalStorage.length;

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    return _internalStorage.values.take(size).toList();
  }
}
