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