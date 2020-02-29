package net.hunnor.dict.ant;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

public class SegmentSizeTest {

  private static List<String> lines = new ArrayList<>();

  /**
   * Parse the XML input from resources and collect output lines.
   * @param tempDir temporary directory created by JUnit
   * @throws IOException if a read error occurs
   */
  @BeforeAll
  public static void parse(@TempDir File tempDir) throws IOException {
    
    SegmentSize limitLines = new SegmentSize();
    
    File file = new File(SegmentSizeTest.class.getResource("/dictionary.xdxf").getFile());
    limitLines.setFile(file);

    File toFile = new File(tempDir, "dictoinary-out.xdxf");
    limitLines.setToFile(toFile);

    limitLines.setSize(25);

    limitLines.execute();

    BufferedReader reader = new BufferedReader(new FileReader(toFile));

    String line;
    while ((line = reader.readLine()) != null) {
      lines.add(line);
    }

    reader.close();

  }

  @Test
  public void segmentSize() throws IOException {
    String line1 = lines.get(6);
    assertEquals(
        "      <def>12 <b>bold</b> text</def>", line1);
    String line2 = lines.get(9);
    assertEquals(
        "      <def>123 <b>bold   </b> text</def>", line2);
    String line3 = lines.get(12);
    assertEquals(
        "      <def>1234 <b>bold  </b> text</def>", line3);
    String line4 = lines.get(15);
    assertEquals(
        "      <def>12345 <b>bold </b> text</def>", line4);
  }

  @Test
  public void segmentSizeUtf8() {
    String line = lines.get(18);
    assertEquals(
        "      <def>blåbærsyltetøy <b>er</b> best med   <b>mye</b> brunost</def>", line);
  }

}
