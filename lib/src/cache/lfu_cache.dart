part of dcache;

class LfuCache<K, V> extends SimpleCache<K, V> {
  LfuCache({@required Storage<K, V> storage}) : super(storage: storage);

  @override
  LfuCache<K, V> _set(K key, V element) {
    if (!this._internalStorage.containsKey(key) &&
        this._internalStorage.length >= this._internalStorage.capacity) {
      // Sort by use time
      var values = this._internalStorage.values;
      values.sort((e1, e2) {
        return e1.use - e2.use;
      });

      this._internalStorage.remove(values.first.key);
    }
    this._internalStorage[key] =
        new CacheEntry(key, element, new DateTime.now());
    return this;
  }
}
