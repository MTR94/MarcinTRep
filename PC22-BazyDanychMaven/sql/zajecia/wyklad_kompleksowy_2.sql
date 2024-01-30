
--* Funkcje agregujące *--

SELECT * FROM employees;

-- W SQL istnieją funkcje "zwykłe" oraz "agregujące".
-- Zwykła funkcja dla każdego rekordu wejściowego zwraca osobny wynik:
SELECT round(salary) FROM employees;
SELECT sqrt(salary) FROM employees;

-- Funkcja agregująca zbiera ("kompresuje") wiele rekordów wejściowych i zwraca jeden łączny wynik:
SELECT avg(salary) FROM employees;

-- O tym, że z wielu rekordów robi się jeden wynik, decyduje sam fakt, że użyliśmy funkcji, która jest "agregująca".
-- Nie widać tego w żaden sposób w strukturze zapytania: porównajmy zapisy z sqrt i avg - są identyczne.

-- Istnieje 5 klasycznych ("kanonicznych") funkcji agregujacych SQL:
SELECT count(salary), sum(salary), avg(salary), min(salary), max(salary)
FROM employees;

-- count można używać na kilka sposobów:
-- count(*) - ilość rekordów, które są agregowane
-- count(kolumna) , ogólnie count(wyrażenie) - ilość nie-NULL-owych wartości danej kolumny/wyrażenia
-- count(DISTINCT wartość) - ilość różnych nie-NULL-owych wartości
SELECT count(*), count(department_id), count(DISTINCT department_id)
FROM employees;

-- Brakującym rekordem jest Kimberely Grant, której department_id jest równy NULL
SELECT * FROM employees WHERE department_id IS NULL;

-- Dodatkowe funkcje agregujące dostęþne w PostgreSQL
-- https://www.postgresql.org/docs/14/functions-aggregate.html
-- Kilka przykładów
SELECT avg(salary), stddev(salary), variance(salary) FROM employees;

SELECT every(length(street_address) > length(city)) FROM locations;

SELECT * FROM locations WHERE length(street_address) <= length(city);

SELECT string_agg(city, '; ') FROM locations;

SELECT json_agg(city) FROM locations;

-- Łącząc funkcje agregujace z warunkiem WHERE możemy obliczyć statystyki tylko dla wybranych rekordów.
-- Ilu jest programistów i jaka jest ich średnia pensja?
SELECT count(*) AS ilu, avg(salary) AS srednia
FROM employees
WHERE job_id = 'IT_PROG';

-- Zauważmy, że gdy stosujemy funkcje agregujące, nie możemy już odwoływać się do wartości pojedynczych rekordów.
-- SELECT count(*) AS ilu, avg(salary) AS srednia, job_id
-- FROM employees
-- WHERE job_id = 'IT_PROG';

-- Np. takie zapytanie jest niepoprawne w SQL
-- i nie działa w PostgreSQL, Oracle, ale działa w SQLite
-- SELECT min(salary), first_name, last_name FROM employees;

--* Klauzule GROUP BY i HAVING *--

-- Powyżej za pomocą WHERE obliczyliśmy ilość i średnią dla rekordów należących do jednej grupy;
-- wszystkich, których pole job_id miało wartość 'IT_PROG'.
-- A gdybyśmy chcieli w jednym zapytaniu obliczyć takie dane dla wszystkich możliwych grup (różnych wartości job_id)?

-- Gdy chcemy obliczyć funkcje agregujące dzieląc dane na kategorie (grupy), to stosujemy właśnie klauzulę GROUP BY.

-- Porównajmy...
-- Wszystkie pensje osobno - 107 wyników
SELECT salary FROM employees;

-- Jedna liczba - średnia wszystkich - 1 wynik
SELECT avg(salary) FROM employees;

-- Dla każdej grupy osobno liczona średnia - 19 wyników, bo istnieje 19 różnych wartości job_id
SELECT avg(salary) FROM employees GROUP BY job_id;

-- W praktyce wypisujemy także kolumnę, ze względu na którą grupowaliśmy, aby wyniki były czytelne:
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia
FROM employees
GROUP BY job_id;

-- W PostgreSQL, inaczej niż w Oracle, a podobnie jak np. w MySQl, w GROUP BY można użyć aliasu kolumny
SELECT substring(last_name, 1, 1) AS litera, count(*) AS ilosc
FROM employees
GROUP BY litera
ORDER BY litera;

-- W Oraclu trzeba tak:
SELECT substring(last_name, 1, 1) AS litera, count(*) AS ilosc
FROM employees
GROUP BY substring(last_name, 1, 1)
ORDER BY litera;

-- Jeśli chcemy przefiltrować całe grupy, to warunek ich dotyczący wpisujemy w klauzulę HAVING.
-- Przykład: wypisz stanowiska, na których pracuje co najmniej 10 osób:
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia
FROM employees
GROUP BY job_id
HAVING count(*) >= 10;

-- WHERE - warunki dot. pojedynczych rekordów stosowane przed grupowaniem
-- HAVING - warunki dotyczące całych rekordów, po grupowaniu

-- Bierzemy pracowników, którzy zarabiają < 6 tys, grupujemy wg stanowisk
-- i następnie wyliczamy średnią tylko dla tych pracowników.
-- Zauważmy, że:
-- 1) wypisuje się stanowisko ST_MAN, bo jeden z ST_MANów zarabia < 6 tys.
-- 2) dla stanowiska IT_PROG średnia wynosi 4600, bo uwzględniamy tylko tych 3 programistów, którzy zarabiają < 6tys.
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia, min(salary) AS min, max(salary) AS max
FROM employees
WHERE salary < 6000
GROUP BY job_id;

