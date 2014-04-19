ZiegleIt
==============

Ever wanted to be able to rip through books like your name was Alex Ziegler? Well, now you can ZiegleIt! With our app you can quickly generate a summary of any article on the web to expedite your learning. When you're short on time, ZiegleIt.


##MVP
Our MVP will have the following features:

* Scrape web URLs and copy content with Nokogiri
* Take scraped content and generate a summary based on a fixed(?) compression ratio
* Deliver content to a txt file
* At this point in time we expect our algorithm to be optimized for Wikipedia articles

##Document Structure
* Title
  * Chapter
  * Chapter
  * Chapter
    * Section
      * Sub Section
        * Paragraph
          * Sentence
            * Word
        * Paragraph
        * Paragraph
      * Sub Section
      * Sub Section
    * Section
    * Section
  * Chapter

##Parsing Rules v1
1. There are a lot of blank elements (I'm guessing closing tags?) so first and foremost we need a guard clause that prevents nodes with blank ```inner_xml``` from making their way into the content:
```ruby
if node.inner_xml != ""
```
2. Break when ```See also</span>``` is reached in the current Nokogiri node inner xml. This is checked by matching a ```RegExp```:
```ruby
break if node.inner_xml.match(/(See also<\/span>)/)
```
3. The current section's text is no longer meaningful if a ```</span>``` tag has been reached. This is checked via ```RegExp``` as well:
```ruby
puts "Section: #{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}"
```
4. The table of contents is ignored (we are building our own afterall). We achieve this by excluding any node that has an h2 parent with inner xml of ```Contents```. We add it to our guard clause.
```ruby
if (node.inner_xml != "") && (node.inner_xml != "Contents")
```

##Algorithm



##Next Steps
* Get some sample Wiki articles
* Create some model structure to store data of each block
* Construct hierarchical tree of blocks going down to word level
* Start calculating shit...
  * Calculate RBSS of each block
  * 

##Resources
* [Hierarchical Summarization of Large Documents](http://intranet.cis.drexel.edu:8080/faculty/cyang/papers/yang2008h.pdf)
* [Nokogiri Gem](http://nokogiri.org/)