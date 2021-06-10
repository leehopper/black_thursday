# Method Deep Dive: Black Thursday

## .most_sold_item_for_merchant
-----------------------------------------------------
### What it does:
This method finds the item (or items in the case of a tie), that has top sales for a specific merchant. It finds the top sales when we provide a merchant id, allowing this method to be flexible to user input.  

### How it does it:
**step 1:** We start by grabbing the info we need from our invoice repository, through the SalesEngine. We use our find_all_ids_by_merchant_id to grab the invoice id's that are associated with the merchant id given at input. 

**step 2:** We then iterate through the array from our return value in SalesEngine with a .flat_map to create a new array. This .flat_map requires us to call the find_all_by_invoice_id from our invoice_items repository, so that we can connect each invoice id with their respective invoice_items. 

**step 3:** In our SalesAnalyst we then use our method: merchant_items_by_total_quantity. This method use a .map to iterate through the invoice_items array returned from above. As we iterate, we replace each invoice_item with a hash that uses the item_id as the key, and item quantity as the value. This array of hashes is then reduced and merged to combine duplicate item_ids into one key/value pair, that can be accessed through one main hash. 

**step 4:** Our hash then gets sent to another method in our SalesAnalyst that grabs an array of the hash's values. It iterates through these values with a .max to find the largest quantity from the collection. With this special value in tow, we go back to our hash to grab all the key/value pairs, that contain our selected value max. Finally, with .keys, we get our desired return output: an array containing all the item-ids associated with our most sold item(s).

**step 5:** Lastly, we end up at the method that will start the whole process: .most_sold_item_for_merchant. This method iterates over our item_ids array, and maps it to it's respective item instance, by using our SalesEngine method item_repo_find_by_id. Once called, this method will begin our full code journey, that ends with a return value of our most sold item_instance(s), by merchant id.

## .best_item_for_merchant
-------------------------------------------------------
### What it does:
This method finds a merchant's best item, which is based off of the revenue each item generates for the merchant. Using a merchant's id, we can return the item that has sold the best for that merchant. 

### How it does it:
**step 1:** We take steps 1 - 3 from our .most_sold_item_for_merchant to start us off. 

**step 2:** We use our SalesAnalyst method: merchant_items_by_total_quantity method, to iterate through an invoice_items array. With a .each, we create a hash where the value (quantity) is multiplied by the item's unit price. Using the item_ids that are stored as keys in our hash, we go to our SalesEngine method: .item_repo_find_by_id. This method returns an item instance that we can then use to access the unit price. 

**step 3:** We iterate through the new hash with a .max_by to find the largest value (revenue). Lastly, we are left with one key/value pair. We use the key (item_id) from this pair, as an input to our SalesEngine method: .item_repo_find_by_id, to connect the item_id to it's item instance. In the end this returns the best item instance for our merchant, based off of our merchant_id input. 
