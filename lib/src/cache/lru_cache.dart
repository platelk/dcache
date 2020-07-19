part of dcache;

class LruCache<K, V> extends SimpleCache<K, V> {
  LruCache({@required Storage<K, V> storage, @required int capacity}) : super(storage: storage, capacity: capacity);

  @override
  LruCache<K, V> _set(K key, V element) {
    if (!_internalStorage.containsKey(key) && this._internalStorage.length >= capacity) {
      var values = _internalStorage.values;
      // Iterate on all keys, so the eviction is O(n) to allow an insertion at O(1)
      CacheEntry<K, V> min = values.reduce((element1, element2) => element1.lastUse.isBefore(element2.lastUse) ? element1 : element2);

      _internalStorage.remove(min.key);
    }
    _internalStorage[key] = CacheEntry(key, element);
    return this;
  }
}
