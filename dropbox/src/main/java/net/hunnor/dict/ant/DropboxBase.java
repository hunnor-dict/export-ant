package net.hunnor.dict.ant;

import com.dropbox.core.DbxRequestConfig;
import com.dropbox.core.v2.DbxClientV2;
import org.apache.tools.ant.Task;

public class DropboxBase extends Task {

  private static final String CLIENT_IDENTIFIER = "hunnor/dropbox-client";

  protected String file;

  protected String toFile;

  protected String token;

  public String getFile() {
    return file;
  }

  public void setFile(String file) {
    this.file = file;
  }

  public String getToFile() {
    return toFile;
  }

  public void setToFile(String toFile) {
    this.toFile = toFile;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  protected DbxClientV2 getClient() {
    DbxRequestConfig config = DbxRequestConfig.newBuilder(CLIENT_IDENTIFIER).build();
    return new DbxClientV2(config, token);
  }

}
