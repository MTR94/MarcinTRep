package sklep.web;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import sklep.db.DBException;
import sklep.db.DBSettings;
import sklep.db.RecordNotFound;

public class PhotoUtil {

    private static final String EXT = ".jpg";

    public static File getFile(int productId) throws DBException, RecordNotFound {
        Path path = getPath(productId);
        File file = path.toFile();
        if(file.exists()) {
            return file;
        } else {
            throw new RecordNotFound("Cannot read photo for product id = " + productId);
        }
    }

    public static byte[] readBytes(int productId) throws DBException, RecordNotFound {
        Path path = getPath(productId);
        try {
            return Files.readAllBytes(path);
        } catch (IOException e) {
            // System.err.println(e);
            throw new RecordNotFound("Cannot read photo for product id = " + productId);
        }
    }

    public static void writeStream(int productId, InputStream inputStream) {
        try {
            Path path = getPath(productId);
            Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) {
            // wypisujemy błąd, ale metoda kończy się normalnie
            e.printStackTrace();
        }
    }

    private static Path getPath(int productId) throws DBException {
        String dir = DBSettings.load().getProperty("photo_dir");
        String fileName = productId + EXT;
        return Paths.get(dir, fileName);
    }

}