-- Wszystkich pracowników grupujemy wg stanowisk i wyliczamy średnią dla całych grup.
-- A następnie wyświetlamy tylko te grupy (te stanowiska), na których średnia pensja > 6 tys.
-- Zauważmy, ze:
-- 1) NIE wypisuje się stanowisko ST_MAN, bo średnia ST_MANów wynosi 7280 i nie przechodzi przez HAVING
-- 2) dla stanowiska IT_PROG średnia wynosi 5760, bo to średnia wszystkich programistów
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia, min(salary) AS min, max(salary) AS max
FROM employees
GROUP BY job_id
HAVING avg(salary) < 6000;

-- Wypisz te stanowiska, na których co najmniej 5 osób zarabia co najmniej 5 tys.
-- Zauważmy, ze nie ma tu programistów, bo tylko 3 zarabia >= 5tys.
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia, min(salary) AS min, max(salary) AS max
FROM employees
WHERE salary >= 5000
GROUP BY job_id
HAVING count(*) >= 5;

-- Przy okazji: Zamiast HAVING można też umieści zapytanie z GROUP BY jako podzapytanie
-- w zewnętrznym zapytaniu, a w tym zewnętrznym użyć WHERE.
SELECT * FROM (
	SELECT job_id, count(*) AS ilu, avg(salary) AS srednia, min(salary) AS min, max(salary) AS max
	FROM employees
	GROUP BY job_id) podzapytanie
WHERE srednia < 6000;


-- Jeśli stosujemy grupowanie, to w klauzulach SELECT oraz HAVING nie możemy odwoływać się bezpośrednio do tych kolumn,
-- które nie są wymienione w GROUP BY.
-- Dla pozostałych musimy użyć funkcje agregującej.

-- O ile takie zapytanie nie ma żadnego sensu:
-- źle
SELECT first_name, last_name, job_id, avg(salary)
FROM employees
GROUP BY job_id;

-- To takie zapytania (z użyciem min i max) mają sens i zadziałają np. w SQLite,
-- ale PostgreSQL (jak i Oracle) dla zasady zabrania odczytywania pojedynczych wartości, jeśli stosujemy grupowanie i agregacje.
-- źle
SELECT first_name, last_name, job_id, min(salary)
FROM employees
GROUP BY job_id;

SELECT first_name, last_name, job_id, max(salary)
FROM employees
GROUP BY job_id;

-- Dalsze rozważania: po czym grupować?
-- Grupowanie po danych tekstowych, które w tabeli nie są zindeksowane jest mało wydajne.
SELECT department_name, count(employee_id) AS ilu, round(avg(salary),2) AS srednia
FROM employees FULL JOIN departments USING(department_id)
GROUP BY department_name;


-- Bardziej wydajne będzie grupowanie po ID, które mamy zindeksowane
-- tutaj można dopisać grupowanie po department_id, skoro department_name wynika bezpośrednio z department_id
-- ale nie zawsze można pogrupować po samym id
-- SELECT department_name, count(employee_id) AS ilu, round(avg(salary),2) AS srednia
-- FROM employees FULL JOIN departments USING(department_id)
-- GROUP BY department_id;

-- grupowanie po id będzie pierwszym krokiem, a dla formalności musimy dopisać grupowanie po name
SELECT department_name, count(employee_id) AS ilu, round(avg(salary),2) AS srednia
FROM employees FULL JOIN departments USING(department_id)
GROUP BY department_id, department_name;

-- czy można pogrupować po samym ID, jeśli z niego wynika inna wartość (np. name)?
-- W Oraclu po prostu nie można
-- w Postgresie w zależności od struktury zapytania czasami można pogrupować po samym id:
SELECT department_name, count(employee_id) AS ilu, round(avg(salary),2) AS srednia
FROM departments LEFT JOIN employees USING(department_id)
GROUP BY department_id;
-- Działa dla INNER JOIN oraz LEFT JOIN gdy tabela jest po lewej, dla RIGHT JOIN gdy tabela po prawej, nie działa dla FULL JOIN

---- Dodatkowe możliwości GROUP BY ----
-- (temat zaawansowany; jesli wydaje się trudny, to przeskocz i przejdź do JOINów)

-- wprowadzenie: można grupować wg kilku kryteriów, ale wtedy podsumowania są robione dla wszystkich kombinacji wartości
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY 1, 2;

-- W Oracle istnieją specjalne dodatki do GROUP BY do tworzenia częściowych podsumowań
-- W PostgreSQL też ;-)
-- Najczęściej używa się ROLLUP. Pozostałe: CUBE i GROUPING_SETS
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1, 2;

-- Jeśli grupujemy po jednym kryterium, to ROLLUP i CUBE dopisują jeden wiersz podsumowujący wszystkie dane (tak jakbyśmy policzyli funkcje agregujące bez wcześniejszego grupowania).
-- W miejsce kolumn, po których grupowaliśmy, w wierszu podsumowania wstawiany jest NULL, a funkcja grouping(kolumna) zwraca 1.
SELECT job_id, count(*), avg(salary), grouping(job_id)
FROM employees
GROUP BY ROLLUP(job_id)
ORDER BY 1;

