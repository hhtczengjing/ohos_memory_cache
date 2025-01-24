/**
 * Memory cache settings.
 */
export interface Configuration {
  /**
   * The name of the memory cache.
   */
  name?: string;

  /**
   * The maximum number of objects the cache should hold.
   */
  countLimit?: number;

  /**
   * The maximum total cost that the cache can hold before it starts evicting objects.
   */
  costLimit?: number;
}