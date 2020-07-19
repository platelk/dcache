part of dcache;

class LfuCache<K, V> extends SimpleCache<K, V> {
  LfuCache({@required Storage<K, V> storage, @required int capacity}) : super(storage: storage, capacity: capacity);

  @override
  LfuCache<K, V> _set(K key, V element) {
    if (!_internalStorage.containsKey(key) && _internalStorage.length >= capacity) {
      var values = _internalStorage.values;
      // Iterate on all keys, so the eviction is O(n) to allow an insertion at O(1)
      CacheEntry<K, V> min = values.reduce((element1, element2) => element1.use < element2.use ? element1 : element2);

      _internalStorage.remove(min.key);
    }
    _internalStorage[key] = CacheEntry(key, element);
    return this;
  }
}
