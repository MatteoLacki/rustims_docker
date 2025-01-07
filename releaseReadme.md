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

This will allow you to run an interactive jupyterlab session in your browser, available under `http://localhost:8888`
The secret token will be shown in the output of jupyterlab.
It can work remotely, so replace simply `localhost` with your server's ip.

To run `imspy_dda`, go for:

```
./imspy_dda inputs/<your_folder_with_some_tdf_folders> inputs/<your_fasta_path>.fasta --config inputs/<your_config_path>
```

For example, create a folder `input/test` and put folder `1.d`, `2.d`, and `3.d` inside, together with `some.fasta` and a config (default provided in configs folder) `config_hla.toml`.

Folder structure will thus look so:

```
inputs/test/1.d
            2.d
            3.d
            some.fasta
            config_hla.toml
```

Then, run `./imspy_dda inputs/test inputs/test/some.fasta inputs/test --config inputs/test/config_hla.toml`.

For other options, run help with `./impspy --help`.

We wish you happy searching and finding whatever you really really want.
