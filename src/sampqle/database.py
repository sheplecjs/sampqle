import json
from pathlib import Path

from sqlalchemy import create_engine, engine
from sqlalchemy_utils import create_database, database_exists, drop_database


def get_engine(
    cred: dict, db_type: str = "postgresql", engine_kwargs: dict = {"echo": False}
) -> engine:
    """Constructs a db engine from provided credentials.

    An existing instance is dropped first to avoid any conflicts from dependant views.

    Args:
        cred (dict): Dictionary of db credentials
        db_type (str, optional): Type of db connection. Defaults to "postgresql".
        engine_kwargs (_type_, optional): Anything to pass to create_engine. Defaults to {"echo": False}.

    Raises:
        KeyError: Improperly configured credentials.

    Returns:
        engine: sqlalchemy aql engine.
    """
    try:
        url = f"{db_type}://{cred['user']}:{cred['password']}@{cred['host']}:{cred['port']}/{cred['db']}"
    except (KeyError, TypeError):
        raise KeyError(
            "cred argument should be a dict including user, password, host, port, and db keys."
        )

    if database_exists(url):
        drop_database(url)

    create_database(url)

    engine = create_engine(url, **engine_kwargs)

    return engine


def write_to_database(
    data: dict,
    credential_file: Path = Path.cwd() / "credentials.json",
    credential_name: str = "local postgresql",
) -> None:
    """Writes a dictionary database to an engine specified by credentials.

    Args:
        data (dict): Dictionary of dataframes.
        credential_file (Path, optional): Path to credential file. Defaults to Path.cwd().parent/"credentials.json".
        credential_name (Str, optional): Name of credential to be used. Defaults to "local postgresql".
    """

    with open(credential_file) as file:
        cred = json.load(file)

    engine = get_engine(cred=cred[credential_name])

    with engine.connect() as conn:
        for name, table in data.items():
            table.to_sql(name, conn, if_exists="replace")
