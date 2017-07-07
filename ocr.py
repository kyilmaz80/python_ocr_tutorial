#!/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import pytesseract
import requests
import pyocr
import pyocr.builders
import logging
from PIL import Image
from PIL import ImageFilter
from StringIO import StringIO


def process_image(url, lang='tur'):
    tools = pyocr.get_available_tools()
    if len(tools) == 0:
        logging.warning("No OCR tool found")
        return None

    tool = tools[1]
    logging.info("Will use tool '%s'" % (tool.get_name()))
    langs = tool.get_available_languages()
    logging.info("Available languages: %s" % ", ".join(langs))
    if lang in langs:
        logging.info("Will use lang '%s'" % (lang))
    else:
        logging.warning("tesseract-%s dil paketi bulunamadi.\
                        yum install tesseract-%s", lang)
        return None
    logging.info('imaj text e çevrilmeye çalışılıyor...')

    image = _get_image(url)
    image.filter(ImageFilter.SHARPEN)
    txt = tool.image_to_string(
        image,
        lang=lang,
        builder=pyocr.builders.TextBuilder()
    )

    #return pytesseract.image_to_string(image)
    return txt

def _get_image(url):
    return Image.open(StringIO(requests.get(url).content))
