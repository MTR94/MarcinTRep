SELECT * FROM employees;

SELECT * FROM countries;

/* To jest komentarz blokowy
czyli taki, który może rozciągać się na wiele linii. */

-- To jest komentarz jednolinijkowy.

-- Zazwyczaj będziemy pisać komentarze przed instrukcją, którą opisujemy, np. tak:

-- To jest najprostsze zapytanie: odczytaj wszystko z tabeli countries:
SELECT * FROM countries;



--* Kwestia wielkości liter w SQL *--
-- Wersja dla PostgreSQL, ze wzmiankami na temat innych baz.

-- Jeśli chodzi o słowa kluczowe SQL, np. SELECT, to wielkość liter nie ma znaczenia:
SELECT * FROM employees;
select * from employees;
Select * fRoM employees;

-- Jeśli chodzi o nazwy tabel, kolumn itd, to sprawa jest bardziej skomplikowana...

-- Gdy używamy nazw niecytowanych, to wielkość liter w praktyce nie ma znaczenia:
SELECT * FROM employees; -- OK
SELECT * FROM Employees; -- OK
select * from EMPLOYEES; -- OK

-- Ale istnieją też nazwy "cytowane" i w takich nazwach wielkość liter ma znaczenie:
SELECT * FROM "Employees"; -- nie działa
select * from "EMPLOYEES"; -- nie działa w PostgreSQL, działa w Oracle
SELECT * FROM "employees"; -- działa w PostgreSQL, nie działa w Oracle

/* Bardziej szczegółowo.
 * PostgreSQL zamienia wszystkie nazwy pisane bez cudzysłowów na nazwy pisane małymi literami.
 * Oracle zamienia wszystkie nazwy pisane bez cudzysłowów na nazwy pisane WIELKIMI LITERAMI (i to jest zgodne ze standardem SQL).
 * Dzieje się to zarówno podczas definiowania obiektów bazodanowych (tabele i ich kolumny, widoki, sekwencje itd.),
 * jak i podczas odwoływania się do nich.
 
 * Uwaga! "Nazwa cytowana" to zupełnie coś innego niż 'napis'.
 */

-- Gdy zadajemy zapytanie np.
SELECT First_Name, last_name FROM emPloyees;
-- to Postgres wykona tak naprawdę
SELECT "first_name", "last_name" FROM "employees";

-- Gdy podczas tworzenia tabeli wpisuje nazwy bez cudzysłowów,
-- to wewnętrznie będą użyte małe litery.
CREATE TABLE TEst1(kolumna varchar(10));
INSERT INTO tEST1 VALUES('ABC');

-- Teraz prawdziwa nazwa tej tabeli to test1
-- Jeśli do odczytu używam nazwy w cudzysłowach, to muszę użyć tej wielkości liter.
SELECT * FROM "tEst1"; -- źle
SELECT * FROM "TEST1"; -- źle
SELECT * FROM "test1"; -- OK

-- Gdy używam nazw niecytowanych, to PostgreSQL zamienia je na małe litery i jest OK
SELECT * FROM test1;
SELECT * FROM tEst1;
SELECT * FROM TEST1;
-- Morał: Konsekwentnie używając nazw niecytowanych postępujemy prawidłowo.


-- Gdybym podczas tworzenia tabeli użył nazwy "cytowanej",
-- to utworzona tabela będzie miała dokładnie taką wielkość liter, jakiej użyłem.
CREATE TABLE "TesT2"("KOLUMNA" varchar(10));
INSERT INTO "TesT2" VALUES('XYZ');

-- Teraz jedynym sposobem poprawnego odwołania się do tej tabeli jest użycie nazwy cytowanej "TesT2"
SELECT * FROM "TesT2";

-- Bo gdy użyjemy nazwy niecytowanej, to niezależnie od wielkości liter, zostanie ona zamieniona na DUZE LITERY
SELECT * FROM test2; -- źle
SELECT * FROM TesT2; -- źle bo Postgres szuka tabeli "test2", a tabela nazywa się "TesT2"

-- Nazwy "cytowane" mogą się przydać, jeśli chcemy zachować wielkość liter, użyć nazwy zarezerwowanej jako słowo kluczowe, użyć w nazwie znaków specjalnych, w tym spacji.

CREATE TABLE "Roczne zarobki" ("wartość w złotych" numeric(10,2));
INSERT INTO "Roczne zarobki" VALUES(1234.56);

SELECT * FROM "Roczne zarobki";

DROP TABLE test1;
DROP TABLE "TesT2";
DROP TABLE "Roczne zarobki";


-- Ja osobiście piszę nazwy bez cudzysłowów i małymi literami.
-- A słowa kluczowe SQL piszę wielkimi.
SELECT * FROM employees;
-- Ale konwencje w świecie SQL bywają różne. "Oraclowcy" często piszą odwrotnie
select * from EMPLOYEES;


--* Polecenia modyfikacji danych (DML) - podstawy *--

-- INSERT - wstawia zupełnie nowy rekord do tabeli (takie id nie może wcześniej występować)

