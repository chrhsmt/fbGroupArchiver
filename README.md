fbGroupArchiver
===============

facebook group archiver

requirements
------------

- ruby 2.x
- Bundler installed 

installation
------------
```
> git clone git@github.com:chrhsmt/fbGroupArchiver.git
> cd fbGroupArchiver
> bundle ins --path vendor/bundle
```

usage
------------

```
> bundle exec ruby ./archiver.rb -g "group id" -o ./user.json -u 
or
> bundle exec ruby ./archiver.rb -g "group id" -o ./post.json -p
```