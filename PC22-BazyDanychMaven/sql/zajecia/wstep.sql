-- To jest komentarz
/* To też */

select * from employees;
-- Zazwyczaj wielkość liter nie ma znaczenia w SQL (wyjaśnienie w innym pliku)
SELECT * FROM departments;
SELECT * FROM locations;

/* Ogólna postać:
SELECT kolumny
FROM tabele
WHERE warunek
GROUP BY kryteria grupowania
HAVING warunek
ORDER BY kryteria sortowania
...
*/

SELECT first_name, last_name, salary FROM employees;

-- Można też wpisać wyrażenie, które coś oblicza
SELECT 'Pracownik ' || first_name || ' ' || last_name,
   	 salary * 12
FROM employees;

-- Szczególnie wtedy przydaje się nadawanie kolumnom wynikowym własnych nazw - tzw. aliasy
-- 'apostrofy' oznaczają w SQL wartości String, a "cudzysłowy" to nazwy cytowane
SELECT 'Pracownik ' || first_name || ' ' || last_name AS Pracownik,
   	 salary * 12 AS "Roczne zarobki"
FROM employees;

SELECT * FROM jobs;

-- Wypisz nazwę stanowiska, a obok różnicę między maksymalną a minimalną pensją
SELECT job_title, max_salary - min_salary AS roznica
FROM jobs;

-- WHERE
-- Wypisz osoby zarabiające co najmniej 10 tys
SELECT * FROM employees WHERE salary >= 10000;
-- Wypisz osoby o nazwisku King
SELECT * FROM employees WHERE last_name = 'King';

SELECT * FROM employees WHERE salary < 5000 AND job_id = 'IT_PROG';

-- Aby sprawdzić, czy pole jest nullem, trzeba użyć IS NULL (nie działa porównanie)
SELECT * FROM locations WHERE state_province IS NULL;
SELECT * FROM locations WHERE state_province IS NOT NULL;

-- Natomiast zastąpienie NULLa inną wartością podczas odczytu, używajmy funkcji coalesce
SELECT city, state_province, country_id FROM locations;
SELECT city, coalesce(state_province, 'BRAK DANYCH'), country_id FROM locations;

-- Operator LIKE sprawdza, czy tekst pasuje do wzorca
-- Osoby z nazwiskami na A:
SELECT first_name, last_name, job_id, salary FROM employees
WHERE last_name LIKE 'A%';

-- nazwiska kończące się na a
SELECT first_name, last_name, job_id, salary FROM employees
WHERE last_name LIKE '%a';

-- Druga litera nazwiska to 'a'
SELECT first_name, last_name, job_id, salary FROM employees
WHERE last_name LIKE '_a%';

-- Generalnie % oznacza dowolny fragment tekstu, a _ oznacza pojedynczy dowolny znak

SELECT city FROM locations;
-- Z tabeli locations odczytaj te miasta, których przedostatnią literą jest 'm'
SELECT city FROM locations WHERE city LIKE '%m_';

-- Odczytaj te miasta, w których nazwie występują (co najmniej) dwie litery 'o'
SELECT city FROM locations WHERE city LIKE '%o%o%';

-- Gdybyśmy chcieli odczytać też 'Oxford'
SELECT city FROM locations WHERE city LIKE '%o%o%' OR city LIKE 'O%o%';

SELECT city FROM locations WHERE lower(city) LIKE '%o%o%';
-- W PostgreSQL (w innych nie) mamy też specjalną wersję ILIKE, która ignoruje wielkość liter
SELECT city FROM locations WHERE city ILIKE '%o%o%';

-- sortowanie - ORDER BY
SELECT * FROM employees
ORDER BY salary;

-- malejąco:
SELECT * FROM employees
ORDER BY salary DESC;

-- kilka kryteriów:
SELECT * FROM employees
ORDER BY last_name, first_name;

-- rosnąco wg jobów, malejąco wg pensji, rosnąco wg nazwisko i imion:
SELECT * FROM employees
ORDER BY job_id, salary DESC, last_name, first_name;

SELECT * FROM employees
ORDER BY length(first_name || last_name);

-- zamiast nazwy kolumny, w ORDER BY można wpisać numer kolumny (spośród tych, które wybieramy SELECTem)
SELECT first_name, last_name, salary, hire_date
FROM employees
ORDER BY 3 DESC, 2, 1;


-- Zapytania dot. wielu tabel

SELECT * FROM employees;
SELECT * FROM departments;

-- Dwie tabele po przecinku -> wychodzi "iloczyn kartezjański", czyli kombinacja każdego z każdym
SELECT * FROM employees, departments;
SELECT count(*) FROM employees, departments;
SELECT (SELECT count(*) FROM employees) * (SELECT count(*) FROM departments);

-- Jak dopasować rekordy?
-- Sposób 1
-- Za pomocą WHERE wybieramy tylko te kombinacje rekordów, w których id się zgadza
SELECT *
FROM employees, departments
WHERE employees.department_id = departments.department_id;

-- Sposób 2 - JOIN
SELECT *
FROM employees JOIN departments
	ON employees.department_id = departments.department_id;

-- Różnicę zauważymy łącząc więcej niż 2 tabale.
-- Przy okazji wprowadzam aliasy tabel, czyli krótsze nazwy dla tabel w obrębie zapytania
-- Sposób z WHERE: zarówno warunki złączenia, jak i warunki filtrowania, są pisane razem w jednym WHERE
SELECT *
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND salary < 10000;

-- W podejściu z JOIN warunek łączenia każdej kolejnej tabeli jest pisany w oddzielnym ON, a WHERE zajmuje się dalszym filtrowaniem
SELECT *
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE salary < 10000;

--* JOIN jest częścią klauzuli FROM *--

-- sposoby podawania warunku złączenia w JOIN:
-- JOIN ON warunek logiczny
SELECT * FROM employees e JOIN jobs j ON j.job_id = e.job_id;

-- JOIN USING(kolumna)
-- W obu tabelach kolumna, po której łączymy, musi mieć taką samą nazwę
SELECT * FROM employees JOIN jobs USING(job_id);

-- NATURAL JOIN - sam znajduje kolumny o jednakowych nazwach i po nich łączy
-- raczej nie używajcie - łatwo się pomylić
SELECT * FROM employees NATURAL JOIN jobs;

-- Kierunki złączeń: INNER, LEFT, RIGHT, FULL
SELECT * FROM employees JOIN departments USING(department_id);

-- Domyślnym rodzajem jest INNER. W wynikach pojawiają tylko te rekordy, dla których udało się znaleźć dopasowanie
-- W wynikach nie Kimberely Grant, bo ona nie ma podanego departamentu (department_id IS NULL)
SELECT * FROM employees INNER JOIN departments USING(department_id);

-- LEFT JOIN - będą wszystkie rekordy z lewej tabeli, i te z prawej, które udało się dopasować
-- Jest K.Grant
SELECT * FROM employees LEFT JOIN departments USING(department_id);

-- RIGHT JOIN - będą wszystkie rekordy z prawej tabeli, i te z lewej, które udało się dopasować
-- Nie ma K.Grant, ale są departamenty, w których nikt nie pracuje
SELECT * FROM employees RIGHT JOIN departments USING(department_id);

-- FULL JOIN (można też pisać FULL OUTER JOIN)
-- są wszystkie rekordy z obu tabel, połączone jeśli pasują
SELECT * FROM employees FULL JOIN departments USING(department_id);

