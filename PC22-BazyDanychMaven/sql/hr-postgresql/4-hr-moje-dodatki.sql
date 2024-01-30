CREATE OR REPLACE VIEW szczegoly_pracownika AS
SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, e.manager_id AS manager_id,
  department_id, d.department_name, d.manager_id AS department_manager_id,
  location_id, l.street_address, l.city, l.postal_code,
  country_id, c.country_name, region_id, r.region_name
FROM employees e
  LEFT JOIN jobs j USING (job_id)
  LEFT JOIN departments d USING (department_id)
  LEFT JOIN locations l USING (location_id)
  LEFT JOIN countries c USING (country_id)
  LEFT JOIN regions r USING (region_id)
ORDER BY e.employee_id;


CREATE OR REPLACE FUNCTION pensje_dzisiaj() RETURNS void AS $$
DECLARE
   pracownik employees%ROWTYPE;
BEGIN
   FOR pracownik IN SELECT * FROM employees
   LOOP
      INSERT INTO salary_history(employee_id, salary, date)
      VALUES (pracownik.employee_id, pracownik.salary, current_date);
   END LOOP;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE przenies_pracownika(
      emp_id employees.employee_id%TYPE,
      dep_id employees.department_id%TYPE,
      job_id employees.job_id%TYPE
   ) AS $$
DECLARE
   stary employees%ROWTYPE;
   data_poczatkowa DATE;
BEGIN
   SELECT * FROM employees
      WHERE employee_id = emp_id
      INTO stary;

   IF NOT FOUND THEN
      RAISE EXCEPTION 'employee % not found', emp_id;
   END IF;

   SELECT max(end_date) FROM job_history
      WHERE employee_id = emp_id
      INTO data_poczatkowa;
   IF data_poczatkowa IS NULL
   THEN data_poczatkowa := stary.hire_date;
   END IF;

   INSERT INTO job_history(employee_id, start_date, end_date, job_id, department_id)
   VALUES (emp_id, data_poczatkowa, current_date, stary.job_id, stary.department_id);

   UPDATE employees SET
      department_id = dep_id,
      job_id = przenies_pracownika.job_id
   WHERE employee_id = emp_id;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION nazwisko_szefa(
      emp_id INTEGER
   ) RETURNS VARCHAR AS $$
DECLARE
   wynik VARCHAR;
BEGIN
   SELECT first_name || ' ' || last_name
   INTO wynik
   FROM employees
   WHERE employee_id = (SELECT manager_id FROM employees WHERE employee_id = emp_id);
   RETURN wynik;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION statystyki_departamentu(
      dep_id IN INTEGER,
      emp_count OUT INTEGER,
      avg_salary OUT NUMERIC,
      min_salary OUT NUMERIC,
      max_salary OUT NUMERIC
   ) RETURNS record AS $$
BEGIN
   SELECT count(employee_id), avg(salary), min(salary), max(salary)
   INTO emp_count, avg_salary, min_salary, max_salary
   FROM employees
   WHERE department_id = dep_id;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION zarabiajacy_wiecej_niz(emp_id INTEGER)
	RETURNS SETOF employees AS $$
DECLARE
	the_salary NUMERIC;
BEGIN
	SELECT salary INTO the_salary FROM employees WHERE employee_id = emp_id;
	RETURN QUERY
		SELECT * FROM employees WHERE salary > the_salary ORDER BY salary ASC;
END
$$ LANGUAGE plpgsql;
