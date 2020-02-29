package net.hunnor.dict.ant;

import com.dropbox.core.DbxException;
import com.dropbox.core.v2.DbxClientV2;
import com.dropbox.core.v2.files.WriteMode;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import org.apache.tools.ant.BuildException;

public class DropboxUpload extends DropboxBase {

  @Override
  public void execute() {

    DbxClientV2 client = getClient();

    try (InputStream stream = new FileInputStream(file)) {
      client.files().uploadBuilder(toFile)
          .withMode(WriteMode.OVERWRITE)
          .uploadAndFinish(stream);
    } catch (IOException | DbxException ex) {
      throw new BuildException(ex);
    }

  }

}
