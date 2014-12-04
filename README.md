# cf-invalidate

Invalidate files in Cloudfront distribution in your Wercker step.

It is recommended that you use application and deployment variables in wercker, so you don't include any private keys in your code.

# Options

* `key-id` (required) The Amazon Access key that will be used for authorization.
* `key-secret` (required) The Amazon Access secret that will be used for authorization.
* `distribution-id` (required) The Cloudfront distribution id to invalidate.
* `path` (required) The paths to invalidate (like: `/*`).

# Example

```
deploy:
    steps:
        - dlapiduz/cf-invalidate:
            key-id: $KEY
            key-secret: $SECRET
            distribution-id: $CF_DIST
            path: /index.html
```

# License

The MIT License (MIT)
