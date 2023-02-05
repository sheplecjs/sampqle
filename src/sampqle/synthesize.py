import random
import string
import warnings
from pathlib import Path

import lorem
import pandas as pd
from sdv import Metadata
from sdv.relational import HMA1
from sdv.tabular import GaussianCopula
from sdv.timeseries import PAR


def expand_prototable(pk: int, path: Path, samples: int, **kwargs) -> pd.DataFrame:
    """Model a toy table and extrapolate as if all else is equal.

    Args:
        pk (int): Primary key for the table.
        path (Path): Path to the json spec.
        samples (int): Size of final sampled table.

    Returns:
        pd.DataFrame: _description_
    """
    prototable = pd.read_json(path, **kwargs)
    model = GaussianCopula(primary_key=pk)
    model.fit(prototable)
    return model.sample(num_rows=samples)


def get_expanded_ecommerce_data(
    user_synth: int = 10,
    sessions_synth: int = 45,
    tx_synth: int = 6,
    nps_synth: int = 13,
    products_synth: int = 5,
    profiles_synth: int = 8,
    data_folder: Path = Path.cwd() / "data" / "ecommerce",
    num_samples: int = 1000,
) -> dict:
    """Generates a multi-table database from examples.

    Args:
        user_synth (int, optional): Desired number of entries in user table. Defaults to 10.
        sessions_synth (int, optional): Entries in sessions table. Defaults to 45.
        tx_synth (int, optional): Entries in transactions table. Defaults to 6.
        nps_synth (int, optional): Entries in nps table. Defaults to 13.
        products_synth (int, optional): Entries in products table. Defaults to 5.
        profiles_synth (int, optional): Entries in profiles table. Defaults to 8.
        data_folder (Path, optional): Path to folder containing data. Defaults to Path.cwd()./data/ecommerce.
        num_samples (int, Optional): Number of base (user) samples in the final sample.

    Returns:
        dict: A dictionary with table names as keys and dataframes of their synthetic data as values.
    """

    warnings.filterwarnings("ignore")

    meta = Metadata(str(data_folder / "meta.json"))

    users_expanded = expand_prototable(
        pk="user_id",
        path=data_folder / "users.json",
        samples=user_synth,
        convert_dates=[
            "birthday",
        ],
    )

    sessions_expanded = expand_prototable(
        pk="session_id", path=data_folder / "sessions.json", samples=sessions_synth
    )

    tx_expanded = expand_prototable(
        pk="transaction_id", path=data_folder / "transactions.json", samples=tx_synth
    )

    nps_expanded = expand_prototable(
        pk="nps_id", path=data_folder / "nps.json", samples=nps_synth
    )

    products_expanded = expand_prototable(
        pk="product_id", path=data_folder / "products.json", samples=products_synth
    )

    profiles_expanded = expand_prototable(
        pk="user", path=data_folder / "profiles.json", samples=profiles_synth
    )

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

    samp = model.sample(num_rows=num_samples)
    # nice! but one more thing...

    # generate text comments from half the nps responses and concat
    comm_len = len(samp["nps"]) // 2

    # lorem provides a generator we'll expand
    sentence = lorem.sentence(count=comm_len, comma=(0, 3), word_range=(3, 21))
    comms = []
    for n in range(comm_len):
        comms.append(next(sentence))

    # to 'synthesize' more realistically, we add an 'email' address to 10% of comments
    faked = set(range(comm_len))
    for n in range(comm_len // random.randrange(10, 15) - 1):
        fake_idx = random.choice(list(faked))
        faked.remove(fake_idx)
        fake_addr = (
            " "
            + "".join(random.choices(string.ascii_letters, k=random.randint(2, 12)))
            + "@"
            + "fakeaddress.foo"
        )

        # add this to a random element in the comment
        comment = comms[fake_idx].split()
        rand_idx = random.randint(0, len(comment))
        comment[rand_idx:rand_idx] = [fake_addr]
        comms[fake_idx] = " ".join(comment)

    # using concat because of different index sizes (reflecting 50% comment submission rate)
    comments = pd.DataFrame({"comments": comms})
    samp["nps"] = pd.concat([samp["nps"], comments], axis=1)

    return samp


def create_expanded_timeseries(
    proto: Path = Path.cwd() / "data" / "timeseries" / "aud.json",
) -> str:
    """Expands timeseries prototable and saves as a csv file.

    Args:
        proto (Path, optional): Path to prototable. Defaults to Path.cwd()/"data"/"timeseries"/"aud.json".

    Returns:
        str: String of path to csv.
    """

    df = pd.read_json(proto)
    df["date"] = df.index

    model = PAR(field_names=["Observed", "date"], sequence_index="date")

    model.fit(df)

    samp = model.sample(1)

    file = proto.parent / "aud.csv"

    samp.to_csv(file)

    return str(file)
