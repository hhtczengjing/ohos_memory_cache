import { CacheItem } from "./CacheItem";
import { Configuration } from "./Configuration";
import { MemoryLruCache } from "./MemoryLruCache";

export class MemoryCache<T> {
  private cacheId: string | undefined;
  private configuration?: Configuration;
  private cache: MemoryLruCache<string, T>;

  /**
   * Creates a memory cache instance.
   *
   * @param configuration Cache configuration. See {@link Configuration}.
   */
  constructor(configuration?: Configuration) {
    this.configuration = configuration;
    this.cacheId = this.configuration?.name ?? "default";
    this.cache = this.createMemoryCache();
  }

  /**
   * Sets the cache configuration.
   *
   * @param configuration Cache configuration. See {@link Configuration}.
   * @returns Memory cache instance.
   */
  setConfiguration(configuration: Configuration): MemoryCache<T> {
    this.configuration = configuration;
    return this;
  }

  /**
   * Sets the unique identifier for the memory cache instance that is accessible from other thread.
   *
   * @param cacheId Unique cache instance identifier.
   * @returns Memory cache instance.
   */
  setId(cacheId: string): MemoryCache<T> {
    this.cacheId = cacheId;
    return this;
  }

  /**
   * Returns the cache instance identifier.
   *
   * @returns Cache instance identifier.
   */
  get id(): string | undefined {
    return this.cacheId;
  }

  /**
   * Adds the specified item to the cache.
   *
   * @param key Key of the item.
   * @param item Item to be added to the cache.
   */
  put(key: string, item: T, cost?: number) {
    this.getCache().put(key, { item, cost: cost ?? 0 });
  }

  /**
   * Retrieves the cache item.
   *
   * @param key Key of the item.
   * @returns Retrieved cache item, or `undefined` if the key is not found in the cache.
   */
  get(key: string): T | undefined {
    return this.getCache().get(key)?.item;
  }

  /**
   * Removes items with the specified keys from the cache.
   *
   * @param keys Keys of the items to remove.
   */
  remove(...keys: string[]): void {
    if (!keys || keys.length === 0) {
      return;
    }
    for (const key of keys) {
      this.getCache().remove(key);
    }
  }

  /**
   * Checks if an item with the specified key is present in the cache.
   *
   * @param key Key of the item.
   * @returns `true` if the item with the specified key is found in the cache; otherwise, `false`.
   */
  has(key: string): boolean {
    return this.getCache().has(key);
  }

  /**
   * Cleans the cache.
   */
  clear(): void {
    this.getCache().removeAll();
  }

  /**
   * Obtains a list of all values
   *
   * @returns all values
   */
  values(): T[] {
    const results = this.getCache().values() as CacheItem<T>[]
    return results.map((item) => item.item);
  }

  /**
   * Obtains a list of all keys
   *
   * @returns all keys
   */
  keys(): string[] {
    return this.getCache().keys();
  }

  private getCache(): MemoryLruCache<string, T> {
    if (this.cache) {
      return this.cache;
    }

    this.cache = this.createMemoryCache();
    return this.cache;
  }

  private createMemoryCache(): MemoryLruCache<string, T> {
    return new MemoryLruCache<string, T>(this.configuration);
  }
}