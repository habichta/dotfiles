imports = {
    "os": None,
    "functools": None,
    "collections": None,
    "datetime": None,
    "re": None,
    "numpy": "np",
    "pandas": "pd",
    "scipy": None,
}

for module, alias in imports.items():
    try:
        mod = __import__(module)
        if alias:
            globals()[alias] = mod
            name = f"{module} as {alias}"
        else:
            globals()[module] = mod
            name = module

        version = getattr(mod, "__version__", None)
        print(f"✅ imported {name} {'(v'+version+')' if version else ''}")

    except ImportError:
        pass
