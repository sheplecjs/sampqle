from sdv import Metadata
from sdv.relational import HMA1
from sdv.tabular import GaussianCopula
from pathlib import Path
import pandas as pd
import warnings


def get_expanded_data(
    user_synth: int = 10,
    sessions_synth: int = 45,
    tx_synth: int = 6,
    nps_synth: int = 13,
    products_synth: int = 5,
    profiles_synth: int = 8,
    data_folder: Path = Path.cwd() / "data",
    num_samples: int = 1000
) -> dict:
    """Generates a multi-table database from examples.

    Args:
        user_synth (int, optional): Desired number of entries in user table. Defaults to 10.
        sessions_synth (int, optional): Entries in sessions table. Defaults to 45.
        tx_synth (int, optional): Entries in transactions table. Defaults to 6.
        nps_synth (int, optional): Entries in nps table. Defaults to 13.
        products_synth (int, optional): Entries in products table. Defaults to 5.
        profiles_synth (int, optional): Entries in profiles table. Defaults to 8.
        data_folder (Path, optional): Path to folder containing data. Defaults to Path.cwd()./"data".
        num_samples (int, Optional): Number of base (user) samples in the final sample.

    Returns:
        dict: A dictionary with table names as keys and dataframes of their synthetic data as values.
    """

    warnings.filterwarnings("ignore")

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

    products_model = GaussianCopula(primary_key="product_id")
    products_model.fit(products)
    products_expanded = products_model.sample(num_rows=products_synth)

    profiles = pd.read_json(data_folder / "profiles.json")

    profiles_model = GaussianCopula(primary_key="user")
    profiles_model.fit(profiles)
    profiles_expanded = profiles_model.sample(num_rows=profiles_synth)

    tables = {
        "products": products_expanded,
        "users": users_expanded,
        "nps": nps_expanded,
        "sessions": sessions_expanded,
        "transactions": tx_expanded,
        "profiles": profiles_expanded,
    }

    model = HMA1(meta)
    model.fit(tables)

    return model.sample(num_rows=num_samples)
