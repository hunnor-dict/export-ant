package net.hunnor.dict.ant;

import java.io.File;
import java.io.IOException;

import javax.xml.XMLConstants;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.xml.sax.SAXException;

public class SegmentSize extends Task {

  private File file;

  private File toFile;

  private int size;

  public File getFile() {
    return file;
  }

  public void setFile(File file) {
    this.file = file;
  }

  public File getToFile() {
    return toFile;
  }

  public void setToFile(File toFile) {
    this.toFile = toFile;
  }

  public int getSize() {
    return size;
  }

  public void setSize(int size) {
    this.size = size;
  }

  @Override
  public void execute() {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    try {
      factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
      factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
      SAXParser parser = factory.newSAXParser();
      LineHandler handler = new LineHandler();
      handler.setFile(toFile);
      handler.setSize(size);
      parser.parse(file, handler);
    } catch (ParserConfigurationException | SAXException | IOException ex) {
      throw new BuildException(ex);
    }
  }

}
