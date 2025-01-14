### rustims_docker

# Making an image:

1. On machine with the same architecture as the desired image: run
```
make image
```

To avoid cache bust:
```
make nobustimage
```

2. Cross-complition

WARNING!!! HERE BE DRAGONS!!! MAKING AN ARM64 ON AMD64 HANGS OR GIVES SEGFAULTS

```
make image_arm64
```

# Making a new release.zip

A `release.zip` is a zipped folder with all necessary functionality for a user to install and run the pipeline.
To obtain it, run:

```
make release.zip
```

Have a great day!

Matteo
