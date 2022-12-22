from sdv import Metadata
from sdv.relational import HMA1
from sdv.tabular import GaussianCopula
from pathlib import Path
import pandas as pd
import datetime
import json

from .database import get_engine


def get_expanded_data(
    user_synth: int = 1000,
    sessions_synth: int = 4500,
    tx_synth: int = 600,
    nps_synth: int = 1300,
    products_synth: int = 25,
    profiles_synth: int = 850,
    data_folder: Path = Path.cwd().parent / "data",
) -> dict:
    """Generates a multi-table database from examples.

    Args:
        user_synth (int, optional): Desired number of entries in user table. Defaults to 1000.
        sessions_synth (int, optional): Entries in sessions table. Defaults to 4500.
        tx_synth (int, optional): Entries in transactions table. Defaults to 600.
        nps_synth (int, optional): Entries in nps table. Defaults to 1300.
        products_synth (int, optional): Entries in products table. Defaults to 25.
        profiles_synth (int, optional): Entries in profiles table. Defaults to 850.
        data_folder (Path, optional): Path to folder containing data. Defaults to Path.cwd().parent/"data".

    Returns:
        dict: A dictionary with table names as keys and dataframes of their synthetic data as values.
    """
    data_folder = Path.cwd().parent / "data"

    meta = Metadata(str(data_folder / "meta.json"))

    users = pd.read_json(
        data_folder / "users.json",
        convert_dates=[
            "birthday",
        ],
    )

    users_model = GaussianCopula(primary_key="user_id")
    users_model.fit(users)
    users_expanded = users_model.sample(num_rows=user_synth)

    sessions = pd.read_json(data_folder / "sessions.json")

    sessions_model = GaussianCopula(primary_key="session_id")
    sessions_model.fit(sessions)
    sessions_expanded = sessions_model.sample(num_rows=sessions_synth)

    transactions = pd.read_json(data_folder / "transactions.json")

    tx_model = GaussianCopula(primary_key="transaction_id")
    tx_model.fit(transactions)
    tx_expanded = tx_model.sample(num_rows=tx_synth)

    nps = pd.read_json(data_folder / "nps.json")

    nps_model = GaussianCopula(primary_key="nps_id")
    nps_model.fit(nps)
    nps_expanded = nps_model.sample(num_rows=nps_synth)

    products = pd.read_json(data_folder / "products.json")
    products_model = GaussianCopula(primary_key="products_id")
    products_expanded = products_model.sample(num_rows=products_synth)

    profiles = pd.read_json(data_folder / "profiles.json")

    profiles_model = GaussianCopula(primary_key="user")
    profiles_model.fit(profiles)
    profiles_expanded = profiles_model.sample(num_rows=profiles_synth)

    tables = {
        "products": products,
        "users": users_expanded,
        "nps": nps_expanded,
        "sessions": sessions_expanded,
        "transactions": tx_expanded,
        "profiles": profiles_expanded,
    }

    model = HMA1(meta)
    model.fit(tables)

    return model.sample()
