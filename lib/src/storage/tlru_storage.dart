part of dcache;

class TlruStorage<K, V> extends InMemoryStorage<K, V> {
  @override
  final Map<K, TlruCacheEntry<K, V>> _internalMap;

  TlruStorage(int size)
      : _internalMap = {},
        super(size);
}
