# nx-spys-proxy
> Spys proxy.

## installation
```rb
# from gem
gem 'nx-spys-proxy'
# from git
gem 'nx-spys-proxy', git: 'git@github.com:afeiship/nx-spys-proxy.git'
```

## usage
```rb
Nx::SpysProxy::fetch

# results
[
  {
    :ip => "202.105.136.92",
    :port => "3128",
  },
  {
    :ip => "223.247.158.170",
    :port => "8080",
  },
  {
    :ip => "114.67.71.90",
    :port => "80",
  },
  # ... total: 93
]
```

## build/publish
```shell
# build
gem build nx-spys-proxy.gemspec

# publish
gem push nx-spys-proxy-0.1.0.gem
```

## resources
- http://spys.one/free-proxy-list/CN/