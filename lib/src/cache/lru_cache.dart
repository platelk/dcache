part of dcache;

class LruCache<K, V> extends SimpleCache<K, V> {
  LruCache({@required Storage<K, V> storage, OnEvict<K, V> onEvict}) : super(storage: storage, onEvict: onEvict);

  @override
  LruCache<K, V> _set(K key, V element) {
    if (!this._internalStorage.containsKey(key) && this._internalStorage.length >= this._internalStorage.capacity) {
      var values = this._internalStorage.values;
      var min = values?.first;
      // Iterate on all keys, so the eviction is O(n) to allow an insertion at O(1)
      // todo implement a faster lookup method
      for (var v in values) {
        if (min.lastUse.isAfter(v.lastUse)) {
          min = v;
        }
      }

      if (onEvict != null) {
        CacheEntry<K, V> c = this._internalStorage.get(min.key);
        this._internalStorage.remove(min.key);
        onEvict(c.key, c.value);
      } else {
        this._internalStorage.remove(min.key);
      }
    }
    this._internalStorage[key] = new CacheEntry(key, element, new DateTime.now());
    return this;
  }
}
