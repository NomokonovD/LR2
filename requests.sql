--Получить список всех призывников с указанием их ФИО, возраста, пола и адреса.

SELECT p.surname, p.name, p.patronymic, DATE_PART('year', AGE(NOW(), p.date_of_birth)) AS age, p.gender, r.federal_district, r.area, r.city, r.street, r.house_number
FROM conscript AS c
JOIN personal_file AS pf ON pf.personal_file_id = c.conscript_id
JOIN personal_data AS p ON p.personal_data_id = pf.personal_file_id
JOIN place_of_registration AS r ON p.place_of_registration_id = r.place_of_registration_id;

--Найти всех призывников, у которых статус годности к военной службе - "негоден".

SELECT pd.surname, pd.name, pd.patronymic, mr.shelf_life_category
FROM conscript AS c
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id
JOIN medical_report AS mr ON pf.medical_report_id = mr.medical_report_id
WHERE mr.shelf_life_category = 'Негоден';

--Получить список всех родственников определенного призывника.

SELECT pd.surname, pd.name, pd.patronymic, pd.date_of_birth, k.degree_kinship
FROM relative AS r
JOIN kinship AS k ON r.relative_id = k.relative_id
JOIN conscript AS c ON c.conscript_id = k.conscript_id
JOIN personal_data AS pd ON r.personal_data_id = pd.personal_data_id
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd_rel ON pd_rel.personal_data_id = pf.personal_data_id
WHERE pd_rel.surname = 'Домофонов' AND pd_rel.name = 'Даня' AND pd_rel.patronymic= 'Сергеевич';

--Найти призывников, живущих в определенном городе.

SELECT pd.surname, pd.name, pd.patronymic 
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN place_of_registration AS pr ON pr.place_of_registration_id = pd.place_of_registration_id 
WHERE pr.city = 'Москва'; 

--Получить список всех призывников, которые в настоящее время служат в армии.

SELECT pd.surname, pd.name, pd.patronymic 
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
WHERE pf.military_service = 'Да';

--Найти всех призывников, у которых в медицинском заключении указано "Ограниченно годен".

SELECT pd.surname, pd.name, pd.patronymic, mr.shelf_life_category
FROM conscript AS c
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id
JOIN medical_report AS mr ON pf.medical_report_id = mr.medical_report_id
WHERE mr.shelf_life_category = 'Ограниченно годен';

--Получить список призывников определенной возрастной группы.

SELECT pd.surname, pd.name, pd.patronymic, DATE_PART('year', AGE(NOW(), pd.date_of_birth)) AS age 
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
WHERE DATE_PART('year', AGE(NOW(), pd.date_of_birth)) BETWEEN 20 AND 40;

--Найти всех родственников определенного призывника, которые являются его родителями.

SELECT pd.surname, pd.name, pd.patronymic, k.degree_kinship
FROM relative AS r
JOIN kinship AS k ON r.relative_id = k.relative_id
JOIN conscript AS c ON c.conscript_id = k.conscript_id
JOIN personal_data AS pd ON r.personal_data_id = pd.personal_data_id
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd_rel ON pd_rel.personal_data_id = pf.personal_data_id
WHERE pd_rel.surname = 'Смирнов' AND pd_rel.name = 'Иван' AND pd_rel.patronymic= 'Александрович' AND (k.degree_kinship = 'Мать' OR  k.degree_kinship = 'Отец');

--Получить список призывников, у которых указана одинаковая дата рождения.

SELECT pd1.surname, pd1.name, pd1.patronymic, pd1.date_of_birth
FROM personal_data pd1
INNER JOIN personal_data pd2 ON pd1.date_of_birth = pd2.date_of_birth AND pd1.personal_data_id <> pd2.personal_data_id
INNER JOIN conscript c1 ON pd1.personal_data_id = c1.personal_file_id
INNER JOIN conscript c2 ON pd2.personal_data_id = c2.personal_file_id;

--Найти всех призывников из указанной военной части.

SELECT pd.surname, pd.name, pd.patronymic 
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN military_unit AS mu ON pf.military_unit_id = mu.military_unit_id 
WHERE mu.name_military_unit = '1-й гвардейский танковый полк';

--Получить список всех родственников, у которых указана одинаковая фамилия.

SELECT pd1.surname, pd1.name, pd1.patronymic, pd1.date_of_birth
FROM personal_data pd1
INNER JOIN personal_data pd2 ON (pd2.surname ILIKE CONCAT('%', pd1.surname, '%') OR pd1.surname ILIKE CONCAT('%', pd2.surname, '%')) AND  pd1.personal_data_id <> pd2.personal_data_id
INNER JOIN relative r1 ON pd1.personal_data_id = r1.personal_data_id
INNER JOIN relative r2 ON pd2.personal_data_id = r2.personal_data_id;

--Найти всех призывников из определенного областного центра.

SELECT pd.surname, pd.name, pd.patronymic 
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN place_of_registration AS pr ON pr.place_of_registration_id = pd.place_of_registration_id 
WHERE pr.area = 'Свердловская область'; 

--Получить список всех родственников определенного призывника, у которых указана одинаковая дата рождения

