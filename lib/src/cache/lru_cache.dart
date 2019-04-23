part of dcache;

class LruCache<K, V> extends SimpleCache<K, V> {
  LruCache({@required Storage<K, V> storage}) : super(storage: storage);

  @override
  LruCache<K, V> _set(K key, V element) {
    if (!this._internalStorage.containsKey(key) && this._internalStorage.length >= this._internalStorage.capacity) {
      var values = this._internalStorage.values;
      var min = values?.first;
      // Iterate on all keys, so the eviction is O(n) to allow an insertion at O(1)
      for (var v in values) {
        if (min.lastUse.isAfter(v.lastUse)) {
          min = v;
        }
      }

      this._internalStorage.remove(min.key);
    }
    this._internalStorage[key] = new CacheEntry(key, element, new DateTime.now());
    return this;
  }
}