SELECT department_id
	, grouping(department_id) AS grouping_department_id
	, job_id
	, grouping(job_id) AS grouping_job_id
	, count(*)
	, avg(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1;

SELECT CASE grouping(job_id)
  WHEN 1 THEN 'Podsumowanie:'
  ELSE job_id
  END AS "Stanowisko", count(*) AS "Ilość", round(avg(salary), 2) AS "Średnia"
FROM employees
GROUP BY ROLLUP(job_id);

-- Przy okazji: to jest przykład, gdzie trzeba użyć to_char, aby z liczby zrobić tekst,
-- bo inaczej typy nie beda sie zgadzac, nie może być czasami tekstu, czasami liczby w jednej kolumnie wynikowej.
SELECT CASE grouping(department_id)
  WHEN 1 THEN 'Podsumowanie:'
  ELSE department_id::text  -- w Oracle to_char(department_id)
  END AS "Nr dep.", count(*) AS "Ilość", round(avg(salary), 2) AS "Średnia"
FROM employees
GROUP BY ROLLUP(department_id);

-- Jeśli grupujemy po kilku kryteriach, to ROLLUP tworzy podsumowania na kolejnych poziomach, ale tylko w jednym wymiarze
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

SELECT department_name, job_id, count(*), avg(salary), GROUPING(department_name), GROUPING(job_id)
FROM employees LEFT JOIN departments USING(department_id)
GROUP BY ROLLUP(department_name, job_id)
ORDER BY 1, 2;

-- CUBE dodaje podsumowania dla wszystkich wymiarów / kombinacji
-- W tym konkretnym przypadku CUBE (w stosunku do ROLLUP) dodaje wiersze, w których grupujemy wg job_id nie zwracając uwagi na depratment_id
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY CUBE(department_id, job_id);

SELECT department_id, job_id, count(*), avg(salary), GROUPING(department_id), GROUPING(job_id)
FROM employees
GROUP BY CUBE(department_id, job_id);

-- w GROUPING SETS sami określamy, które podsumowania nas interesują

-- Grupujemy wg dep i job (standard), a dodatkowo wiersz podsumowujący wszystko)
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY GROUPING SETS((department_id, job_id), ());

-- ROLLUP jest rownowazny takiemu GROUPING SETS:
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY GROUPING SETS((department_id, job_id), (department_id), ());

-- CUBE jest rownowazny takiemu GROUPING SETS:
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY GROUPING SETS((department_id, job_id), (department_id), (job_id), ());


-- Grupujemy wg dep i job (standard), a dodatkowo podsumowania wg dep; NIE MA TUTAJ podsumowania wszystkiego)
SELECT department_id, job_id, count(*), avg(salary)
FROM employees
GROUP BY GROUPING SETS((department_id, job_id), (department_id));



---- Analiza przedzialowa - PARTITION BY ----

-- przypomnienie podzial pracownikow wg job_id i wyliczenie sredniej pensji:
SELECT job_id, count(*) AS ilu, avg(salary) AS srednia
FROM employees
GROUP BY job_id;

-- Aby wyswietlic pracownika w kontekscie jego grupy, np. obok pracownika wyswietlic srednia pensje jego grupy,
-- Mozna uzyc podzapytan
SELECT first_name, last_name, salary, job_id, ilu, srednia
FROM employees
    JOIN (SELECT job_id, count(*) AS ilu, avg(salary) AS srednia
          FROM employees
          GROUP BY job_id) grupy USING(job_id)
ORDER BY job_id, employee_id;

-- PARTITION BY jest konstrukcja bezposrednio adresowana do rozwiazywania tego typu problemow
SELECT first_name, last_name, salary, job_id,
  count(*) OVER (PARTITION BY job_id) as ilu,
  avg(salary) OVER (PARTITION BY job_id) as srednia
FROM employees
ORDER BY job_id, employee_id;

-- Przykład zastosowania: o ile pracownik zarabia więcej lub mniej od średniej na jego stanowisku
SELECT first_name, last_name, salary, job_id,
	round(salary - avg(salary) OVER (PARTITION BY job_id)) AS roznica
FROM employees
ORDER BY job_id, salary DESC;

-- Tutaj zaczniemy uzywac "funkcji okienkowych"
-- row_number podaje numer wiersza w jego grupie. Numeracja liniowa po kolei.
SELECT first_name, last_name, salary, job_id,
	row_number() OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees
ORDER BY job_id;

-- Aby użyć tego typu funkcji globalnie dla całej tabeli, trzeba napisać OVER()
-- Przykład: ponumeruj wyniki unikalnymi kolejnymi numerami:
SELECT first_name, last_name, salary, job_id, row_number() OVER () AS nr
FROM employees;

-- rank zwraca jednakowy numer dla rekordow, ktore maja jednakowe wartosci wg sortowania
-- To dziala jak okreslanie miejsca sportowca w zawodach. Np. dwie osoby dostaja srebrny medal, bo mialy jednakowy wynik
-- I wtedy brazowego medalu sie nie przyznaje...
SELECT first_name, last_name, salary, job_id,
	rank() OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

-- A dla całej tabeli? Musimy podać kolejność, ale nie robimy podziału
SELECT first_name, last_name, salary, job_id,
	rank() OVER (ORDER BY salary DESC)
FROM employees;


-- dense_rank - Tutaj podobnie rekordy z ta sama wartoscia uzyskaja ten sam numer
-- ale nastepni w kolejnosci dostana nastepny numer, bez zadnych przerw.
-- Tutaj nawet gdyby byly dwa srebrne medale, to bedzie tez przyznany brazowy
SELECT first_name, last_name, salary, job_id,
	dense_rank() OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

SELECT first_name, last_name, salary, job_id,
	dense_rank() OVER (ORDER BY salary DESC)
FROM employees;


-- ntile(N) podaje info, w ktorej czesci znalazlby sie wynik, gdybysmy posortowane wyniki podzielili na N rownych czesci
-- Jesli uzyjemy tego z polaczeniu z PARTITION BY, to kazda grupe dzieli na N czesci i infromuje w ktorej czesci znajduje sie konkretny rekord

-- Tutaj dowiemy sie czy pracownik nalezy do bogatszej polowy (1) na swoim stanowiksu, czy do biednejszej polowy (2)
-- Przy czym to dziala "technicznie" i w przypadku rownych pensji (zob. AD_VP) pracownicy o tej samej pensji moga trafic do roznych grup, bo akurat tu przebiega granica
SELECT first_name, last_name, salary, job_id,
	ntile(2) OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

