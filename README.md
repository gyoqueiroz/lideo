# Lideo

[![Gem Version](https://img.shields.io/gem/v/lideo?style=plastic)][gem]

[gem]: https://rubygems.org/gems/lideo

Simple RSS aggregator CLI. 


### Usage Examples
|          |                                            | 
|------------|--------------------------------------------|
| Add a feed to default group |`lideo add http://url.com/feed.xml` |
| Add a feed specifying a group |`lideo add -g groupname http://url.com/feed.xml` |
| List feeds |`lideo feeds` |
| Fetch feeds |`lideo fetch` |
| Fetch feeds of a given group |`lideo fetch -g groupname` use `all` to fetch all feeds |
| Fetch feeds and export to HTML|`lideo fetch --to html`|
| Fetch feeds from a given group and export to HTML| `lideo fetch -g groupname --to html`|





