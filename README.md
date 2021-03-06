John Pye Auction Scraper
========================

So this one's a bit niche. We buy stuff from [John Pye
Auctions](https://www.johnpyeauctions.co.uk) most weeks, and it can be
interesting to see what items are available near the end of an auction for low
prices - especially things that have had only one or less bids. Most of this
stuff ends up being laughable junk, but sometimes you find a wee gem.

Looking through dozens of pages of items gets tedious, so this is a web
service that we run on our network that scrapes all the items in an auction,
and then highlights ones below a given price threshold.

Notes
=====

App workflow
------------

For each new auction, we feed the app the URL to the 'auction_details' page on
John Pye's website, and it scrapes the data it needs from there to create a new
`auction` DB entry.

We then run through all the pages of the auction, as per the old `scraper.rb`
script and create new `item` DB entries for them. This process can be
retriggered at any time to update the price/closing times.

Then we can display a list of all items matching a price constraint in a form
similar to the original John Pye 'lot_list' page.

Background Processing
---------------------

I'm not going to impement 'proper' background workers with sidekiq or something,
that's overkill, but I do want a queriable API that can check if a scraper is
running, so that a spinner can be displayed and only one scraper launched at a
time.

I'm thinking that when a scraping process is required, the web app should launch
it as a background process outside the request/response cycle, and then there
can be an API endpoint to check if it's still running (presumably by sniffing
for a PID file in a known location). This is a bit fragile, but given the scope
of the project that's acceptable.


DB Schema
---------

### Auction

Field       | Description
------------|------------
ID          | Autoinc internal ID
URL         | URL to 'auction_details' page
CLOSING     | Pick from first item, or scrape from text on details page?
PYE_ID      | The John Pye reference, ie 'SR33' or similar, scraped from details page
PAGE_ONE_URL| First page of items, scraped from details page (used for indexing, saves scraping it multiple times)
EXPIRED     | Set true once we don't want to track an auction
NOTES       | Space for manually-set per-auction notes

### Item

Field          | Description
---------------|------------
ID             | Autoinc internal ID
AUCTION_ID     | id of the auction item 'belongs to'
URL            | URL to 'lot_details' page
CLOSING        | Last known closing datetime
PRICE          | Last known price
IMAGE_URL      | URL for the image/first image
DESCRIPTION    | Scraped description text
ITEM_NUMBER    | Scraped item number
LAST_SCRAPED_AT| Last time we scraped the data
NOTES          | Space for manually-set per-item notes


Scraping notes
--------------

### Auction

Field        | CSS Selector
-------------|-------------
Closing      | `#table6 tr:nth-child(3) td:nth-child(2) font`
Pye_id       | `font td font font`
Page_one_url | `td div strong`

### Item

From item list page, use `td:nth-child(4) a` to get list of items, build URLs
from the `href` attribute like:

`"http://www.johnpyeauctions.co.uk/#{item.attributes["href"].value}"`

`item.parent.parent` will produce the full `<tr>` for each item.

Field       | How to extract
------------|---------------
image_url   | `item.parent.parent.at_css("a[rel='popover']").attributes["data-img"].value`
description | `item.parent.parent.css("a h5")[1].text`
item_number | `item.parent.parent.at_css("a h5").text`
price       | `item.children.first.children.first.text.gsub("£","").to_i`
closing     | `item.parent.parent.css("a h5")[3].text` + further conversion!