-- Tutaj dzielimy pracownikow na 10 czesci wg pensji.
SELECT first_name, last_name, salary,
	ntile(10) OVER (ORDER BY salary DESC)
FROM employees;

SELECT first_name, last_name, salary,
ntile(10) OVER (ORDER BY salary DESC)
FROM employees
ORDER BY last_name, first_name;


-- odwolanie do wartosci, ktora wystapila wczesniej, (do "sasiada")
SELECT first_name, last_name, salary, job_id,
	lag(salary, 1) OVER (PARTITION BY job_id ORDER BY salary DESC) AS poprzedni
FROM employees;

SELECT first_name, last_name, salary, job_id,
	lag(salary, 1) OVER (ORDER BY salary DESC) AS poprzedni
FROM employees;

-- Przykladowo: o ile pensja pracownika jest mniejsza od poprzedniego na tym samym stanowisku:
SELECT first_name, last_name, salary, job_id,
    lag(salary, 1) OVER (PARTITION BY job_id ORDER BY salary DESC) - salary AS roznica
FROM employees;

-- albo nie do sasiada tylko do rekordu ktory wystapil x pozycji temu
-- Tutaj już bez podziału na stanowiska
SELECT first_name, last_name, salary, job_id,
	lag(salary, 2) OVER (ORDER BY salary DESC)
FROM employees;

-- zagladanie do rekordow nastepnych
SELECT first_name, last_name, salary, job_id,
	lead(salary, 1) OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

-- przyklad bez partition by, samo zastosowanie f.okienkowej
-- o ile mniej zarabiam od poprzedniego pracownika na liscie
SELECT first_name, last_name, salary,
	abs(salary - lag(salary, 1) OVER (ORDER BY salary DESC)) AS roznica
FROM employees;

-- Odwołanie do pierwszego rekordu danej grupy
SELECT first_name, last_name, salary, job_id,
	first_value(salary) OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

-- Dla pracownika info kto na jego stanowisku zarabia najwięcej
SELECT first_name, last_name, salary, job_id,
	first_value(first_name || ' ' || last_name)
		OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees;

SELECT first_name, last_name, salary, job_id, hire_date,
	lag(first_name || ' ' || last_name, 1)
		OVER (PARTITION BY job_id ORDER BY salary DESC)
FROM employees
ORDER BY hire_date;


-- Dla każdego pracownika podaj info ile dni minęło od zatrudnienia poprzedniej osoby do zatrudnienia bieżącej osoby.
SELECT first_name, last_name, hire_date,
	hire_date - lag(hire_date, 1) OVER (ORDER BY hire_date) AS roznica_czasu
FROM employees;



--* Operacje teoriomnogościowe, czyli na zbiorach *--
-- UNION ALL, UNION, INTERSECT, EXCEPT

SELECT first_name, last_name FROM employees
UNION ALL
SELECT city, state_province FROM locations;


SELECT city FROM locations; -- 23 rekordy
SELECT country_name FROM countries; -- 25 rekordów
-- Obserwacja: Singapore jest jednoczesnie nazwa miasta i panstwa

-- Mając zapytania, których wyniki są zapisane w tej samej liczbie kolumn o zgodnych typach,
-- możemy te wyniki połączyć za pomocą jednego z operatorów zbiorów:

--# UNION ALL - suma zbiorów z zachowanien ewentualnych duplikatów i kolejności
-- Technicznie, to jest po prostu doklejenie następnych wyników na końcu.
-- To jest tanie (wydajne).
-- Tutaj Singapore występuje dwukrotnie.
SELECT city FROM locations
UNION ALL
SELECT country_name FROM countries;


--# UNION - prawdziwa matematyczna suma zbiorów, z usunięciem powtórzeń.
-- Baza danych ma prawo zmienić kolejność rekordów.
-- W praktyce Oracle sortuje wyniki, ale już PostgreSQL nie!
-- To jest operacyjnie "droższe" niż UNION ALL (może trwać dłużej, może zużyć pamięć)
-- Tutaj Singapore wystąpi tylko raz.
SELECT city FROM locations
UNION
SELECT country_name FROM countries;

--# INTERSECT - przecięcie, część wspólna zbiorów.
-- Tutaj jedynym wynikiem jest Singapore.
SELECT city FROM locations
INTERSECT
SELECT country_name FROM countries;

--# EXPECT - różnica zbiorów.
-- Uwaga: w Oracle nazywa się to (niezgodnie ze standardem) MINUS.
-- Tutaj wynikiem są wszystkie miasta bez Singapuru, bo Singapur występuje też jako nazwa kraju
SELECT city FROM locations
EXCEPT
SELECT country_name FROM countries;

-- Odwrotnie: wszystkie państwa bez Singapuru.
SELECT country_name FROM countries
EXCEPT
SELECT city FROM locations;

-- Gdy używa się operatorów zbiorów, to:
-- * liczba oraz typy kolumn muszą się zgadzać 
--   (na podstawowym poziomie, czyli np. VARCHAR(50) i TEXT będą OK, ale TEXT i NUMERIC już nie)
-- * nazwy kolumn są ustalane w pierwszym SELECT
-- * kolejne SELECTY mogą składać się z klauzul FROM, WHERE, GROUP BY, HAVING
-- * natomiast ORDER BY może wystąpic tylko na samym końcu i posortuje wszystkie części łącznie.

-- Najpierw zobaczymy bogatych, potem biednych, ale żadna z tych części nie będzie w żaden specjalny sposob sortowana
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 10000
UNION ALL
SELECT first_name, last_name, salary
FROM employees
WHERE salary < 5000;