INSERT INTO countries(country_id, country_name, region_id)
    VALUES('PL', 'Poland', 1);

-- Gdy podajemy nazwy kolumn do wstawienia, mamy prawo podać je w zmienionej kolejności lub niektóre pominąć.
-- Dla pominiętych przyjmowana jest wartość domyślna z definicji tabeli lub NULL.
-- (Można też jawnie wpisać DEFAULT lub NULL w miejsce wartości.)
INSERT INTO countries(country_name, country_id)
    VALUES('San Escobar', 'Se');

-- Jeśli za tabelą nie podamy nazw kolumn, musimy wstawić wszystkie w tej samej kolejności jak w definicji tabeli.
INSERT INTO countries
    VALUES('CZ', 'Czech Republic', 1);

SELECT * FROM countries ORDER BY country_id;

-- UPDATE - modyfikacja istniejących danych

UPDATE countries SET country_name = 'Czechia' WHERE country_id = 'CZ';

-- Przykład zmiany w wielu rekordach: programistom dajemy podwyżkę 10 tys. i ustawiamy prowizję na 10%
-- Nowa wartość może zależeć od dotychczasowej.
UPDATE employees SET salary = salary + 10000, commission_pct = 0.1 WHERE job_id = 'IT_PROG';

SELECT * FROM employees ORDER BY employee_id;

-- Cofnięcie tych zmian.
-- UPDATE employees SET salary = salary - 10000, comission_pct = NULL WHERE job_id = 'IT_PROG';

-- DELETE - usunięcie rekordów wskazanych za pomocą warunku WHERE

DELETE FROM countries WHERE country_id IN ('PL', 'CZ', 'Se');

-- Uwaga: Brak WHERE spowoduje usunięcie wszystkich rekordów. Uwaga na zaznaczanie.



--* SELECT *--
/* Ogólna składnia polecenia SELECT:
SELECT kolumny
FROM tabele
WHERE warunek rekordów
GROUP BY kryteria grupowania
HAVING warunek grup
ORDER BY kryteria sortowania
...

Poszczególne części nazywa się "kaluzulami" (clause).
Na końcu można dopisywać różne niestandardowe rozszerzenia poszczególnych baz danych,
np. LIMIT / OFFSET w PostgreSQL.
*/

-- Sama klauzula SELECT określa kolumny, które mają znaleźć się w wyniku.

SELECT first_name, last_name, salary
FROM employees;

-- Gdy wpiszemy *, to odczytamy wszystkie dostępne kolumny.
SELECT * FROM employees;

-- Teraz odczytamy wszystkie kolumny z obu tabel.
SELECT * FROM employees, departments;

-- A to odczyta trzy kolumny z employees, oraz wszystkie kolumny z departments.
SELECT employees.first_name, employees.last_name, employees.salary, departments.*
FROM employees, departments;

-- Jeśli nazwy kolumn są jednoznaczne (tzn. znajdują się tylko w jednej z podanych tabel),
-- można nie pisać prefiksu z nazwą tabeli.
SELECT first_name, last_name, salary, departments.*
FROM employees, departments;

SELECT first_name, last_name, salary, department_name
FROM employees, departments;

-- Kolumna manager_id występuje w obu tabelach i teraz nie mogę jej odczytać bez podawania nazwy tabeli
-- BŁĄD
SELECT manager_id
FROM employees, departments;

-- OK
SELECT employees.manager_id, departments.manager_id
FROM employees, departments;

-- Jeśli chcę odczytać wszystkie kolumny z tabeli, a oprócz nich dodać jeszcze jakieś (np. wyliczane wyrażeniem),
-- to w Postgresie MOŻNA użyć symbolu * , a nie zadziałałoby to w Oracle
SELECT *, lower(email) || '@alx.pl' as prawdziwy_email
FROM employees;

-- W Oracle trzeba poprzedzić * nazwą tabeli.
SELECT employees.*, lower(email) || '@alx.pl' as prawdziwy_email
FROM employees;

-- W klauzuli SELECT można nie tylko wskazywać istniejące kolumny,
-- ale można też wpisywać wyrażenia, które coś obliczają.

SELECT first_name, last_name, salary,
    12 * salary,
    length(last_name),
    upper(first_name || ' ' || last_name),
    current_timestamp,
    2+2
FROM employees;

-- Wynikowym kolumnom można nadawać własne nazwy. To są tzw. aliasy kolumn.
-- Przy okazji: ciekawy, bardzo praktyczny, sposób formatowania kodu
SELECT first_name AS imie
    , last_name AS nazwisko
    , salary
    ,12 * salary AS roczne_zarobki
    ,length(last_name) AS dlugosc_nazwiska
    ,upper(first_name || ' ' || last_name) AS kto_tam
    ,current_timestamp AS czas
    ,2+2 AS wynik
FROM employees;

-- W praktyce najczęściej alias definiuje się za pomocą "Nazwy cytowanej",
-- aby zachować wielkoćć liter i aby można było użyć spacji i innych znaków:
SELECT first_name as "Imię", last_name as "Nazwisko"
    ,salary as "Miesięczne zarobki"
    ,12 * salary as "Roczne zarobki"
