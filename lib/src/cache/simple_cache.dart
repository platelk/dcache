part of dcache;

class SimpleCache<K, V> extends Cache<K, V> {
  SimpleCache({@required Storage<K, V> storage}) : super(storage: storage);
 
  @override
  CacheEntry<K, V> _get(K key) {
    return this._internalStorage[key];
  }

  @override
  SimpleCache<K, V> _set(K key, V element) {
    // Remove the first key to respect the size, no time logic here.
    // It's a wanted simple and not smart implementation
    if (!this._internalStorage.containsKey(key) &&
        this.length >= this._internalStorage.capacity) {
      this._internalStorage.remove(this._internalStorage.keys.first);
    }
    this._internalStorage[key] =
        new CacheEntry(key, element, new DateTime.now());
    return this;
  }

  @override
  SimpleCache<K, V> clear() {
    this._internalStorage.clear();
    return this;
  }

  @override
  int get length => this._internalStorage.length;
}