-- Nie wolno wpisać ORDER BY w tym miejscu:
/* SELECT first_name, last_name, salary
FROM employees
WHERE salary > 10000
ORDER BY last_name
UNION ALL
SELECT first_name, last_name, salary
FROM employees
WHERE salary < 5000; */

-- Natomiast ORDER BY na końcu sortuje całe wyniki łącznie.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 10000
UNION ALL
SELECT first_name, last_name, salary
FROM employees
WHERE salary < 5000
ORDER BY last_name;

-- A jak zachować informację z której części zapytania pochodzi dany rekord?
SELECT first_name, last_name, salary, 'bogaty' AS status_majatkowy
FROM employees
WHERE salary > 10000
UNION ALL
SELECT first_name, last_name, salary, 'biedny'
FROM employees
WHERE salary < 5000
ORDER BY status_majatkowy DESC, last_name, first_name;

-- Jeśli liczy się tylko kolejność, to można po prostu ponumerować:
SELECT first_name, last_name, salary, 1
FROM employees
WHERE salary > 10000
UNION ALL
SELECT first_name, last_name, salary, 2
FROM employees
WHERE salary < 5000
ORDER BY 4, 2, 1;

-- Jeśli umieścimy to wszystko w podzapytaniu, można ukryć kolumny pełniące rolę pomocniczą
SELECT first_name || ' ' || last_name AS kto, salary
FROM (SELECT first_name, last_name, salary, 1
      FROM employees
      WHERE salary > 10000
    UNION ALL
      SELECT first_name, last_name, salary, 2
      FROM employees
      WHERE salary < 5000
    ORDER BY 4, 2, 1) sub;

-- Gdybyśmy chcieli stworzyć "raport" podzielony na dwie częsci z listą bogatych i biednych...
-- Wersja PostgreSQL:
SELECT kto, salary
FROM (
      SELECT 'Bogaci:' AS kto, NULL::numeric AS salary, 1 AS kolejnosc
    UNION ALL
      SELECT '--> ' || first_name || ' ' || last_name, salary, 2
        FROM employees
        WHERE salary > 10000
    UNION ALL
      SELECT 'Biedni:', NULL::numeric, 3
    UNION ALL
      SELECT '--> ' || first_name || ' ' || last_name, salary, 4
        FROM employees
        WHERE salary < 5000
    ORDER BY 3, 1) sub;
    
    
-- Wersja Oracle:
SELECT kto, salary
FROM (
      SELECT 'Bogaci:' AS kto, to_number(NULL) AS salary, 1 AS kolejnosc FROM dual
    UNION ALL
      SELECT '  ' || first_name || ' ' || last_name, salary, 2
        FROM employees
        WHERE salary > 10000
    UNION ALL
      SELECT 'Biedni:', to_number(NULL), 3 FROM dual
    UNION ALL
      SELECT '  ' || first_name || ' ' || last_name, salary, 4
        FROM employees
        WHERE salary < 5000
    ORDER BY 3, 1);    

-- Przykład
-- Za pomocą UNION ALL spróbujmy wypisać informacje o przebiegu zatrudnienia
-- historyczne oraz bieżące

SELECT * FROM job_history;

SELECT employee_id, e.first_name, e.last_name,
    jh.start_date, jh.end_date,
    j.job_title, d.department_name, 1 AS kolejnosc
FROM job_history jh
    JOIN employees e USING(employee_id)
    JOIN jobs j ON j.job_id = jh.job_id
    JOIN departments d ON d.department_id = jh.department_id
UNION ALL
SELECT employee_id, e.first_name, e.last_name,
    e.hire_date, NULL,
    j.job_title, d.department_name, 2
FROM employees e
    JOIN jobs j ON j.job_id = e.job_id
    JOIN departments d ON d.department_id = e.department_id
ORDER BY employee_id, kolejnosc, start_date;


--* CASE *--
-- Tak jak w programowaniu IF albo SWITCH....

-- W PostgreSQL (tak samo w MySQL, SQLite) w SELECT można wpisać wyrażenie typu logicznego
SELECT first_name, last_name, salary, salary >= 10000 AS bogaty
FROM employees;
-- W Oracle tak nie można. Dlatego konstrukcja CASE jest szczególnie ważna w bazie Oracle.
-- Ale także w innych bazach, w tym PostgreSQL, może się przydać:

SELECT first_name, last_name, salary,
    CASE
      WHEN salary >= 10000 THEN 'bogaty'
      ELSE 'biedny'
    END
FROM employees;

-- Między CASE a END można wpisać dowolnie wiele gałęzi WHEN oraz 0 lub 1 galaz ELSE
-- Jako wynik zwrócona będzie wartość z pierwszej gałęzi WHEN, która jest prawdziwa. Kolejność WHEN-ów ma znaczenie.
SELECT first_name, last_name, salary,
    CASE
      WHEN salary >= 15000 THEN 'bardzo bogaty'
      WHEN salary >= 10000 THEN 'bogaty'
      WHEN salary >= 5000 THEN 'sredniak'
      ELSE 'biedny'
    END AS "Status"
FROM employees;

-- w przypadku braku poprawnego WHEN, zwracana jest wartość z ELSE.
-- Gdy nie ma ELSE, to w takim przypadku wynikiem jest NULL.
SELECT first_name, last_name, salary,
    CASE
      WHEN salary >= 15000 THEN 'bardzo bogaty'
      WHEN salary >= 10000 THEN 'bogaty'
      WHEN salary >= 5000 THEN 'średniak'
    END AS "Status"
FROM employees;

SELECT first_name, last_name, commission_pct,
    CASE
      WHEN commission_pct >= 0.3 THEN 'duża prowizja'
      WHEN commission_pct >= 0.2 THEN 'średnia prowizja'
      ELSE 'mała prowizja lub brak'
    END AS "Prowizja"
