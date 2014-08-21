FSEterm
=======

CLI tools for FSEconomy

Requirements:
* bash>=4.0
* wget
* awk

This project creates a set of tools for Linux (and possible other unixalikes) for querying FSEconomy data. I am developing and testing using a Debian variant, however, if you have problems on other systems because of code portability, please let me know and I will try to fix it to run on more platforms.

It will be based entirely on my own needs plus yours, if you submit feature requests in the bug tracker.

The library caches data into a cache/ directory to minimize hits to the FSE servers. Once the cache is more than 30 minutes old, fresh data will be fetched and the cache will be re-written.

Currently there are two reports.

seats
------

# seats from KSAN
# seats to KLAX
# seats -m 3 from KAUS

The first example lists the number of passengers by airport (not jobs) flying from San Diego Lindbergh. The second example lists the number of passengers flying to Los Angeles from each airport. The final lists the number of passengers flying from Austin from each airport only if there is a minimum of 3 passengers.

# jobs to KLAX

List the actual jobs in a similar manner as the FSE airport page with a profit score added for comparing which jobs are more profitable. The 'jobs from' airport command also works as expected.
