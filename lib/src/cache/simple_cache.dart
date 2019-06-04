part of dcache;

typedef void OnEvict<K, V>(K k, V v);

/// SimpleCache is a basic cache implementation without any particular logic
/// than appending keys in the storage, and remove first inserted keys when storage is full
class SimpleCache<K, V> extends Cache<K, V> {
  /// if onEvict is set that method is called whenever an entry is removed from the queue.
  /// At the time the method is called the entry is already removed.
  OnEvict<K, V> onEvict;

  SimpleCache({@required Storage<K, V> storage, this.onEvict}) : super(storage: storage);

  @override
  CacheEntry<K, V> _get(K key) {
    return this._internalStorage[key];
  }

  @override
  SimpleCache<K, V> _set(K key, V element) {
    // Remove the first key to respect the size, no time logic here.
    // It's a wanted simple and not smart implementation
    if (!this._internalStorage.containsKey(key) && this.length >= this._internalStorage.capacity) {
      if (onEvict != null) {
        CacheEntry<K, V> c = this._internalStorage.get(this._internalStorage.keys.first);
        this._internalStorage.remove(this._internalStorage.keys.first);
        onEvict(c.key, c.value);
      } else {
        this._internalStorage.remove(this._internalStorage.keys.first);
      }
    }
    this._internalStorage[key] = new CacheEntry(key, element, new DateTime.now());
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
