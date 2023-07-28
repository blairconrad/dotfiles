try:
    import builtins
    import functools

    import rich
    import rich.pretty

    builtins.help = functools.partial(rich.inspect, help=True)
    rich.pretty.install()
except:
    pass
