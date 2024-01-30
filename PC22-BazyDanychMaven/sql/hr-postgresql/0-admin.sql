-- Wykonac jako user postgres (administrator)
-- Pozostale pliki juz jako user hr

DROP DATABASE IF EXISTS hr;
DROP ROLE IF EXISTS kurs;

CREATE USER kurs PASSWORD 'abc123';
CREATE DATABASE hr ENCODING 'utf-8' OWNER kurs;
