def fork_bomb():
    """A fork bomb is a process that continually replicates itself to deplete system resources."""
    while True:
        fork_bomb()

fork_bomb()