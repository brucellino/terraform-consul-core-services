#!/bin/env python3
import requests
import xmltodict
import json


def get_top_bdii():
    data = requests.get(
        "https://goc.egi.eu/gocdbpi/public/?method=get_service_endpoint&service_type=Top-BDII"
    )
    xpars = xmltodict.parse(data.text, strip_whitespace=True)
    j = json.dumps(xpars["results"], allow_nan=False)

    r = {"output": str(j)}
    print(json.dumps(r))


if __name__ == "__main__":
    get_top_bdii()
