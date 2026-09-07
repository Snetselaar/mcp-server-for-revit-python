# -*- coding: utf-8 -*-
"""Smoke test for server startup.

Every other test registers its tools against the MockMCP stand-in from
conftest, and none of them imports main.py, so nothing covers the entrypoint
the MCP client actually runs: the real FastMCP being constructed with its
settings and register_tools() wiring up all eight modules. A change that
breaks only that — a dropped FastMCP constructor argument, a module missing
from register_tools() — leaves the rest of the suite green while the server
no longer starts.
"""


async def test_server_imports_and_registers_every_module():
    import main

    names = {tool.name for tool in await main.mcp.list_tools()}

    # One representative tool per module in tools/__init__.py, so a module
    # dropping out of register_tools() shows up here.
    expected = {
        "get_revit_status",  # status_tools
        "list_revit_views",  # view_tools
        "place_family",  # family_tools
        "list_levels",  # model_tools
        "color_splash",  # colors_tools
        "execute_revit_code",  # code_execution_tools
        "launch_revit",  # launch_tools
        "open_document",  # document_tools
    }

    assert expected <= names, "niet geregistreerd: {}".format(sorted(expected - names))
