Ten projekt prezentuje technologię JDBC - Java Database Connectivity.

To jest podstawowy sposób korzystania z relacyjnych ("SQL-owych") baz danych w Javie.

Zalety:
+ ujednolicony dostęp do różnych baz danych (trzeba pisać kody SQL pasujące do konkretnego rodzaju bazy, ale instrukcje Javy są jednakowe niezależnie czy to Oracle, czy MysSQL...)

+ mamy pełną kontrolę nad wykonywanych SQL-em i dostęp do bazy taki, jak go przewiduje standard SQL

Wady:
- obsługa większych baz danych (w sensie liczby tabel i kolumn) jest pracochłonna:
  * to my musimy napisać wszystkie polecenia SQL
  * odczyt i zapis każdego pola musi być zapisany wprost w kodzie jako oddzielna instrukcja.