FROM employees;

-- W Oracle obowiązkowe jest pisanie FROM.

-- To jest poprawne w PostgreSQL, SQLite, MySQL, ale nie w Oracle:
SELECT 2+2;
SELECT current_date, current_timestamp, random();

-- W Oracle w sytuacjach, gdy chcemy coś wykonać bez odczytywania danych z tabel,
-- korzysta się z wirtualnej tabeli DUAL:
-- To nie działa w PostgreSQL
SELECT 2+3, current_date, current_timestamp FROM dual;

-- Zobaczmy co ta tabela zawiera... :-)
-- SELECT * FROM dual;


-- DISTINCT powoduje pobranie danych bez powtórzeń:
SELECT first_name FROM employees;
SELECT DISTINCT first_name FROM employees;

-- Jeśli zapytanie zwraca kilka kolumn, to unikalne mają być "krotki", czyli kombinacje wartości.
-- Np. teraz niektóre imiona się powtarzają, niektóre nazwiska się powtarzają,
-- ale nie ma osoby o identycznej kombinacji imienia i nazwiska.
SELECT DISTINCT first_name, last_name FROM employees;


--* Klauzula WHERE *--

/* W WHERE podaje się warunek logiczny,
który dla każdego wiersza decyduje czy ten wiersz ma znaleźć się wśród wyników.
W warunku można odwoływać się do pól rekordu na podobnych zasadach jak w SELECT
(to się zmieni, gdy dojdziemy do grupowania).

Rozumując programistycznie, można sobie wyobrazić, że serwer bazodanowy czyta wszystkie rekordy z tabeli
i w pętli dla każdego rekordu sprawdza warunek.
Jednak zwn wydajność bazy danych dokonują różnych optymalizacji,
dzięki którym mogą szybciej znajdować rekordy spełniające warunek.
Zasadniczą rolę w przyspieszaniu wyszukiwania pełnią indeksy,
dzięki którym (w wielkim uproszczeniu) dla podanego kryterium baza od razu ma wskazane,
które rekordy należy odczytać - nie przegląda już pozostałych.
Indeksy spełnią swoją rolę, jeśli w warunku odwołujemy się do zindeksowanych kolumn lub wyrażeń.
*/

SELECT * FROM employees
WHERE salary >= 10000;

-- Uwaga dla programistów: sprawdzenie równości to po prostu pojedyncze =
SELECT * FROM employees
WHERE salary = 10000;

-- Uwaga dla programistów Javy: także dla napisów  :-)
SELECT * FROM employees
WHERE last_name = 'King';

-- Co więcej, nie tylko liczby, ale także napisy, daty itp. można porównywać na zasadzie mniejsze/większe i sortować.
SELECT * FROM employees
WHERE last_name <= 'King';

-- Można używać porównań: < <= > >= =  
-- Nierówne na dwa sposoby: != <>
SELECT * FROM employees WHERE last_name != 'King';
SELECT * FROM employees WHERE last_name <> 'King';

-- Spójniki logiczne: AND, OR, NOT
-- Odczytaj te osoby, które zarabiają > 10 tys i jednocześnie mają na nazwisko King
-- AND - logiczne "i", koniunkcja, działa jak część wspólna zbiorów
SELECT * FROM employees WHERE salary > 10000 AND last_name = 'King';

-- OR - logiczne "lub", alternatywa, działa jak suma zbiorów
SELECT * FROM employees WHERE salary > 10000 OR last_name = 'King';

-- NOT - negacja, odwrócenie znaczenia warunku
SELECT * FROM employees WHERE NOT last_name = 'King';

-- Wypiszmy osoby, które zarabiają od 5 do 10 tys.
SELECT * FROM employees
WHERE salary >= 5000 AND salary <= 10000;

-- Akurat jeśli chodzi o sprawdzanie przedziałów, można użyć operatora BETWEEN:
-- Zauważmy, ze BETWEEN opisuje przedziały obustronnie domknięte.
SELECT * FROM employees
WHERE salary BETWEEN 5000 AND 10000;

-- Wypisz pracowników o nazwiskach na litery od C do K
SELECT * FROM employees WHERE last_name BETWEEN 'C' AND 'L';


-- Odczytajmy pracowników ze stanowisk ST_CLERK oraz ST_MAN
SELECT * FROM employees
WHERE job_id = 'ST_CLERK' OR job_id = 'ST_MAN';

-- Operator IN sprawdza czy wartość należy do zbioru.
-- Zbiór można podać w treści zapytania wymieniając wartości w nawiasach okrągłych:
SELECT * FROM employees
WHERE job_id IN ('ST_CLERK', 'ST_MAN');

-- Ale operator IN może być też używany w połączeniu z podzapytaniem...
-- Zakładając, że posiadamy tabelę selected_jobs, można by tak:
/* SELECT * FROM employees
   WHERE job_id IN (SELECT job FROM selected_jobs); */

-- Operator LIKE - sprawdzanie czy napis pasuje do wzorca
SELECT * FROM employees
WHERE job_id LIKE 'ST%';

