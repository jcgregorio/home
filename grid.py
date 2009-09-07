#!/bin/env python
import zipfile
import shutil   
import os
import sys
import re
from xml.dom.minidom import parseString
from optparse import OptionParser

MxN=re.compile("^(\d)x(\d)$")

usage = """usage: %prog [options] <presentation file name>

Adds grid lines of various geometries to OpenOffice Impress 
Presenations. Always creates a new file with the grid lines, never
overwrites the original file.
"""
parser = OptionParser(usage=usage)
parser.add_option("-f", "--fibonacci", dest="fib",
                  help="Fibonnaci grid of MxN cells", metavar="MxN")
parser.add_option("-r", "--rectangular", dest="rect",
                  help="Rectangular grid of MxN cells", metavar="MxN")
parser.add_option("-m", "--margin", dest="margin",
                  help="Margin, in units of inches NNin or centimeters NNcm")

(options, args) = parser.parse_args()

if options.fib and options.rect:
    parser.error("You may only select one of the options --fibonacci and --rectangular")

def parseMargin(margin):
    if margin.endswith("in"):
        return int(2540 * float(margin[:-2]))
    elif margin.endswith("cm"):
        return int(1000 * float(margin[:-2])) 
    else:
        sys.exit("Not a valid unit of measure, must be 'in' or 'cm'")


def parseMxN(s):
    search = MxN.search(s)
    if not search:
        sys.exit("Parameter must be MxN where M and N are between 2 and 9")
    return (int(search.group(1)), int(search.group(2)))


def fib(N):
    if N == 2:
        return [1, 2]
    else:
        f = fib(N-1)
        return f + [ f[-1]+ f[-2] ]


if len(args) == 1 and os.path.isfile(args[0]):
    # Write a new file, do not overwrite the original
    newfile = "grid-" + args[0]
    shutil.copyfile(args[0], newfile)

    # Find the DOM node that determines the snap lines
    
    # <config:config-item config:name="SnapLinesDrawing"
    # config:type="string">V6096V12192V18288V24384H4560H9144H13716H18288V0H0V30480H22860</config:config-item>
    preso = zipfile.ZipFile(args[0], "r")
    dom = parseString(preso.open("settings.xml").read())
    snaplines = None
    CONFIG = "urn:oasis:names:tc:opendocument:xmlns:config:1.0"

    for d in dom.getElementsByTagNameNS(CONFIG, "config-item"):
        name = d.getAttributeNS(CONFIG, "name")
        
        if name == "SnapLinesDrawing":
            snaplines = d
            
    # Here is where we figure out the height and width of the presentation
    #
    # xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    # xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    #
    # Pick the first master-page and pick its page-layout-name.
    #
    # <style:master-page style:name="Title1" style:page-layout-name="PM1"
    #

    # The find the page layout with that name and pull the width and height
    #
    #<style:page-layout style:name="PM1">
    #    <style:page-layout-properties fo:margin-top="0cm"
    #        fo:margin-bottom="0cm" fo:margin-left="0cm" fo:margin-right="0cm"
    #        fo:page-width="30.226cm" fo:page-height="22.606cm"
    #        style:print-orientation="landscape" />
    #</style:page-layout>

    STYLE = "urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    FO = "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    styledom = parseString(preso.open("styles.xml").read())
    visible_width = 0
    visible_height = 0
    master = styledom.getElementsByTagNameNS(STYLE, "master-page")[0]
    stylename = master.getAttributeNS(STYLE, "page-layout-name")
    for d in styledom.getElementsByTagNameNS(STYLE, "page-layout"):
        name = d.getAttributeNS(STYLE, "name")
        if name == stylename:
            properties = d.getElementsByTagNameNS(STYLE, "page-layout-properties")[0]
            visible_width = properties.getAttributeNS(FO, "page-width")
            visible_height = properties.getAttributeNS(FO, "page-height")
            break

    if options.fib:
        nx, ny = parseMxN(options.fib) 
        nx = fib(nx)
        ny = fib(ny)
    elif options.rect:
        nx, ny = parseMxN(options.rect) 
        nx = [1] * nx
        ny = [1] * ny
    else:
        parser.error("You must choose one of --fibonacci or --rectangle")
    
    if visible_width and visible_height and snaplines is not None:
        margin = 0
        if options.margin:
            margin = parseMargin(options.margin)
        width  = int(float(visible_width[:-2])*1000) - 2 * margin
        height = int(float(visible_height[:-2])*1000) - 2 * margin
        # Determine how big each cell is on a normalized unit measure 
        dx = width / sum(nx)
        dy = height / sum(ny)
        # Compute the Vertical grid lines position 
        xsteps = [margin]
        for d in nx:
            xsteps.append(dx*d + xsteps[-1])
        # Replace the last computed grid line with the actual right-hand side,
        # which fixes up for rounding errors introduced by our integer arithmetic
        xsteps[-1] = width + margin
        # Compute the Horizontal grid lines position 
        ysteps = [margin]
        for d in ny:
            ysteps.append(dy*d + ysteps[-1])
        ysteps[-1] = height + margin

        # Encode the grid line offsets and store in the DOM node
        snaplines.childNodes[0].nodeValue = "".join(["V" + str(s) for s in xsteps]) + "".join(["H" + str(s) for s in ysteps])
        presodest = zipfile.ZipFile(newfile, "w")
        for filename in preso.namelist():
            if filename == "settings.xml":
                presodest.writestr("settings.xml", dom.toxml())
            else:
                presodest.writestr(filename, preso.open(filename).read())
        presodest.close()
        print "Success!"
    else:
        print "Didn't find the settings needed to calculate new gridlines"
    preso.close()
else:
    print "A valid filename was not supplied."

