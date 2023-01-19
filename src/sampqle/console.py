import json
import subprocess
from pathlib import Paths
from typing import List, Union

import click

from . import __version__
from .database import write_to_database
from .synthesize import create_expanded_timeseries, get_expanded_ecommerce_data


@click.command()
@click.version_option(version=__version__)
def info() -> None:
    """Basic info on SampQLe."""
    click.echo("SampQLe is a synthetic multi-table SQL example.")


@click.command()
@click.option(
    "--cred",
    default="credentials.json",
    help="location of file containing db credentials",
)
@click.option("--name", default="local_postgresql", help="Name of db.")
@click.option("--db", default="postgresql", help="DB type for engine url string.")
@click.option("--samples", default=1000, help="Number of samples in base table.")
@click.option(
    "--data", default=["ecommerce", "timeseries"], help="Specify data to synthesize."
)
def create(cred: str, name: str, db: str, samples: int, data: Union[List, str]) -> None:
    """Creates synthetic database with default values."""

    if "ecommerce" in data:
        results = get_expanded_ecommerce_data(num_samples=samples)
        write_to_database(results, cred, name)

        click.echo(f"Created and written tables for {[k for k in results.keys()]}.")

    if "timeseries" in data:
        p = create_expanded_timeseries()

        path = Path.cwd() / "data" / "timeseries" / "aud.csv"

        cmd = f"psql -f scripts/timeseries/00_create.sql -v timeseries='{path}'"
        proc = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
        output, error = proc.communicate()

        click.echo(
            f"Timeseries data written to csv at {p} and copied to sampqle_timeseries database"
        )
