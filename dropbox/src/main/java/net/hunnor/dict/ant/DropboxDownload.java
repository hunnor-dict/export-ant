package net.hunnor.dict.ant;

import com.dropbox.core.DbxException;
import com.dropbox.core.v2.DbxClientV2;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import org.apache.tools.ant.BuildException;

public class DropboxDownload extends DropboxBase {

  @Override
  public void execute() {

    DbxClientV2 client = getClient();

    try (FileOutputStream stream = new FileOutputStream(new File(toFile))) {
      client.files().downloadBuilder(file).download(stream);
    } catch (DbxException | IOException ex) {
      throw new BuildException(ex);
    }

  }

}