FROM employees;


-- Czasami warunek w WHEN sprowadza się do sprawdzenia czy pole jest równe jednej wartości, czy innej...
-- Przykładowo, wypiszemy nazwy miesięcy na podstawie daty:
SELECT first_name, last_name, hire_date, extract(month FROM hire_date) as nr_mca,
   CASE
     WHEN extract(month FROM hire_date) = 1 THEN 'styczeń'
     WHEN extract(month FROM hire_date) = 2 THEN 'luty'
     WHEN extract(month FROM hire_date) = 3 THEN 'marzec'
     WHEN extract(month FROM hire_date) = 4 THEN 'kwiecień'
     WHEN extract(month FROM hire_date) = 5 THEN 'maj'
     WHEN extract(month FROM hire_date) = 6 THEN 'czerwiec'
     WHEN extract(month FROM hire_date) = 7 THEN 'lipiec'
     WHEN extract(month FROM hire_date) = 8 THEN 'sierpień'
     WHEN extract(month FROM hire_date) = 9 THEN 'wrzesień'
     WHEN extract(month FROM hire_date) = 10 THEN 'październik'
     WHEN extract(month FROM hire_date) = 11 THEN 'listopad'
     WHEN extract(month FROM hire_date) = 12 THEN 'grudzień'
   END AS miesiac
FROM employees;

-- W takiej sytuacji możemy zastosować inny zapis CASE, gdzie w WHEN nie podaje się warunków logicznych,
-- tylko wartości (to przypomina switch/case z programowania)
SELECT first_name, last_name, hire_date, extract(month FROM hire_date) as nr_mca,
   CASE extract(month FROM hire_date)
     WHEN 1 THEN 'styczeń'
     WHEN 2 THEN 'luty'
     WHEN 3 THEN 'marzec'
     WHEN 4 THEN 'kwiecień'
     WHEN 5 THEN 'maj'
     WHEN 6 THEN 'czerwiec'
     WHEN 7 THEN 'lipiec'
     WHEN 8 THEN 'sierpień'
     WHEN 9 THEN 'wrzesień'
     WHEN 10 THEN 'październik'
     WHEN 11 THEN 'listopad'
     WHEN 12 THEN 'grudzień'
   END AS miesiac
FROM employees;

--! Specyfika Oracle !--
-- W Oracle czasasami da sie zastapic CASE krótszym zapisem DECODE.
-- Ale to będzie mniej przenośne (nie działa np. w PostgreSQL).

SELECT first_name, last_name, decode(last_name, 'King', 'król', 'Gietz', 'to mój kolega', 'nie znam tego gościa') AS txt
FROM employees
ORDER BY employee_id;

SELECT first_name, last_name, hire_date,
   decode(extract(month FROM hire_date),
      1  , 'styczeń'    ,
      2  , 'luty'       ,
      3  , 'marzec'     ,
      4  , 'kwiecień'   ,
      5  , 'maj'        ,
      6  , 'czerwiec'   ,
      7  , 'lipiec'     ,
      8  , 'sierpień'   ,
      9  , 'wrzesień'   ,
      10 , 'październik',
      11 , 'listopad'   ,
      12 , 'grudzień'   ) AS miesiac
FROM employees;



------------  zapytania zagnieżdżone  =  podzapytania ----------

-- Zapytanie (caly SELECT) moze byc wziety w nawiasy () i potraktowany jak wyrazenie, które zwraca wynik
-- i ktorego mozna uzyc jako czesci wiekszego zapytania.
-- Te zagniezdzone SELECT-y moga byc uzywane w roznych miejscach glownego zapytania.
-- Moga zwracac w wyniku:
--  * pojedyncza wartosc (podzapytania skalarne)
--  * tabele
--  * szczegolnym przypadkiem tabeli moze byc tabela jednolinijkowa albo jednokolumnowa...

-- Podzapytania moga byc jeszcze skorelowane  z zapytaniem glownym (odwouja sie do danych z zewn. zapytania),
-- albo nieskorelowane (sa samodzielne i moglyby byc wykonane niezaleznie od zapytania zewn.).

-- Obok pracownika wypisz srednia pensje w całej firmie i oblicz różnicę między pensją pracownika a średnią firmy
SELECT first_name, last_name, salary,
	(SELECT 2+2) AS cztery,
	(SELECT avg(salary) FROM employees) AS srednia,
	round(salary - (SELECT avg(salary) FROM employees)) AS roznica
FROM employees;
-- Powyższe zapytania są "nieskorelowane", czyli mogą być wyliczone raz, a nie osobno dla każdego wiersza.

-- Dla kazdego pracownika wypisz srednia pensje na jego stanowisku i w jego departamencie.
SELECT first_name, last_name, salary,
  (SELECT avg(salary) FROM employees wewn WHERE wewn.job_id = zewn.job_id) AS "średnia stanowiska",
  (SELECT avg(salary) FROM employees wewn WHERE wewn.department_id = zewn.department_id) AS "średnia departamentu"
FROM employees zewn;
-- Zapytanie jest "skorelowane", bo wewnatrz odwolujemy sie do wartosci zewn.department_id
-- ustalonej przez zapytanie zewnetrzne
-- Oracle dla poszczegolnych wartosci department_id wykonuje zapytania:
-- SELECT avg(salary) FROM employees WHERE department_id = 90;
-- SELECT avg(salary) FROM employees WHERE department_id = 100;
-- itd.

-- Czesto za pomoca podzapytan mozna robic to samo, co da sie zrobic za pomoca JOIN
SELECT first_name, last_name, salary,
   (SELECT department_name FROM departments WHERE department_id = emp.department_id) AS dep_name
FROM employees emp;

