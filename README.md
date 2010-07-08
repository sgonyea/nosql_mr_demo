NoSQL MapReduce Demonstration
==============================

**Author**:       Scott Gonyea, me(at)sgonyea(com)    
**Twitter**:      [@acts\_as][twitter]    
**IRC**:          acts\_as in [#riak][irc]     
**Copyright**:    2010   
**License**:      See Source Code and Sample Data Attribution Sections. Where not specified: MIT License.    
**Release Date**: 2010-07-03    

Synopsis
--------

This project was created to highlight a few of the use-cases for MapReduce, with the [riak][basho] key/value 
store being used for demonstration.  That said; this data, the demonstrated concepts, and even some of the code, 
should prove to be both portable and useful, as you explore various MapReduce implementations.

This project's data and source code will be used in my presentation at the LA Ruby Meetup (July 2010). 
I hope you find it useful! I appreciate any and all feedback. 


Sample Data Attribution
-----------------------

**Project**:  [mrtoolkit][mrtoolkit]    
**File**:     [raw-logs][mrlogs]   
**Author**:   [Charles Hayden][chayden]   
**License**:  [GPLv3][gplv3]    

**Project**:  [IP to Country][geo-ip]     
**File**:     [geo-ip][geo-ip]    
**Author**:   [Webnet77][webnet77]    
**License**:  [Click for Author's Message (GPLv3)][geo-ip]    

**Project**:  [Windy City DB][geo-ip]     
**File**:     [Windy-City-DB-Dataset][wcfiles]    
**Author**:   [Stack Overflow][stackoverflow]    
**License**:  [Click for Author's Message (Creative Commons)][geo-ip]    


Source Code Attribution
-----------------------




Requirements
------------

- riak _(to use the source code without modification)_
- curl
- ruby 1.9.1 _(not tested on anything else)_
- gem: rake
- gem: riak-client _(officially supported by Basho)_


Usage
-----

Please see the respective files for the various chunks of sample data.  They include instructions 
on how to load the data into riak, as well as various MapReduce functions.  You may also look at 
the included Keynote presentation (+pdf) to see what all is highlighted by myself.



[twitter]:http://twitter.com/acts_as
[irc]:irc://irc.freenode.net/riak
[basho]:https://wiki.basho.com/display/RIAK/Riak
[chayden]:http://chayden.net/
[mrtoolkit]:http://code.google.com/p/mrtoolkit/
[mrlogs]:http://github.com/aitrus/nosql_mr_demo/master/sample_data/mrtoolkit_raw-logs
[geo-ip]:http://software77.net/geo-ip/
[mrtk-license]:http://software77.net/geo-ip/?license
[webnet77]:http://webnet77.com/
[windycity]:http://windycitydb.org/
[wcfiles]:http://github.com/chicagoruby/Windy-City-DB-Dataset
[stackoverflow]:http://blog.stackoverflow.com/category/cc-wiki-dump/
[gplv3]:http://www.gnu.org/licenses/gpl.html



