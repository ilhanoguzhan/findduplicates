# Find Duplicates

This app identifiess possible duplicate records in a data-set.

## Installation

```bash
$ bundle install
```

## Usage


### CLI
```bash
$ ruby run_on_terminal.rb advanced
in prompt: type "normal" or "advanced" for example data or your own
```
### Local

Run rack server
```bash
$ rackup config.ru
```

### On docker

Build and start docker container

```bash
$ docker-compose up
```

### Web UI (json)

example data: normal.csv

[localhost:8080](http://localhost:8080)

example data: advanced.csv

[http://localhost:8080/?advanced=1](http://http://localhost:8080/?advanced=1)



## Contributing

1. [Fork it](https://github.com/ilhanoguzhan/findduplicates/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a new Pull Request](https://github.com/ilhanoguzhan/findduplicates/compare)