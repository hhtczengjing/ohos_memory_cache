/**
 * An item to be cached
 */
export interface CacheItem<T> {
  /**
   * The item to be cached
   */
  item: T;

  /**
   * The cost of the item
   */
  cost: number;
};