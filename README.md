[![Build Status](https://travis-ci.org/hunnor-dict/export-ant.svg?branch=master)](https://travis-ci.org/hunnor-dict/export-ant)

The `export-ant` repository contains scripts and stylesheets for converting the XML dump files to various XML-based dictionary formats.

To download the XML dump files, go to  https://dict.hunnor.net/about and look for the database download links.

# Conversion

Check the `formats` directory for the available formats.

Each format can be generated by applying XSLT transformations to the XML dump files.

While some formats use the XML dump files directly, others use an intermediate, pre-processed XML file that can be generated by applying the `simple-html` stylesheet to the XML dump files. Check the stylesheets and the XSpec tests to determine the proper input format.

# Formats

## Apple Dictionary

The format of Apple's Dictionary app for Mac. iOS uses the same dictionary file format, but there is no officially supported way to install custom dictionaries on iOS.

The compiler is part of Apple's Dictionary Development Kit, which is available in the Additional Tools for Xcode package from the [Apple SDK download page](https://developer.apple.com/download/more/). The dictionary can only be compiled on a Mac.

Source files: HunNor-Apple-[HN|NH].xml, HunNor-Apple-[HN|NH]-PList.xml

## Babylon

The proprietary, legacy format of the [Babylon dictionary](https://support.babylon.com/index.php?/Knowledgebase/Article/View/65/47/how-do-i-build-a-glossary).

Source files: HunNor-BB-[HN|NH].gls.gz

## Kindle

Dictionary for Kindle e-book readers. Only the Norwegian-Hungarian direction is generated. Because of limited language support, the dictionary is set to Portuguese.

## Lucene

A Lucene index directory with both directions, used by the native Android app. Spell checking index is included in a separate directory. Uses Lucene 3.6.2, to be compatible with Android.

## PDF

Separate PDF files for each direction, generated with Apache FOP.

## SDictionary

The custom format of the [SDictionary Project](http://swaj.net/sdict/). The textual source format compiles to an open source binary format.

Source files: HunNor-SD-[HN|NH].sdct.gz  
Compiled files: HunNor-SD-[HN|NH].dct

## SQLite

An SQLite database with both directions, used by the cross platform mobile apps.

## StarDict

Source files and compiled dictionaries in [StarDict format](https://github.com/huzheng001/stardict-3/blob/master/dict/doc/StarDictFileFormat). The files marked with NoSym-Number are recommended for Windows phones.

Source files: HunNor-ST-[HN|NH].xml.gz, HunNor-ST-[HN|NH]-NoSym-Number.xml.gz
Compiled files: HunNor-ST-[HN|NH].zip, HunNor-ST-[HN|NH]-NoSym-Number.zip