-- We wzorcach:
-- znak % oznacza dowolnej długości ciąg dowolnych znaków
-- znak _ oznacza pojedynczy dowolny znak
-- za pomocą symbolu \ można "wy-escape-ować" znaki specjalne, gdyby miały być faktyczną treścią
SELECT * FROM employees WHERE job_id LIKE 'ST\_%';


-- Wielkość liter MA znaczenie.

-- wszystkie nazwiska zaczynające się na K
SELECT first_name, last_name FROM employees WHERE last_name LIKE 'K%';

-- wszystkie nazwiska zaczynające się na K , a kończące się na g
SELECT first_name, last_name FROM employees WHERE last_name LIKE 'K%g';

-- druga litera nazwiska jest równa a
SELECT * FROM employees WHERE last_name LIKE '_a%';

--! Specyfika PostgreSQL !--
-- W PostgreSQL istnieje dodatkowo ILIKE, który ignoruje wielkość liter
-- bez Oxfrord
SELECT city FROM locations WHERE city LIKE '%o%o%';

-- zawiera Oxford
SELECT city FROM locations WHERE city ILIKE '%o%o%';

-- wersja Oracle:
SELECT city FROM locations WHERE lower(city) LIKE '%o%o%';

-- Informacja nt SIMILAR TO oraz regexp_match
-- https://www.postgresql.org/docs/12/functions-matching.html



-- Uwaga! W WHERE nie można używać aliasów kolumn wprowadzonych w klauzuli SELECT:
-- Takie rzeczy mogą działać w niektórych innych bazach danych
-- (tych lajtowo podchodzących do standardów, np. SQLite :-) ), ale nie w PostgreSQL ani Oracle
-- BŁĄD!
SELECT first_name, last_name, 12*salary AS roczne
FROM employees
WHERE roczne <= 100000;

-- W Postgres (i Oracle) takie rzeczy - jeśli trzeba- realizuje się zapytaniami zagnieżdżonymi:
-- OK
SELECT * FROM (
    SELECT first_name, last_name, 12*salary AS roczne
    FROM employees) sub
WHERE roczne <= 100000;


--* Temat NULL *--

-- Zobaczmy, że NULL nie jest zwykłą wartością, tylko powoduje dziwne zachowania, gdy się pojawia.

-- W tabeli employees istnieje kolumna commission_pct, która u niektórych pracowników zawiera liczbę,
-- a u pozostałych ma wartość NULL.
SELECT * FROM employees;

-- Gdy próbujemy odczytać pracowników, którzy mają prowizję równą NULL, to nie działa taki zapis,
-- dostaniemy puste wyniki:
SELECT * FROM employees WHERE commission_pct = NULL;

-- Odwrotny warunek też daje puste wyniki:
SELECT * FROM employees WHERE commission_pct != NULL;
SELECT * FROM employees WHERE NOT (commission_pct = NULL);

-- Dla wartości NULL nieprawdą jest ani > , ani <
-- Ci, którzy nie uzyskują prowizji, nie pojawią się ani w jednej, ani w drugiej grupie:
SELECT * FROM employees WHERE commission_pct > 0.2;
SELECT * FROM employees WHERE commission_pct <= 0.2;

-- Aby sprawdzić czy jest jest równa NULL, czy nie, należy użyć wyspecjalizowanych operatorów IS (NOT) NULL
SELECT * FROM employees WHERE commission_pct IS NULL;
SELECT * FROM employees WHERE commission_pct IS NOT NULL;

/* Praprzyczyną tego dziwnego zachowania jest fakt, iż na początku historii SQL uznano,
że NULL będzie oznaczał BRAK WIEDZY jaka jest wartość danego pola.
Czyli tak jakby w tym przykładzie wartość NULL znaczyła "nie wiadomo jaką prowizję uzyskuje pracownik".
Do takiego znaczenia wartości NULL dostosowano całą logikę i działanie operatorów.

W praktyce jednak często przyjmuje się, że NULL oznacza "pustą wartość".
Oznacza "wiemy, że czegoś nie ma", jest puste, zerowe, brak.
Tak jak w tym przykładzie, intencją autora tabeli employees było na pewno,
aby NULL w polu commission_pct znaczył "pracownik nie otrzymuje żadnej prowizji".
I tak jest zazwyczaj w praktyce.
Jednak logika SQL tak tego nie rozumie. Dla niej NULL oznacza "nie wiadomo".

Więcej na temat teorii można szukać pod hasłem "logika trójwartościowa SQL".
*/

-- Porównanie z NULLem daje wynik NULL
SELECT 1 = NULL;

-- Ale spójniki logiczne starają się robić swoje nawet jeśli czasami jest nieznana wartość.
SELECT 1 = 1 AND 2 = NULL;

SELECT 1 = 1 OR 2 = NULL;

-- Operacje arytmetyczne itp. , gdzie wewnątrz pojawia się NULL, dają wynik NULL.
SELECT 2 * (3 + NULL) - 15 * 4;

