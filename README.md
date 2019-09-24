#  Temp Core Store

## Motivation:
* To demonstrate a usage of Core Data to manage objects of both temporary and long-term persistence.

### Consists of:

1. Short term items made for lifetime of application
2. Long term items created from short term items that are persisted in Core Data. 

### Remark:

1. Short term items will not be persisted to disk, ever. And will not be casually discarded, using Core Data's longterm persistent store as a temporary, time-limited cache.

### Approach:

1. Short term items are made in a temporary context without a store
2. Long term items are always made into a usual context with a store

### Application Structure

##### (is there a better way to present this?...)
                                                                
                            [HoomanModelController] -(adopts)-> [HoomanController]
                                        |
                                      (has)
                                        |
                                        v
[AppDelegate] -(displays)-> [HoomanListViewController] -(shows)-> [HoomanDetailViewController]



[HoomanListViewController] -(shares controller with)-> HoomanDetailViewController
