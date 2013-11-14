#!/usr/bin/env python
__info__="""
    Given the data in the text file data.txt, plot the data using
    matshow, imshow, or something similar.  I want it to be a 2D plot
    showing the change in the Z-value.  The columns of the text file are
    the X, Y, and Z components respectively.

    Keith Prussing 2013-11-13
"""
import argparse
import logging
import os
import sys

import matplotlib
import matplotlib.pyplot as pyplot
import numpy

# Set the logger for module use.
logger = logging.getLogger(__file__)
logger.addHandler( logging.NullHandler() )
logger.setLevel(logging.DEBUG)

DEBUG = True

def reshape(data):
    """Reshape the data to be more like meshgrid."""
    ux = numpy.unique(data[:,0])
    uy = numpy.unique(data[:,1])
    XX = numpy.zeros((len(ux), len(uy)))
    YY = numpy.zeros((len(ux), len(uy)))
    ZZ = numpy.zeros((len(ux), len(uy)))
    for jt in range(len(uy)):
        y = uy[jt]
        for it in range(len(ux)):
            x = ux[it]
            m = (data[:,0] == x) & (data[:,1] == y)
            XX[it,jt] = x
            YY[it,jt] = y
            ZZ[it,jt] = data[m, 2]
        # end for
    # end for
    return XX, YY, ZZ
# end def reshape

if __name__ == "__main__":
    parser = argparse.ArgumentParser( \
            description=__info__, \
            formatter_class=argparse.RawDescriptionHelpFormatter \
        )
    parser.add_argument( \
            "-v", help="Verbose output", action="store_true" \
        )
    args = parser.parse_args()

    # Set the logging.
    logger.addHandler( logging.StreamHandler() )
    if DEBUG:
        logger.setLevel(logging.DEBUG)
    elif args.v:
        logger.setLevel(logging.INFO)
    else:
        logger.setLevel(logging.WARNING)
    # end if

    # Load the data.
    if not os.path.exists("data.txt"):
        logger.error("Some idiot moved the data.txt file...")
        sys.exit(1)
    # end if
    data = numpy.loadtxt("data.txt")
    logger.debug(data)
    XX, YY, ZZ = reshape(data)

    # Prepare the figure
    fig = pyplot.figure()
    axs = fig.add_subplot(1,1,1)

    # Stuff
    extent = numpy.array( ( \
            data[:,0].min(), data[:,0].max(), \
            data[:,1].min(), data[:,1].max()  \
        ) )

    # Use matshow
    # NOTE: imshow interpolates between the cells where matshow is solid
    #       throughout the cell.  imshow is prettier, but matshow is
    #       more true to the computed data.
    #cbr = axs.matshow( \
            #ZZ, cmap=matplotlib.cm.gist_heat \
        #)
    # pcolor seems to get it right!
    cbr = axs.pcolor( \
            XX, YY, ZZ, cmap=matplotlib.cm.gist_heat \
        )

    # Label the figure
    axs.set_xlabel("X")
    axs.set_ylabel("Y")
    axs.set_title("Testing Image Display")
    axs.axis("tight")
    fig.colorbar(cbr)
    pyplot.show()
    sys.exit(0)

# end if