/* Gdy wykonujemy obliczenia, w których pojawia się wartość NULL,
   to zazwyczaj wynikiem całego wyrażenia też jest NULL („null zaraża”).

   Tutaj pewne uproszczenie: przyjmujemy, że prowizja jest liczona względem pensji,
   a nie sprzedaży (której w tej bazie danych nie ma).

   Dla każdego pracownika chcemy obliczyć jego wypłatę wraz z dodaną prowizją.
   Przy poniższym zapisie wynikiem w ostatniej kolumnie
   jest NULL u tych pracowników, którzy nie uzyskują prowizji.
*/
SELECT first_name, last_name, salary, commission_pct
	,commission_pct * salary -- prowizja kwotowo
	,salary + commission_pct * salary -- kwota do wypłaty
FROM employees;

-- Aby zastąpić wartość NULL inną "konkretną" wartością, można użyć funkcji COALESCE
SELECT first_name, last_name, salary, commission_pct
	,coalesce(commission_pct * salary, 0) as "kwota prowizji"
	,salary + coalesce(commission_pct, 0) * salary as "wypłata z prowizją"
FROM employees;

-- coalesce(wartosc1, wartosc2, ....) -- dowolnie wiele wartości po przecinku
-- zwraca pierwszą z wartości podanych jako parametry, która nie jest nullem (no chyba ze wszystkie są)

SELECT coalesce(null, null, 'bingo', null, 'kapusta') FROM dual;

-- coalesce jest częścią standardu SQL i działa w większości baz danych
-- W praktyce najczęściej zapisuje się tak: coalesce(kolumna_ktora_moze_byc_null, wartosc_domyslna)

-- Nie ma obowiązku podstawiania zera.
SELECT first_name, last_name, salary, commission_pct,
    coalesce(commission_pct, 1234)
FROM employees;


--! Specyfika Oracle !--

-- W Oraclu jest też funkcja nvl, która działa tak jak dwuargumentowy coalesce:
-- NVL(x, y):   jeśli x nie jest nullem, to zwraca x, a jeśli x jest nullem, to zwraca y
SELECT first_name, last_name, salary, commission_pct
	,nvl(commission_pct * salary, 0) as "kwota prowizji"
	,salary + nvl(commission_pct, 0) * salary as "wypłata z prowizją"
FROM employees;

-- Inne funkcje Oracla związane z obsługą NULL:

-- NVL2(x, y, z)
-- jeśli x nie jest NULL, to zwraca y
-- jeśli x jest NULLem, to zwraca z

SELECT first_name, last_name, commission_pct,
	nvl2(commission_pct, 'jest prowizja', 'brak prowizji')
FROM employees;

-- Na siłę można to wykorzystać do wyliczenia łącznej wypłaty:
SELECT first_name, last_name, salary, commission_pct,
	nvl2(commission_pct, salary*(1+commission_pct), salary) AS "wypłata"
FROM employees;

-- NULLIF(x, y) -- o!, to działa też w PostgreSQL
-- jeśli x = y, to wynikiem jest NULL
-- jeśli x != y, to wynikiem jest x
SELECT city, nullif(city, 'Toronto') FROM locations;


--* ORDER BY - sortowanie wyników *--

-- Zasadniczo podaje się kryterium, wg którego dane wynikowe zostaną posortowane.
SELECT * FROM employees
ORDER BY salary;

-- Domyślnie sortowanie jest rosnące.
-- Aby sortować malejąco, należy dopisać na końcu DESC
SELECT * FROM employees
ORDER BY salary DESC;

-- Można też dopisać ASC dla rosnącego, ale nie trzeba, bo tak jest domyślnie.
SELECT * FROM employees
ORDER BY salary ASC;

-- Dodatkowe opcje pozwalają określić miejsce wartości NULL.
-- Domyślnie NULL jest traktowany jak większy od wszystkich wartości
-- (tak jest w PostgreSQL i Oracle, zgodnie ze standardem; w MySQL i SQLite jest odwrotnie)
-- Przy sortowaniu rosnącym nulle będą na końcu.
SELECT * FROM employees ORDER BY commission_pct;
SELECT * FROM employees ORDER BY commission_pct ASC;

-- Przy malejącym nulle będą na początku.
SELECT * FROM employees ORDER BY commission_pct DESC;

-- Za pomocą NULLS FIRST / NULLS LAST możemy jawnie podać gdzie mają być nulle
SELECT * FROM employees ORDER BY commission_pct NULLS FIRST;
SELECT * FROM employees ORDER BY commission_pct ASC NULLS FIRST;
SELECT * FROM employees ORDER BY commission_pct DESC NULLS FIRST;
SELECT * FROM employees ORDER BY commission_pct DESC NULLS LAST;

-- Sortować można wg wielu kryteriów wymienionych po przecinku.
-- Np. sortujemy wg nazwiska, a jeśli nazwiska są jednakowe, to wg imienia:
SELECT * FROM employees
ORDER BY last_name, first_name;

-- Wtedy ASC i DESC dotyczą tylko ostatniego kryterium, przy którym są napisane.
-- Inaczej mówiąc ASC i DESC muszą być podane niezależnie dla każdego kryterium.