SELECT first_name, last_name, salary, department_name
FROM employees emp LEFT JOIN departments dep ON dep.department_id = emp.department_id;

-- Przy okazji: Aby zobaczyć info nt kosztu zapytania, można użyć polecenie explain, w SQL Developerze robi się to klawiszem F10


-- Na tej samej zasadzie jak w SELECT, zadzialalyby zapytania skalarne w WHERE czy nawet ORDER BY.
-- Prosty przyklad: wypisz pracownikow, ktorzy zarabiaja ponizej sredniej w firmie
SELECT first_name, last_name, salary
FROM employees
WHERE salary < (SELECT avg(salary) FROM employees)
ORDER BY employee_id;
-- To jest zapytanie skalarne (bo zwraca jeden wynik)
-- NIESKORELOWANE (bo podzapytanie nie odwoluje sie do danych z zapytania glownego) i moze byc wykonane niezaleznie, tylko jeden raz

-- To teraz znajdzmy pracownikow zarabiajacych ponizej sredniej na ICH stanowisku
-- To juz bedzie SKORELOWANE
SELECT first_name, last_name, job_id, salary
FROM employees zewn
WHERE salary <= (SELECT avg(salary) FROM employees WHERE job_id = zewn.job_id)
ORDER BY employee_id;

-- Podzapytania tabelaryczne ("wielowierszowe") we FROM
-- Zapytanie we FROM zawsze sa nieskorelowane

-- Takie zapytanie dla stanowiska wylicza ilosc pracownikow oraz srednia pensje
SELECT job_id, job_title, count(employee_id) AS ilu, avg(salary) AS srednia
FROM jobs JOIN employees USING(job_id)
GROUP BY job_id, job_title;


-- Cos prostego
-- We FROM glownego zapytania zamiast zwyklej tabeli umieszczamy podzapytanie, ktore produkuje tabele.
SELECT job_title, ilu, round(srednia, 1)
FROM (SELECT job_id, job_title, count(employee_id) AS ilu, avg(salary) AS srednia
     FROM jobs JOIN employees USING(job_id)
     GROUP BY job_id, job_title) podzapytanie
WHERE ilu >= 10
ORDER BY job_title;

-- Najczesciej tabele uzyskane za pomoca podzapytac laczy sie z innym i w zapytaniu glowym.

-- Moge uzyc wynikow tego zapytania jako zrodla dla nastepnego zapytania,
-- ktore np. obok pracownika wypisze dane jego stanowiska
-- v1: jako podzapytanie we FROM
SELECT e.first_name, e.last_name, e.salary, job_info.job_title, job_info.ilu, job_info.srednia
FROM employees e JOIN
    (SELECT job_id, job_title, count(employee_id) AS ilu, avg(salary) AS srednia
     FROM jobs JOIN employees USING(job_id)
     GROUP BY job_id, job_title) job_info USING(job_id)
ORDER BY e.employee_id;

-- v2: za pomoca WITH
WITH job_info AS (
     SELECT job_id, job_title, count(employee_id) AS ilość, avg(salary) AS srednia
     FROM jobs JOIN employees USING(job_id)
     GROUP BY job_id, job_title
)
SELECT e.first_name, e.last_name, e.salary, job_info.job_title, job_info.ilość, job_info.srednia
FROM employees e JOIN job_info USING(job_id)
ORDER BY e.employee_id;

-- Alternatywnie można by użyć podzapytań skalarnych w SELECT - ale to będzie gorsze podejście... i wydaje się najmniej wydajne
SELECT e.first_name, e.last_name, e.salary
   , (SELECT job_title FROM jobs WHERE job_id = e.job_id) AS job_title
   , (SELECT count(employee_id) FROM employees WHERE job_id = e.job_id) AS ilość
   , (SELECT avg(salary) FROM employees WHERE job_id = e.job_id) AS średnia
FROM employees e
ORDER BY e.employee_id;

-- Alternatywnie można też użyć zwykego JOIN i odpowiednio grupowac, ale to tez wyjdzie brzydko
SELECT e1.first_name, e1.last_name, e1.salary, j.job_id, j.job_title,
   count(e2.employee_id) AS ilu, avg(e2.salary) AS srednia
FROM employees e1
    JOIN jobs j ON j.job_id = e1.job_id
    JOIN employees e2 ON e2.job_id = j.job_id
GROUP BY j.job_id, j.job_title, e1.employee_id, e1.first_name, e1.last_name, e1.salary;


-- Przykład z dwoma podzapytaniami - pacownik, jego stawisko i jego departament
-- Wersja zagnieżdżona
SELECT e.first_name, e.last_name, e.salary
	,job_info.job_title
	,job_info.ilu AS job_ilosc
	,round(job_info.srednia, 1) AS job_srednia
	,dep_info.department_name
	,dep_info.ilu AS dep_ilosc
	,round(dep_info.srednia, 1) AS dep_srednia
FROM employees e
    LEFT JOIN (
		   SELECT job_id, job_title, count(employee_id) AS ilu, avg(salary) AS srednia
           FROM jobs JOIN employees USING(job_id)
           GROUP BY job_id
	   ) job_info USING(job_id)
    LEFT JOIN (
		   SELECT department_id, department_name, count(employee_id) AS ilu, avg(salary) AS srednia, city
           FROM departments
		       LEFT JOIN employees USING(department_id)
			   LEFT JOIN locations USING(location_id)
           GROUP BY department_id, city
	   ) dep_info USING(department_id)
ORDER BY e.employee_id;

-- wersja z WITH
WITH job_info AS
	(SELECT job_id, job_title, count(employee_id) AS ilu, avg(salary) AS srednia
    FROM jobs JOIN employees USING(job_id)
    GROUP BY job_id),
