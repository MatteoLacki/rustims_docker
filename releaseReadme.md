## Installation

You must have a working Docker instance.
Get the `release.zip` and perform:

```
unzip release.zip
cd release
./install
```

This step needs to be repeated only whenever you want a new image (and there is one new on dockerhub).

## Running 

To run jupyterlab, go for:

```
./jupyterlab
```

To run the simulator, go for:

```
./imspy_dda inputs/<your_folder_with_some_tdf_folders> inputs/<your_fasta_path>.fasta
```

