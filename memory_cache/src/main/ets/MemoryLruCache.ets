import { util } from "@kit.ArkTS";
import { Configuration } from "./Configuration";
import { CacheItem } from "./CacheItem";

/**
 * Memory LRU Cache
 */
export class MemoryLruCache<K, V> {
  private lruCache: util.LRUCache<K, CacheItem<V>>;
  private countLimit: number = 0; // 最大容量
  private costLimit: number = 0; // 最大占用量
  private totalCost: number = 0; // 当前总占用量

  constructor(configuration?: Configuration) {
    const countLimit = configuration?.countLimit ?? 10000;
    const costLimit = configuration?.costLimit ?? 10000;
    this.countLimit = countLimit;
    this.costLimit = costLimit;
    this.lruCache = new util.LRUCache(countLimit);
  }

  put(key: K, value: CacheItem<V>): void {
    if (key == null || value == null) {
      throw new Error('key or value is invalid ');
    }
    if (this.countLimit < 1) {
      throw new Error('countLimit is invalid ');
    }

    // 如果size满了的话，需要按照LRU的方式删除第一个
    if (this.lruCache.length == this.countLimit && !this.lruCache.contains(key)) {
      this.remove(this.lruCache.keys()[0]);
    } else if (this.lruCache.contains(key)) {
      this.remove(key);
    }

    this.lruCache.put(key, value);
    this.totalCost += value.cost;
    this.trimToSize();
  }

  has(key: K): boolean {
    return this.lruCache.contains(key);
  }

  get(key: K): CacheItem<V> | undefined {
    return this.lruCache.get(key);
  }

  remove(key: K): CacheItem<V> | undefined {
    if (key == null) {
      throw new Error('key is null,checking the parameter');
    }

    let remove: CacheItem<V> | undefined = this.lruCache.remove(key);
    if (remove !== undefined) {
      this.totalCost -= remove?.cost;
    }
    return remove;
  }

  values(): CacheItem<V>[] {
    return this.lruCache.values();
  }

  keys(): K[] {
    return this.lruCache.keys();
  }

  removeAll(): void {
    this.lruCache.clear();
    this.totalCost = 0;
  }

  size(): number {
    return this.lruCache.length;
  }

  trimToSize(): void {
    while (true) {
      if (this.totalCost <= this.costLimit || this.lruCache.isEmpty()) {
        break;
      }
      let delKey = this.lruCache.keys()[0];
      let data: CacheItem<V> | undefined = this.lruCache.get(delKey);
      if (data != undefined) {
        this.totalCost -= data.cost;
      }
      this.lruCache.remove(delKey);
    }
  }
}