dep_info AS
	(SELECT department_id, department_name, count(employee_id) AS ilu, avg(salary) AS srednia, city
    FROM departments
		LEFT JOIN employees USING(department_id)
		LEFT JOIN locations USING(location_id)
	GROUP BY department_id, city)
SELECT e.first_name, e.last_name, e.salary
	,job_info.job_title
	,job_info.ilu AS job_ilosc
	,round(job_info.srednia, 1) AS job_srednia
	,dep_info.department_name
	,dep_info.ilu AS dep_ilosc
	,round(dep_info.srednia, 1) AS dep_srednia
FROM employees e
    LEFT JOIN job_info USING(job_id)
    LEFT JOIN dep_info USING(department_id)
ORDER BY e.employee_id;

-- Podzapytania w WHERE
-- podobnie jak w SELECT podzapytania mogą być skorelowane lub nieskorelowane
-- podzapytania mogą zwracać pojedynczą wartość (skalarne)
-- Ale dodatkowo sens mają podzapytania, które zwracają wynik jako kolumnę z wartościami ("lista wartości")
-- - można ich użyć w połączeniu z operatorami logicznymi IN, ALL, ANY, EXISTS

-- Przykłady
-- podzapytanie skalarne, nieskorelowane
-- Wypisz pracowników, których pensja jest wyższa od średniej
SELECT first_name, last_name, job_id, salary
FROM employees
WHERE salary > (SELECT avg(salary) FROM employees);

-- podzapytanie skalarne, skorelowane
-- Wypisz tych, którzy mają średnią pensję wyższą niż średnia na ich stanowisku
SELECT first_name, last_name, job_id, salary
FROM employees zewn
WHERE salary > (SELECT avg(salary)
                FROM employees wewn
                WHERE wewn.job_id = zewn.job_id)
ORDER BY employee_id;

-- Dodatkowy przykład nt przedziałów czasowych
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN 
	(SELECT min(start_date) FROM job_history) 
	AND (SELECT max(start_date) FROM job_history);

-- Przykład podzapytania z IN
-- To samo da się zrobić inaczej, ale po prostu prezentuję działanie IN
-- Wypisz te depratamenty, w których ktoś pracuje

SELECT department_id, department_name
FROM departments
WHERE department_id IN (SELECT DISTINCT department_id FROM employees);

-- Można także porównywać całe krotki
-- Przykład: znajdź pracowników, w których departamencie istnieje
-- inny pracownik zarabiający tyle samo
SELECT first_name, last_name, salary, department_id
FROM employees zewn
WHERE (salary, department_id) IN
  (SELECT salary, department_id
   FROM employees wewn
   WHERE zewn.employee_id <> wewn.employee_id);


-- Wypisz departamenty, w których ktoś zarabia między 9 a 10 tys.
SELECT department_id, department_name
FROM departments dep
WHERE EXISTS (SELECT employee_id FROM employees
              WHERE department_id = dep.department_id
                 AND salary BETWEEN 9000 AND 10000);

-- Dla operatora EXISTS liczy się tylko to, czy podzapytanie zwróciło jakikolwiek wynik.
-- Dlatego obowiązuje konwencja pisania SELECT 1 w podzapytaniach używanych w ramach EXISTS
-- To może zwiększyć wydajność. A EXISTS i tak jest wydajnym rozwiazaniem, bo wyniki podzapytania nie musza byc wczytywane do konca, wystarczy ze pojawi sie pierwszy wynik.
-- Czesto EXISTS odwoluje sie tylko do indeksow, a nie musi czytac docelowej tabeli.
SELECT department_id, department_name
FROM departments dep
WHERE EXISTS (SELECT 1 FROM employees
              WHERE department_id = dep.department_id
                 AND salary BETWEEN 9000 AND 10000);

-- Dodatkowe wyjaśnienia:
-- To podzapytanie czasami zwraca jakieś rekordy -> to wtedy EXSISTS da wynik TRUE
SELECT employee_id FROM employees
WHERE department_id = 80
AND salary BETWEEN 9000 AND 10000;

SELECT 1 FROM employees
WHERE department_id = 80
AND salary BETWEEN 9000 AND 10000;

-- A czasami wynik jest pusty -> wtedy EXISTS daje wynik FALSE
SELECT employee_id FROM employees
WHERE department_id = 90
AND salary BETWEEN 9000 AND 10000;

-- To akurat da się też zapisać za pomoca IN
SELECT department_id, department_name
FROM departments dep
WHERE department_id IN (SELECT department_id FROM employees
              WHERE salary BETWEEN 9000 AND 10000);

--- ANY i ALL - tzw. kwantyfikatory

-- Wypiszmy pracowników, którzy zarabiają najwięcej na swoim stanowisku
-- Zwrocmy uwage na wiceprezesow 17000  - oboje zostana wyswietleni, bo maja jednakowe maksymalne pensje na swoim stanowisku
SELECT first_name, last_name, job_id, salary
FROM employees zewn
WHERE salary >= ALL (SELECT salary
                FROM employees wewn
                WHERE wewn.job_id = zewn.job_id)
ORDER BY employee_id;

-- Wypiszmy pracowników, którzy zarabiają więcej niż ktokolwiek na ich stanowisku
-- ANY i SOME to jest to samo
SELECT first_name, last_name, job_id, salary
FROM employees zewn
WHERE salary > ANY (SELECT salary
                FROM employees wewn
                WHERE wewn.job_id = zewn.job_id)
ORDER BY employee_id;

-- BTW te przykłady dało się zrobić inaczej, np.:
SELECT first_name, last_name, job_id, salary
FROM employees zewn
WHERE salary = (SELECT max(salary)
                FROM employees wewn
                WHERE wewn.job_id = zewn.job_id)
ORDER BY employee_id;