-- Przykład: rosnąco wg job_id, w obrębie każdej takiej grupy malejąco wg pensji,
-- a na końcu rosnąco wg nazwiska i imienia
SELECT * FROM employees
ORDER BY job_id, salary DESC, last_name, first_name;

-- Dokładnie taki sam efekt:
SELECT * FROM employees
ORDER BY job_id ASC, salary DESC, last_name ASC, first_name ASC;

-- Co można wpisać jako kryterium?
-- nazwę kolumny
SELECT * FROM employees
ORDER BY job_id, salary DESC;

-- dowolne wyrażenie, nawet takie, którego wyniku nigdzie nie wypisuję
SELECT * FROM employees
ORDER BY length(first_name || last_name);

-- przykład: wymieszaj dane losowo:
SELECT * FROM employees ORDER BY random();
-- Wersja Oracle:
-- SELECT * FROM employees ORDER BY dbms_random.random();

-- Posortuj wg pensji z dodaną prowizją, tak jak liczyliśmy wcześniej
SELECT first_name, last_name,
    salary + coalesce(commission_pct, 0) * 10000 AS "do wypłaty"
FROM employees
ORDER BY salary + coalesce(commission_pct, 0) * 10000;

-- Można też podać alias kolumny
SELECT first_name, last_name,
    salary + coalesce(commission_pct, 0) * 10000 AS "do wypłaty"
FROM employees
ORDER BY "do wypłaty";

-- Lub numer kolumny licząc od 1
SELECT first_name, last_name,
    salary + coalesce(commission_pct, 0) * 10000 AS "do wypłaty"
FROM employees
ORDER BY 3 DESC;

SELECT employee_id, first_name, last_name, job_id, salary
FROM employees
ORDER BY 4, 5 DESC, 3, 2;

-- LIMIT / OFFSET
-- W różnych bazach danych istnieją różne sposoby, aby zapytanie zwróciło tylko pierwszy rekord / X pierwszych rekordów.
-- W PostgreSQL służy do tego dodatkowa klauzula LIMIT / OFFSET dopsywana na końcu zapytania (za klauzulą ORDER BY).

-- To zwraca pierwsze 10 rekordów
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Używając OFFSET możemy pobierać następne grupy, np. "drugą dziesiątkę"
-- OFFSET pomija określoną liczbę rekordów i zaczyna zwracać pewną liczbę następnych
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 10 OFFSET 10;

-- Od rekordu 91 do samego końca:
SELECT * FROM employees
ORDER BY salary DESC
OFFSET 90;

-- Używanie LIMIT / OFFSET bez sortowania jest poprawne technicznie,
-- ale ma mały sens logiczny.
-- Chyba, że w technicznym celu pobrania "próbki danych"...
SELECT * FROM employees
LIMIT 10;


--* JOIN i zapytania do wielu tabel *--

SELECT * FROM employees ORDER BY 1;

SELECT * FROM departments ORDER BY 1;

SELECT * FROM locations ORDER BY 1;

-- Zgodnie z najlepszymi praktykami dane w bazach rozdziela się do osobnych tabel i wiąże za pomocą "kluczy obcych".
-- Często w zapytaniach chcemy jednak uzyskać rekordy z jednej tabeli wraz z powiązanymi danymi z innych tabel.

-- Można we FROM podać więcej niż jedną tabelę:
SELECT * FROM employees, departments;

-- W takiej sytuacji baza danych zwraca wszystkie możliwe kombinacje rekordów z jednej tabeli z rekordami z drugiej tabeli
-- To jest tzw. "iloczyn kartezjański".
SELECT count(*) FROM employees, departments;
SELECT count(*) FROM employees; -- 107
SELECT count(*) FROM departments; -- 27
SELECT 107 * 27;

-- Aby zobaczyć tylko prawidłowo dopasowane rekordy, można dodać warunek w WHERE:
SELECT * FROM employees, departments WHERE departments.department_id = employees.department_id;

-- To samo za pomocą notacji JOIN:
SELECT * FROM employees JOIN departments ON departments.department_id = employees.department_id;


-- Aliasy tabel
-- Zamiast powtarzać długie nazwy tabel:
SELECT *
FROM employees, departments, locations
WHERE departments.department_id = employees.department_id
  AND locations.location_id = departments.location_id;

-- ... można wprowadzić "aliasy tabel" w sekcji FROM:
SELECT *
FROM employees emp, departments d, locations l
WHERE d.department_id = emp.department_id
  AND l.location_id = d.location_id;

-- Alias to nasza lokalna nazwa, którą nadajemy tabeli w obrębie jednego zapytania.
-- Alias wprowadzamy we FROM, a używamy w warunkach i pozostałych klauzulach zamiast nazwy tabeli
-- (nie możemy już używać oryginalnej nazwy tabeli!).

-- Są sytuacje, gdy alias tabeli jest niezbędny, aby napisać jakieś zapytanie (np. tzw. self join).

-- Uwaga składniowa: w Oraclu nie wolno pisać AS przed aliasem tabeli (w PostgreSQL i MySQL można, ale lepiej pisać tak, aby było przenośnie...).