SELECT DISTINCT pd1.surname, pd1.name, pd1.patronymic, pd1.date_of_birth, k.degree_kinship
FROM relative AS r1
JOIN kinship AS k ON r1.relative_id = k.relative_id 
JOIN conscript AS c ON c.conscript_id = k.conscript_id
JOIN personal_data AS pd1 ON r1.personal_data_id = pd1.personal_data_id
JOIN personal_data AS pd2 ON pd1.personal_data_id <> pd2.personal_data_id
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd_rel ON pd_rel.personal_data_id = pf.personal_data_id
WHERE pd_rel.surname = 'Смирнов' AND pd_rel.name = 'Иван' AND pd_rel.patronymic= 'Александрович' AND pd1.date_of_birth = pd2.date_of_birth;

--Найти всех призывников, которых призвали на срочную военную службу в определенном году.

SELECT pd.surname, pd.name, pd.patronymic
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN call AS ca ON ca.call_id = pf.call_id
WHERE EXTRACT(YEAR FROM ca.draft_date) = 2022;

--Получить список всех родственников, у которых указан одинаковый адрес проживания.

SELECT DISTINCT pd1.surname, pd1.name, pd1.patronymic, pr.federal_district, pr.area, pr.city, pr.street, pr.house_number, pr.fraction, pr.flat
FROM personal_data pd1
INNER JOIN personal_data pd2 ON pd1.place_of_registration_id = pd2.place_of_registration_id AND pd1.personal_data_id <> pd2.personal_data_id
INNER JOIN conscript c1 ON pd1.personal_data_id = c1.personal_file_id
INNER JOIN conscript c2 ON pd2.personal_data_id = c2.personal_file_id
INNER JOIN place_of_registration AS pr ON pr.place_of_registration_id = pd1.place_of_registration_id;


--Получить список всех родственников, у которых указана одинаковая национальность.

SELECT pd.surname, pd.name, pd.patronymic, pd.nationality
FROM relative AS r
JOIN personal_data AS pd ON r.personal_data_id = pd.personal_data_id
GROUP BY pd.nationality, pd.surname, pd.name, pd.patronymic;

--Найти всех призывников, которые являются усыновленными детьми.

SELECT pd.surname, pd.name, pd.patronymic, k.degree_kinship
FROM conscript AS c
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id
JOIN kinship AS k ON k.conscript_id = c.conscript_id
WHERE k.degree_kinship = 'Приёмный отец' OR k.degree_kinship = 'Приёмная мать';

--Получить список всех родственников, которые получили высшее образование.

SELECT pd.surname, pd.name, pd.patronymic, ps.name_organisation
FROM relative AS r
JOIN personal_data AS pd ON r.personal_data_id = pd.personal_data_id
JOIN place_study AS ps ON ps.personal_data_id = pd.personal_data_id
WHERE ps.education_level = 'Высшее';

--Найти всех призывников, которые получили звание в армии.

SELECT pd.surname, pd.name, pd.patronymic, pf.military_ticket, pf.rank
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
WHERE pf.rank IS NOT NULL;

--Выведите информацию о всех призывниках из сибирского региона, не имеющих родственников с судимостями до 3 колена родства.

SELECT pd.surname, pd.name, pd.patronymic
FROM personal_data pd
JOIN personal_file pf ON pd.personal_data_id = pf.personal_data_id
JOIN conscript c ON pf.personal_file_id = c.personal_file_id
JOIN place_of_registration pr ON pd.place_of_registration_id = pr.place_of_registration_id
WHERE pr.federal_district = 'Сибирский федеральный округ'
  AND NOT EXISTS (
    SELECT 1
    FROM relative r
    JOIN kinship k ON r.relative_id = k.relative_id
    JOIN personal_data pd_rel ON r.personal_data_id = pd_rel.personal_data_id
    WHERE k.conscript_id = c.conscript_id
      AND pd_rel.criminal_record = 'Да'
  );

--Выведите ФИО всех призывников, работающих в it сфере и при этом их компании, не имеют государственной аккредитации. 

SELECT pd.surname, pd.name, pd.patronymic
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN place_work AS pw ON pw.personal_data_id = pd.personal_data_id
WHERE pw.field_activity = 'IT' AND pw.state_accreditation = 'Не аккредитовано';

--Выведите всех снятых с учета призывников в 2017 году по причине психического нездоровья.

SELECT pd.surname, pd.name, pd.patronymic, pf.date_of_deregistration, mr.diagnosis
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
JOIN medical_report AS mr ON mr.medical_report_id = pf.medical_report_id
WHERE EXTRACT(YEAR FROM pf.date_of_deregistration) = 2017 AND mr.diagnosis = 'Психическое расстройство';


--• Найти всех призывников, у которых есть военный билет.
SELECT pd.surname, pd.name, pd.patronymic, pf.military_ticket
FROM conscript AS c 
JOIN personal_file AS pf ON pf.personal_file_id = c.personal_file_id 
JOIN personal_data AS pd ON pd.personal_data_id = pf.personal_data_id 
WHERE pf.military_ticket IS NOT NULL;