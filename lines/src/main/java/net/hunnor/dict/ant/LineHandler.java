package net.hunnor.dict.ant;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import org.apache.tools.ant.BuildException;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class LineHandler extends DefaultHandler {

  private File file;

  private int size;

  private FileOutputStream stream = null;

  private XMLStreamWriter writer;

  private boolean doCount;

  private int currentSize;

  public File getFile() {
    return file;
  }

  public void setFile(File file) {
    this.file = file;
  }

  public int getSize() {
    return size;
  }

  public void setSize(int size) {
    this.size = size;
  }

  @Override
  public void startDocument() {
    try {
      stream = new FileOutputStream(file);
      writer = XMLOutputFactory.newInstance().createXMLStreamWriter(
          new OutputStreamWriter(stream, StandardCharsets.UTF_8));
      writer.writeStartDocument(StandardCharsets.UTF_8.name(), "1.0");
      writer.writeCharacters("\n");
      writer.writeDTD("<!DOCTYPE xdxf SYSTEM \"xdxf_lousy.dtd\">");
      writer.writeCharacters("\n");
    } catch (FileNotFoundException | XMLStreamException | FactoryConfigurationError e) {
      throw new BuildException(e);
    }
  }

  @Override
  public void endDocument() {
    try {
      writer.writeCharacters("\n");
      writer.writeEndDocument();
      writer.close();
      if (stream != null) {
        stream.close();
      }
    } catch (IOException | XMLStreamException e) {
      throw new BuildException(e);
    }
  }

  @Override
  public void startElement(String uri, String localName, String qualifiedName,
      Attributes attributes) throws SAXException {

    doCount = doCount || "def".equals(qualifiedName);

    if ("def".equals(qualifiedName)) {
      currentSize = 6;
    }

    int tagLength = qualifiedName.length() + 2;

    if (doCount) {
      spacify(tagLength);
    }

    try {
      writer.writeStartElement(qualifiedName);
    } catch (XMLStreamException e) {
      throw new BuildException(e);
    }

    currentSize = currentSize + tagLength;
    if (currentSize > size) {
      currentSize = currentSize % size;
    }

  }

  @Override
  public void endElement(String uri, String localName, String qualifiedName) throws SAXException {

    int tagLength = qualifiedName.length() + 3;

    if (doCount) {
      spacify(tagLength);
    }

    try {
      writer.writeEndElement();
    } catch (XMLStreamException e) {
      throw new BuildException(e);
    }

    currentSize = currentSize + tagLength;
    if (currentSize > size) {
      currentSize = currentSize % size;
    }

    doCount = doCount && !"def".equals(qualifiedName);

  }

  private void spacify(int tagLength) {

    int spaceLeftInSegment = size - currentSize;

    if (tagLength > spaceLeftInSegment) {

      StringBuilder sb = new StringBuilder(spaceLeftInSegment);
      for (int i = 0; i < spaceLeftInSegment; i++) {
        sb.append(" ");
      }
      String spaces = sb.toString();

      try {
        writer.writeCharacters(spaces);
      } catch (XMLStreamException e) {
        throw new BuildException(e);
      }

      currentSize = currentSize + spaceLeftInSegment;

    }

  }

  @Override
  public void characters(char[] chars, int start, int length) throws SAXException {

    try {
      writer.writeCharacters(chars, start, length);
    } catch (XMLStreamException e) {
      throw new BuildException(e);
    }

    if (doCount) {
      String str = new String(Arrays.copyOfRange(chars, start, start + length));
      byte[] bytes = str.getBytes(StandardCharsets.UTF_8);
      int charsLength = bytes.length;
      currentSize = currentSize + charsLength;
      if (currentSize > size) {
        currentSize = currentSize % size;
      }
    }

  }

}
