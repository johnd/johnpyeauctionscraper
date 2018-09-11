John Pye Auction Scraper
========================

So this one's a bit niche. We buy stuff from (John Pye
Auctions)[https://www.johnpyeauctions.co.uk] most weeks, and it can be
interesting to see what items are available near the end of an auction for low
prices - especially things that have had only one or less bids. Most of this
stuff ends up being laughable junk, but sometimes you find a wee gem.

Looking through 20+ pages of auctions multiple times gets really boring, so this
script does it for you. It'll spit out a list of URLs for each item that is at
or below the maximum price you specify (or £4 if you don't specify anything).

Usage
-----

Install the required gems with `bundle install`.

Run the script with a command like:

```
bundle exec ruby ./scraper.rb "https://www.johnpyeauctions.co.uk/lot_list.asp?saleid=6211&siteid=1" 10
```

It's important to put the URL in quotes, as it contains an ampersand (`&`) and
without quotes your shell will interpret it as a command and break everything.
The URL is required, the max cost isn't - it'll default to 4 if it's not given,
which represents any auctions with one bid or less.
