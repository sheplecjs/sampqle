# SampQLe

A synthetic multi-table SQL sample.

## Features

CLI for running example scripts. Notebooks for annotated exploration.

## Synthesize a Database

1. If desired, customize data, tables, and relationships by adapting the prototypes and metadata in the data directory

2. If tables or relationships have changed, it may be necessary to adapt the `get_expanded_data` function in the synthesize module

3. Install the package locally with `poetry install`

4. Ensure you've supplied credentials pointing to a running database instance (see sample_credentials.json)

5. run `poetry run make-data`