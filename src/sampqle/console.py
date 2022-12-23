import click
import json

from .synthesize import get_expanded_data
from .database import write_to_database

from . import __version__


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
@click.option("--name", default="local_postgresql", help="name of db")
@click.option("--db", default="postgresql", help="DB type for engine url string.")
def create(cred: str, name: str, db: str) -> None:
    """Creates synthetic database with default values."""
    results = get_expanded_data()

    write_to_database(results, cred, name)

    click.echo(f"Created and written tables for {[k for k in results.keys()]}.")