#!/usr/bin/env python

__info__="""
    Resize the terminal to display [N} file in vim with 72 columns in
    each file limited to the screen width.  This script has only really
    been tested with OS X so we'll see how this really works in mass
    usage.  If the number of characters is larger than the screen, it
    appears that the terminal window is limited by that number saving us
    a check.

    Keith Prussing 2013-11-13
"""
__version__ = "0.0.1"

import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser( \
            description=__info__, \
            formatter_class=argparse.RawDescriptionHelpFormatter \
        )
    parser.add_argument( \
            "N", type=int, default=2, nargs="?", \
            help="Number of file to display (default to 2)" \
        )
    parser.add_argument( \
            "H", type=int, default=0, nargs="?", \
            help="Number of row to use (default to full screen)" \
        )
    parser.add_argument( \
            "-v", help="Verbose output", action="store_true" \
        )
    args = parser.parse_args()
    
    print("\033[8;{0};{1};t".format(args.H, args.N *78))

# end if