-- Składniowo konstrukcja JOIN jest częścią klauzuli FROM, a warunek w ON jest dopełnieniem JOIN.
-- Porównajmy zapis z przecinkiem i WHERE do zapisu z JOIN-em, gdy czytamy dane z 3 tabel i jeszcze mamy warunek filtrowania:

-- 1) Warunki dotyczące złączenia oraz zwykłe warunki logiczne są razem w WHERE
SELECT *
FROM employees e, departments d, locations l
WHERE d.department_id = e.department_id
    AND l.location_id = d.location_id
    AND e.salary >= 10000;

-- 2) Po kolei dodajemy tabel i dla każdej od razu po JOIN wpisujemy warunek złączenia,
--    natomiast w WHERE mamy tylko inne warunki logiczne
SELECT *
FROM employees e
	JOIN departments d ON d.department_id = e.department_id
    JOIN locations l ON l.location_id = d.location_id
WHERE e.salary >= 10000;

-- Możliwości JOIN.
-- Są trzy sposoby podawania warunku złączenia: JOIN ON, JOIN USING, NATURAL JOIN
-- Są też różne "kierunki" złączeń: INNER, LEFT, RIGHT, FULL oraz CROSS


--* Warunki złączenia *--
-- (0) warunek podany w WHERE ? wrócimy do tego na koniec

-- (1) tabela1 JOIN tabela2 ON warunek
-- Najbardziej ogólny sposób dobierania rekordów, można podać dowolny warunek logiczny.
SELECT *
FROM employees JOIN jobs ON jobs.job_id = employees.job_id;

SELECT *
FROM employees e JOIN jobs j ON j.job_id = e.job_id;

-- Ten sposób jest jedynym dostępnym, gdy kolumny mają różne nazwy w jednej i drugiej tabeli.
-- SELECT * FROM samochody_sluzbowe s JOIN pracownicy p ON s.uzytkownik = p.nr_pracownika;

-- (2) tabela1 JOIN tabela2 USING(kolumny)
-- Wybrane będą te kombinacje rekordów, w których kolumny o podanej nazwie mają jednakową wartość w obu tabelach.
-- Wymaga to istnienia kolumn(y) o identycznej nazwie.
SELECT *
FROM employees JOIN jobs USING(job_id);

-- (3) tabela1 NATURAL JOIN tabela2
-- Dopasowywane są wszystkie te kolumny, które występują pod jednakową nazwą w jednej i drugiej tabeli.
SELECT *
FROM employees NATURAL JOIN jobs;

-- Jest to dość ryzykowne, grozi nam przypadkowa zbieżność nazw.
-- W tabelach employees i departments mamy 2 kolumny o takiej samej nazwie: department_id i manager_id
-- emp.manager_id - szef pracownika, dep.manager_id - kierownik departamentu
-- To zapytanie zwraca tylko tych pracowników, których bezpośrednim przełożonym jest kierownik departamentu:
SELECT *
FROM employees NATURAL JOIN departments;

-- To jest równoważne takiemu zapytaniu:
SELECT *
FROM employees JOIN departments USING(department_id, manager_id);

-- A zapewne chodziło nam o coś takiego:
SELECT *
FROM employees JOIN departments USING(department_id);

-- Morał: Lepiej nie używać NATURAL JOIN, bo może porównać inne kolumny niż byśmy chcieli.

-- Utożsamianie kolumn w USING i NATURAL JOIN

-- Gdy używamy przecinka i WHERE albo JOIN ON, to w wynikach znajdą się kolumny z obu tabel.
-- Jeśli istnieją kolumny o tej samej nazwie, to obie będą obecne jako osobne kolumny.
-- Gdybyśmy teraz chcieli wskazać taką kolumnę w części WHERE, GROUP BY, ORDER BY albo SELECT, to musimy zrobić to poprzez alias lub nazwę tabeli.
-- Poniższe zapytanie jest błędne: nazwa job_id jest niejednoznacza:
SELECT *
FROM employees e JOIN jobs j ON j.job_id = e.job_id
WHERE job_id = 'ST_CLERK';

-- To jest OK:
SELECT *
FROM employees e JOIN jobs j ON j.job_id = e.job_id
WHERE j.job_id = 'ST_CLERK';

-- Gdy używamy USING albo NATURAL JOIN, to w wynikach znajdzie się tylko jeden egzemplarz kolumny, wg której łączymy.

-- Uwaga dot. Oracla, ale nie dotyczy Postgresa! :
-- W Oracle NIE MOZNA odwoływać się tej kolumny poprzez alias/nazwę tabeli, można tylko bez prefiksu.
-- Poniższe zapytanie jest błędne w Oracle, niepotrzebny kwalifikator (prefiks)
SELECT *
FROM employees e JOIN jobs j USING(job_id)
WHERE j.job_id = 'ST_CLERK';

-- Błędny w Oracle jest również taki zapis (co jest trochę wkurzające... ;-) )
SELECT e.*, j.job_title
FROM employees e JOIN jobs j USING(job_id);

