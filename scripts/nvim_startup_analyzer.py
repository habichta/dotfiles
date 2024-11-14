import re


def parse_time(line):
    """Extract and return the elapsed time in seconds from a given line."""
    matches = list(re.finditer(r"\d+\.\d+", line))
    if len(matches) > 1:
        return float(matches[1].group())
    return 0


def extract_longest_processes(filename, n=20):
    """Extract and print the top `n` longest processes in the startup log."""
    with open(filename, "r") as f:
        lines = f.readlines()

    time_lines = [(line, parse_time(line)) for line in lines if parse_time(line) > 0]
    sorted_lines = sorted(time_lines, key=lambda x: x[1], reverse=True)

    print(f"Top {n} longest setup processes:\n")
    for line, elapsed_time in sorted_lines[:n]:
        print(f"{elapsed_time:.3f} sec: {line.strip()}")


extract_longest_processes("nvim_startup_log.txt", n=10)
