
--Вывести количество призывников, проходивших призыв в определенной военной части
CREATE FUNCTION count_conscripts_in_unit(unit_name VARCHAR)
RETURNS INTEGER AS
$$
DECLARE
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count 
    FROM conscript AS c 
    JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
    JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
    JOIN military_unit AS mu ON pf.military_unit_id = mu.military_unit_id 
    WHERE mu.name_military_unit = unit_name;

    RETURN total_count;
END;
$$
LANGUAGE 'plpgsql';

--Запрос
SELECT count_conscripts_in_unit('1-й гвардейский танковый полк');


--Рассчитайте процент полностью здоровых призывников для каждого региона.

CREATE OR REPLACE FUNCTION calculate_healthy_percentage()
  RETURNS TABLE(region VARCHAR(255), healthy_percentage NUMERIC)
AS $$
BEGIN
  RETURN QUERY
    SELECT pr.area AS region,
           CAST((CAST(COUNT(*) FILTER (WHERE mrd.shelf_life_category = 'Годен') AS NUMERIC) / CAST(COUNT(*) AS NUMERIC)) * 100 AS NUMERIC(10, 2)) AS healthy_percentage
    FROM place_of_registration pr
    JOIN personal_data pd ON pd.place_of_registration_id = pr.place_of_registration_id
    JOIN personal_file pf ON pd.personal_data_id = pf.personal_data_id
    JOIN medical_report mrd ON pf.medical_report_id = mrd.medical_report_id
    JOIN conscript c ON pf.personal_file_id = c.personal_file_id
    JOIN military_unit mu ON pf.military_unit_id = mu.military_unit_id
    JOIN call cl ON pf.call_id = cl.call_id
    WHERE mrd.shelf_life_category = 'Годен' OR mrd.shelf_life_category = 'Негоден' OR mrd.shelf_life_category = 'Ограниченно годен'
    GROUP BY pr.area;

END;
$$ LANGUAGE 'plpgsql';

--Запрос
SELECT * FROM calculate_healthy_percentage();


--•	Установите порядок призыва призывников в зависимости от их медицинского здоровья и судимостей их родственников.
CREATE OR REPLACE FUNCTION sort_conscripts_by_health_and_criminal()
  RETURNS TABLE(surname VARCHAR(255), name VARCHAR(255), patronymic VARCHAR(255), conscript_id INT, health_status VARCHAR(255), relative_criminal_record BOOLEAN)
AS $$
BEGIN
  RETURN QUERY
    SELECT  pd.surname, pd.name, pd.patronymic, c.conscript_id, mrd.shelf_life_category AS health_status, 
       CASE WHEN pd_rel.criminal_record = 'Да' THEN TRUE ELSE FALSE END AS  relative_criminal_record
    FROM conscript c
    JOIN personal_file pf ON c.personal_file_id = pf.personal_file_id
    JOIN medical_report mrd ON pf.medical_report_id = mrd.medical_report_id
    LEFT JOIN personal_data pd ON pd.personal_data_id = pf.personal_data_id
    LEFT JOIN kinship k ON k.conscript_id = c.conscript_id
    LEFT JOIN relative r ON r.relative_id = k.relative_id
    LEFT JOIN personal_data pd_rel ON pd_rel.personal_data_id = r.personal_data_id
    ORDER BY CASE
    WHEN mrd.shelf_life_category = 'Годен' THEN 1
    WHEN mrd.shelf_life_category = 'Ограниченно годен' THEN 2
    WHEN mrd.shelf_life_category = 'Негоден' THEN 3
    ELSE 4
END,
relative_criminal_record ASC;

END;
$$ LANGUAGE 'plpgsql';

--Запрос
SELECT * FROM sort_conscripts_by_health_and_criminal();




--	Сформируйте медицинское заключение для хранения информации о состоянии здоровья призывника и принятия решения о годности его к военной службе. (пояснение: т.е. медицинское заключение должно формироваться автоматически, на основании других таблиц)

-- Создание таблицы medical_report_history
CREATE TABLE medical_report_history (
  report_id SERIAL PRIMARY KEY,
  conscript_id_sel INT,
  surname VARCHAR(255),
  name VARCHAR(255),
  patronymic VARCHAR(255),
  health_status VARCHAR(255),
  diagnosis_status VARCHAR(255),
  doctor_name VARCHAR(255)
);

CREATE OR REPLACE FUNCTION generate_medical_report(conscript_id_sel INT)
  RETURNS VOID
AS $$
DECLARE
  medical_info RECORD;
BEGIN
  -- Получение информации о призывнике
  SELECT
    pd.surname,
    pd.name,
    pd.patronymic,
    mrd.shelf_life_category AS health_status,
    mrd.diagnosis AS diagnosis_status,
    mrd.doctor AS doctor_name
  INTO
    medical_info
  FROM
    conscript c
    JOIN personal_file pf ON c.personal_file_id = pf.personal_file_id
    JOIN personal_data pd ON pd.personal_data_id = pf.personal_data_id
    JOIN medical_report mrd ON pf.medical_report_id = mrd.medical_report_id
  WHERE
    c.conscript_id = conscript_id_sel;

  -- Добавление записи в отдельную таблицу с медицинскими заключениями
  INSERT INTO medical_report_history (conscript_id_sel, surname, name, patronymic, health_status, diagnosis_status, doctor_name)
  VALUES (conscript_id_sel, medical_info.surname, medical_info.name, medical_info.patronymic, medical_info.health_status, medical_info.diagnosis_status, medical_info.doctor_name);

  -- Дополнительные действия по формированию медицинского заключения
  -- ...

  -- Пример вывода информации в консоль
  RAISE NOTICE 'Медицинское заключение сформировано и сохранено для призывника %', conscript_id_sel;
END;
$$ LANGUAGE 'plpgsql';

--Запрос 
SELECT generate_medical_report(4);

DROP FUNCTION generate_medical_report;

SELECT * FROM medical_report_history;




--	Рассчитайте скользящее значение полностью прошедших военную службу призывников в мотострелковых войсках к 2021 году.

CREATE OR REPLACE FUNCTION calculate_service_years()
  RETURNS TABLE (year INT, average_service_years BIGINT) AS $$
DECLARE
  start_year INT := 2017;
  end_year INT := 2021; 
  current_year INT;
BEGIN
  FOR current_year IN start_year..end_year LOOP
    RETURN QUERY
    SELECT current_year, COUNT(EXTRACT(YEAR FROM age(pf.date_of_registration, pf.date_of_deregistration)))
    FROM personal_file pf
    JOIN military_unit mu ON mu.military_unit_id = pf.military_unit_id
    WHERE mu.type_troops = 'Мотострелковые войска'
      AND EXTRACT(YEAR FROM date_of_deregistration) <= current_year
    GROUP BY current_year;
  END LOOP;

  RETURN;
END;
$$ LANGUAGE 'plpgsql';

--Запрос

SELECT * FROM calculate_service_years();

DROP FUNCTION calculate_service_years();
