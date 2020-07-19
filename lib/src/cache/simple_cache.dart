part of dcache;

/// SimpleCache is a basic cache implementation without any particular logic
/// than appending keys in the storage, and remove first inserted keys when storage is full
class SimpleCache<K, V> extends Cache<K, V> {
  int capacity;

  SimpleCache({@required Storage<K, V> storage, @required this.capacity})
      : assert(capacity != null && capacity > 0),
        assert(storage != null),
        super(storage: storage);

  @override
  CacheEntry<K, V> _get(K key) {
    return _internalStorage[key];
  }

  @override
  SimpleCache<K, V> _set(K key, V element) {
    // Remove the first key to respect the size, no time logic here.
    // It's a wanted simple and not smart implementation
    if (!_internalStorage.containsKey(key) && length >= capacity) {
      _internalStorage.remove(_internalStorage.keys.first);
    }
    _internalStorage[key] = CacheEntry(key, element);
    return this;
  }

  @override
  int get length => _internalStorage.length;
}
