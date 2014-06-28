# HashGleaner
## Summary
`HashGleaner` allows you to declare hash structure you want to get like Strong Parameters.

## Install
```
$ gem install hash_gleaner
```

## Example

```ruby
require 'hash_gleaner'

h = {
  :account => {
    :id => 1234,
    :email => 'xxx@xxx.xx',
    :name => 'John Doe',
    :phone => [
      {
        :id => 2345,
        :type => 'mobile',
        :number => 'xxxxxxxxxx',
      },
      {
        :id => 2346,
        :type => 'office',
        :number => 'yyyyyyyyyy',
      },
    ],
  },
}

params = HashGleaner.apply(h) do
           o :account do
             o :name
             o :phone do
               o :type
               o :number
             end
           end
         end
#=> {:account=>{:name=>"John Doe", :phone=>[{:type=>"mobile", :number=>"xxxxxxxxxx"}, {:type=>"office", :number=>"yyyyyyyyyy"}]}}
```

When `Hash` object includes `HashGleaner` module, you can use `glean` method.

```ruby
class << h; include HashGleaner; end

params = h.glean do
           o :account do
             o :name
             o :phone do
               o :type
               o :number
             end
           end
         end
```

A hash structure can be described as `Proc` object.

```ruby
proc = Proc.new{
  o :account do
    o :name
    o :phone do
      o :type
      o :number
    end
  end
}

params = h.glean(proc)
params = HashGleaner.apply(h, proc)
```

You can describe `required` or `optional` in hash structure.
When the hash object misses any required keys,
`HashGleaner` raises `MissingKeysException`.

```ruby
proc = Proc.new{
  (required)
  o :account do
    o :name
    o :phone do
      (required)
      o :number
      o :name
    end
  end
  (optional)
  o :admin
}

params = h.glean(proc)
#=> HashGleaner::MissingKeyException: Missing required keys [:name]
```
