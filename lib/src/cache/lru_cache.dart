part of dcache;

class LruCache<K, V> extends SimpleCache<K, V> {
  LruCache({@required Storage<K, V> storage}) : super(storage: storage);

  @override
  LruCache<K, V> _set(K key, V element) {
    if (!this._internalStorage.containsKey(key) && this._internalStorage.length >= this._internalStorage.capacity) {
      // Sort by use time
      var values = this._internalStorage.values;
      values.sort((e1, e2) {
        return e1.lastUse.compareTo(e2.lastUse);
      });

      this._internalStorage.remove(values.first.key);
    }
    this._internalStorage[key] = new CacheEntry(key, element, new DateTime.now());
    return this;
  }
}