-- Ale oba te zapytania zadziałały w PostgreSQL.

-- To jest OK w obu bazach:
SELECT *
FROM employees e JOIN jobs j USING(job_id)
WHERE job_id = 'ST_CLERK';

--* "Kierunki złączeń" *--
-- Czyli co zrobić, gdy wartości nie uda się dopasować.

-- Sprawdźmy takie zapytanie...
SELECT *
FROM employees e, departments d
WHERE d.department_id = e.department_id;

-- W wynikach jest 106 rekordów, brakuje Kimberely Grant,
-- ponieważ ona w polu department_id ma NULL
SELECT * FROM employees WHERE department_id IS NULL;

-- Istnieją też departamenty, w których nikt nie pracuje.
SELECT DISTINCT department_id FROM employees ORDER BY 1;
SELECT DISTINCT department_id FROM departments ORDER BY 1;

-- A co się dzieje, gdy użyjemy JOIN?
SELECT *
FROM employees JOIN departments USING(department_id);

-- Jeśli używamy składni opartej o JOIN, możemy jednak ten problem rozwiązać.
-- Możemy wybrać rodzaj złączenia i w ten sposób powiedzieć co ma się stać z rekordami, które są w jednej tabeli, a nie mają dopasowania w drugiej tabeli.

-- Złączenia domyślnie są wewnętrzne, tzn. niepasujące rekordy nie są wyświetlane.
-- 106 wyników, nie ma K.Grant, nie też departamentów, w których nikt nie pracuje, np. Payroll:
SELECT * FROM employees INNER JOIN departments USING(department_id);

-- Słowo kluczowe INNER jest opcjonalne i nie zmienia zachowania. Złączenia domyślnie są wewnętrzne.
SELECT * FROM employees JOIN departments USING(department_id);

-- LEFT JOIN wypisuje wszystkie rekordy z lewej tabeli oraz tylko te z prawej tabeli, które udało się dopasować.
-- 107 rekordów, jest K.Grant, widoczne są jej dane, a w kolumnach pochodzących z tabeli departments są u niej wpisane NULL-e:
SELECT * FROM employees LEFT JOIN departments USING(department_id);

-- RIGHT JOIN wypisuje wszystkie rekordy z prawej tabeli oraz tylko te z lewej tabeli, które udało się dopasować.
-- Nie ma K.Grant, ale są departamenty, w których nikt nie pracuje, np. Treasury lub Payroll:
SELECT * FROM employees RIGHT JOIN departments USING(department_id);

-- FULL JOIN wypisuje wszystkie rekordy z obu tabel, dopasowując jeśli się da.
-- Jest K.Grant, są też departamenty, w których nikt nie pracuje, np. Treasury lub Payroll:
SELECT * FROM employees FULL JOIN departments USING(department_id);

-- LEFT, RIGHT oraz FULL to wszystko sa "złączenia zewnętrzne",
-- opcjonalnie można za tymi określeniami dopisać słowo OUTER, które nic nie zmienia:
SELECT * FROM employees LEFT OUTER JOIN departments USING(department_id);
SELECT * FROM employees RIGHT OUTER JOIN departments USING(department_id);
SELECT * FROM employees FULL OUTER JOIN departments USING(department_id);

-- Istnieje jeszcze CROSS JOIN, który tworzy iloczyn kartezjanski, a więc działa dokładnie tak samo, jak przecinek.
-- CROSS JOIN nie używa się w połączeniu z ON ani USING.
SELECT * FROM employees CROSS JOIN departments;

-- Ciekawostka: w MySQL nie dziala FULL JOIN, a w SQLite nie dziala FULL ani RIGHT JOIN
-- MySQL w ogóle bardzo spłyca temat JOINów w porównaniu ze standardem i Oraclem/Postgresem, np. nie rozróżnia INNER od CROSS
-- (w obu przypadkach można dopisać warunek - zadziała jak INNER, albo nie dopsywać - zadziała jak CROSS)

--! Specyfika Oracle !--
-- Wróćmy na chwilę do złączeń realizowanych za pomocą przecinka i WHERE...
-- W bazie Oracle istnieje specjalny zapis, który pozwala osiagnąć efekt taki jak LEFT/RIGHT JOIN bazując na warunkach w WHERE.
-- Jest to unikalna cecha bazy Oracle, nieprzenośna do innych.

-- Efekt analogiczny do RIGHT JOIN. Wszystkie departamenty, a dane pracowników są uzupełniane nullami w miarę potrzeby.
SELECT * FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

-- Efekt analogiczny do LEFT JOIN. Wszyscy pracownicy, a dane departamentów są uzupełniane nullami w miarę potrzeby.
SELECT * FROM employees e, departments d
WHERE e.department_id = d.department_id(+);

-- Nie da się (+) napisać po obu stronach, więc nie zastąpimy tym FULL JOIN-a

-- Wszystkie złączenia zewnętrzne dałoby się zastąpić odpowiednim użyciem operatora zbiorów UNION ALL - po prostu byłoby więcej pisania.

--* Koniec tematu JOIN *--
