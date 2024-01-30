package sklep.db;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DBSettings {
	public static final String DB_SETTINGS_SYSTEM_PROPERTY = "sklep.db_settings_location";
	private static final String INTERNAL_DEFAULT_PROPERTIES = "/sklep.properties";

	private static DBSettings dbSettings; // singleton
	
	private final Properties props;

	private DBSettings() throws DBException {
		props = new Properties();
		String systemProperty = System.getProperty(DB_SETTINGS_SYSTEM_PROPERTY);
		try(InputStream input = systemProperty != null
					? new FileInputStream(new File(systemProperty))
					: DBSettings.class.getResourceAsStream(INTERNAL_DEFAULT_PROPERTIES) ) {
			props.load(input);
		} catch (IOException e) {
			//e.printStackTrace();
			throw new DBException("Cannot read settings. " + e, e);
		}
	}
	
	public static synchronized DBSettings getInstance() throws DBException {
		// Dla klasy typu "singleton" w aplikacji powstaje tylko jedna instancja (obiekt) tej klasy.
		// Dostęp do tego obiektu odbywa się poprzez metodę statyczną taką jak ta.
		// Tutaj mamy "leniwą inicjalizację", czyli obiekt jest tworzony przy pierwszej próbie dostepu.
		if(dbSettings == null) {
			dbSettings = new DBSettings();
		}
		return dbSettings;
	}
	
	public Properties getProperties() {
		return props;
	}
	
	public static Properties load() throws DBException {
		return getInstance().getProperties();
	}
	
}
