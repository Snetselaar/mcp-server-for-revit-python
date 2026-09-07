# -*- coding: utf-8 -*-
"""The Revit endpoint is read from the environment at import time.

The MCP client passes REVIT_PORT through its env block, so a second Revit
instance — pyRevit Routes moves up one port for each — can be reached without
editing main.py. These tests pin that the variables are actually honoured;
before this, the values were hardcoded and an env block silently did nothing.
"""

import importlib


def _reload_main():
    import main

    return importlib.reload(main)


def test_defaults_to_the_first_routes_port(monkeypatch):
    monkeypatch.delenv("REVIT_HOST", raising=False)
    monkeypatch.delenv("REVIT_PORT", raising=False)

    main = _reload_main()

    assert main.BASE_URL == "http://localhost:48884/revit_mcp"


def test_environment_overrides_host_and_port(monkeypatch):
    monkeypatch.setenv("REVIT_HOST", "127.0.0.1")
    monkeypatch.setenv("REVIT_PORT", "48885")

    main = _reload_main()

    assert main.REVIT_PORT == 48885
    assert main.BASE_URL == "http://127.0.0.1:48885/revit_mcp"

    # Leave the module on the defaults for whatever runs next.
    monkeypatch.delenv("REVIT_HOST")
    monkeypatch.delenv("REVIT_PORT")
    _reload_main()
