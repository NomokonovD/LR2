CREATE TABLE conscript (
  conscript_id INT PRIMARY KEY NOT NULL,
  personal_file_id INT NOT NULL,
  FOREIGN KEY (personal_file_id) REFERENCES personal_file (personal_file_id)
);

CREATE TABLE relative (
  relative_id INT PRIMARY KEY NOT NULL,
  personal_data_id INT NOT NULL,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data (personal_data_id)
);

CREATE TABLE personal_data (
  personal_data_id INT PRIMARY KEY NOT NULL,
  surname VARCHAR(40) NOT NULL,
  name VARCHAR(15) NOT NULL,
  patronymic VARCHAR(40) NULL,
  date_of_birth DATE NOT NULL,
  place_of_birth VARCHAR(255) NOT NULL,
  place_of_registration_id INT NOT NULL,
  nationality VARCHAR(50) NOT NULL,
  criminal_record VARCHAR(4) NOT NULL,
  family_type VARCHAR(50) NULL,
  passport_data VARCHAR(10) NOT NULL,
  gender VARCHAR(7) NOT NULL,
  phone_number VARCHAR(11) NOT NULL,
  FOREIGN KEY (place_of_registration_id) REFERENCES place_of_registration (place_of_registration_id)
);

CREATE TABLE place_of_registration (
  place_of_registration_id INT PRIMARY KEY NOT NULL,
  federal_district VARCHAR(50) NOT NULL,
  area VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  street VARCHAR(50) NOT NULL,
  house_number VARCHAR(5) NOT NULL,
  fraction INT NULL,
  flat INT NULL
);

CREATE TABLE personal_file (
  personal_file_id INT PRIMARY KEY NOT NULL,
  medical_report_id INT NOT NULL,
  call_id INT NOT NULL,
  military_service VARCHAR(4) NOT NULL,
  military_ticket VARCHAR(20) NULL,
  rank VARCHAR(25) NULL,
  date_of_registration DATE NULL,
  date_of_deregistration DATE NULL,
  personal_data_id INT NOT NULL,
  military_unit_id INT NOT NULL,
  FOREIGN KEY (medical_report_id) REFERENCES medical_report (medical_report_id),
  FOREIGN KEY (call_id) REFERENCES call (call_id),
  FOREIGN KEY (personal_data_id) REFERENCES personal_data (personal_data_id),
  FOREIGN KEY (military_unit_id) REFERENCES military_unit (military_unit_id)
);

CREATE TABLE medical_report (
  medical_report_id INT PRIMARY KEY NOT NULL,
  shelf_life_category VARCHAR(20) NOT NULL,
  doctor VARCHAR(50) NOT NULL,
  diagnosis VARCHAR(50) NOT NULL
);

CREATE TABLE place_work (
  place_work_id INT PRIMARY KEY NOT NULL,
  name_organisation VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  field_activity VARCHAR(100) NOT NULL,
  state_accreditation VARCHAR(20) NOT NULL,
  personal_data_id INT NOT NULL,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data(personal_data_id)
);

CREATE TABLE place_study (
  place_study_id INT PRIMARY KEY NOT NULL,
  name_organisation VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  education_level VARCHAR(50) NOT NULL,
  end_status VARCHAR(15) NULL,
  personal_data_id INT NOT NULL,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data(personal_data_id)
);

CREATE TABLE kinship (
  kinship_id INT PRIMARY KEY NOT NULL,
  relative_id INT NOT NULL,
  conscript_id INT NOT NULL,
  degree_kinship VARCHAR(20) NOT NULL,
  FOREIGN KEY (relative_id) REFERENCES relative (relative_id),
  FOREIGN KEY (conscript_id) REFERENCES conscript (conscript_id)
);

CREATE TABLE call (
  call_id INT PRIMARY KEY NOT NULL,
  draft_date DATE NOT NULL,
  place_of_call VARCHAR(255) NOT NULL,
  season_name VARCHAR(10) NOT NULL
);

CREATE TABLE military_unit (
  military_unit_id INT PRIMARY KEY NOT NULL,
  name_military_unit VARCHAR(255) NOT NULL,
  city VARCHAR(50) NOT NULL,
  type_troops VARCHAR(100) NOT NULL
);

--Заполнение таблицы family_type

--Заполнение таблицы place of registrarion

INSERT INTO place_of_registration (place_of_registration_id, federal_district, area, city, street, house_number, fraction, flat)
VALUES
  (1, 'Московский федеральный округ', 'Центральный район', 'Москва', 'Тверская', '10', '4', 1),
  (2, 'Северо-Западный федеральный округ', 'Ленинградская область', 'Санкт-Петербург', 'Невский проспект', '25', '3', 2),
  (3, 'Уральский федеральный округ', 'Свердловская область', 'Екатеринбург', 'Ленина', '5', '6', 3),
  (4, 'Сибирский федеральный округ', 'Красноярский край', 'Красноярск', 'Мира', '15', '1', 4),
  (5, 'Дальневосточный федеральный округ', 'Приморский край', 'Владивосток', 'Океанский проспект', '50', '3', 5);

--Заполнение таблицы military unit

INSERT INTO military_unit (military_unit_id, name_military_unit, city, type_troops)
VALUES
  (1, '1-й гвардейский танковый полк', 'Москва', 'Танковые войска'),
  (2, '77-я отдельная гвардейская мотострелковая бригада', 'Петрозаводск', 'Мотострелковые войска'),
  (3, '14-я отдельная гвардейская бронетанковая бригада', 'Новосибирск', 'Бронетанковые войска'),
  (4, '31-й отдельный морской полк', 'Севастополь', 'Морская пехота'),
  (5, '56-я отдельная десантно-штурмовая бригада', 'Краснодар', 'Десантно-штурмовые войска');

--Заполнение таблицы call

INSERT INTO call (call_id, draft_date, place_of_call, season_name)
VALUES
  (1, '2022-04-15', 'Москва', 'Весна 2022'),
  (2, '2022-04-20', 'Санкт-Петербург', 'Весна 2022'),
  (3, '2022-04-10', 'Екатеринбург', 'Весна 2022'),
  (4, '2022-10-05', 'Новосибирск', 'Осень 2022'),
  (5, '2022-10-12', 'Красноярск', 'Осень 2022'),
  (6, '2022-10-19', 'Чита', 'Осень 2022');

--Заполнение таблицы medical report

INSERT INTO medical_report (medical_report_id, shelf_life_category, doctor, diagnosis)
VALUES
  (1, 'Годен', 'Иванова А.Н.', 'Грипп'),
  (2, 'Годен', 'Петров С.В.', 'Ангина'),
  (3, 'Ограниченно годен', 'Сидорова Е.М.', 'Пищеварительное расстройство'),
  (4, 'Негоден', 'Ковалёв Д.И.', 'Психическое расстройство'),
  (5, 'Негоден', 'Смирнова О.А.', 'Аллергия');

--Заполнение таблицы personal_data

--ПРИЗЫВНИК:
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES (1, 'Иванов', 'Алексей', 'Петрович', '1998-04-15', 'Москва', 3, 'Русский', 'Нет', '123456789', 'Мужской', 'num');


--ПРИЗЫВНИК И МАТЬ
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (2, 'Смирнова', 'Елена', 'Андреевна', '1975-08-20', 'Санкт-Петербург', 1, 'Русский', 'Нет', '987654321', 'Женский', 'num'),
  (3, 'Смирнов', 'Иван', 'Александрович', '1975-08-20', 'Москва', 4, 'Русский', 'Нет' '234567890', 'Мужской', 'num'),
  (13, 'Смирнов', 'Артём', 'Андреевич', '1970-06-02', 'Санкт-Петербург', 3, 'Русский', 'Да', '738495637', 'Мужской', 'num'); 

--ПРИЗЫВНИК, МАТЬ, ОТЕЦ:
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (4, 'Ковалев', 'Максим', 'Сергеевич', '1992-11-05', 'Екатеринбург', 1, 'Русский', 'Нет', '654321987', 'Мужской', 'num'),
  (5, 'Ковалёва', 'Мария', 'Ивановна', '1975-03-18', 'Москва', 2, 'Татар', 'Нет', '123456789', 'Женский', 'num'),
  (6, 'Ковалёв', 'Сергей', 'Петрович', '1972-11-30', 'Москва', 2, 'Русский', 'Нет', '987654321', 'Мужской', 'num');

--ПРИЗЫВНИКИ:
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (7, 'Петрова', 'Ольга', 'Ивановна', '1998-04-15', 'Нижний Новгород', 5, 'Русский', 'Нет', '789456123', 'Женский', 'num'),
  (8, 'Сидоров', 'Дмитрий', 'Александрович', '1995-02-28', 'Казань', 4, 'Русский', 'Нет', '456123789', 'Мужской', 'num');

--ПРИЗЫВНИК, МАТЬ, ОТЕЦ:
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (9, 'Домофонов', 'Даня', 'Сергеевич', '1996-12-05', 'Новосибирск', 1, 'Чечен', 'Нет', '654321987', 'Мужской', 'num'),
  (10, 'Номокушкина', 'Мария', 'Ивановна', '1975-03-18', 'Новосибирск', 2, 'Татар', 'Нет', '123456789', 'Женский', 'num'),
  (11, 'Номокушкин', 'Вячеслав', 'Петрович', '1972-11-30', 'Новосибирск', 2, 'Русский', 'Нет', '987654321', 'Мужской', 'num'),
  (12, 'Орлов', 'Алексей', 'Иванович', '1973-02-12', 'Бердск', 4, 'Русский', 'Нет', '937485021', 'Мужской', 'num');


--Заполнение таблицы personal_file
INSERT INTO personal_file (personal_file_id, medical_report_id, call_id, military_service, military_ticket, rank, date_of_registration, date_of_deregistration, personal_data_id, military_unit_id)
VALUES
  (1, 3, 4, 'Да', 'АБ123456', 'Сержант', '2022-01-01', '2023-02-28', 1, 3),
  (2, 2, 6, 'Нет', 'ВГ654321', 'Рядовой', '2021-05-10', '2023-05-16', 3, 1),
  (3, 1, 5, 'Да', 'ЖД678901', 'Старшина', '2023-02-15', NULL, 4, 5),
  (4, 4, 2, 'Нет', 'ПМ246810', 'Лейтенант', '2015-08-20', '2017-01-15', 7, 2),
  (5, 5, 3, 'Да', 'ИХ543210', 'Капитан', '2022-03-12', NULL, 8, 4),
  (6, 3, 2, 'Да', 'АП342513', 'Рядовой', '2022-12-02', NULL, 9, 1);

--Заполнение таблицы conscript
INSERT INTO conscript (conscript_id, personal_file_id)
VALUES
  (1, 1), --//ИВАНОВ
  (2,2), --//СМИРНОВ
  (3,3), --//КОВАЛЕВ
  (4,4), --//ПЕТРОВА
  (5,5), --//СИДОРОВ
  (6,6); --//ДОМОФОНОВ

--Заполнение таблицы relative
INSERT INTO relative (relative_id, personal_data_id)
VALUES
  (1, 2), 
  (2, 5), 
  (3, 6),
  (4, 10), 
  (5, 11),
  (6, 12), 
  (7, 13); 

--Заполнение таблицы kinship
INSERT INTO kinship (kinship_id, relative_id, conscript_id, degree_kinship)
VALUES
  (1, 1, 2, 'Мать'),
  (2, 2, 3, 'Мать'),
  (3, 3, 3, 'Отец'),
  (4, 4, 6, 'Приёмная мать'),
  (5, 5, 6, 'Приёмный отец'),
  (6, 6, 6, 'Дядя'),
  (7, 7, 2, 'Дядя');

--Заполнение таблицы place_work
INSERT INTO place_work (place_work_id, name_organisation, address, field_activity, state_accreditation, personal_data_id)
VALUES
  (1, 'ООО Рога и копыта', 'ул. Центральная 1', 'Информационные технологии', 'Аккредитовано', 2),
  (2, 'ЗАО Солнышко', 'пр. Ленина 10', 'Продажа товаров', 'Аккредитовано', 5),
  (3, 'ИП Петров', 'ул. Садовая 5', 'Строительство', 'Аккредитовано', 6),
  (4, 'ОАО Рога и Копыта', 'пр. Победы 20', 'Финансы', 'Аккредитовано', 7),
  (5, 'ООО Созвездие', 'ул. Парковая 3', 'IT', 'Аккредитовано', 10),
  (6, 'Государственный банк', 'пр. Красный 5', 'Финансы', 'Аккредитовано', 11),
  (7, 'ООО Прога', 'ул. Парковая 3', 'IT', 'Не аккредитовано', 10);


--Заполнение таблицы place_study
INSERT INTO place_study (place_study_id, name_organisation, address, education_level, end_status, personal_data_id)
VALUES
  (1, 'Университет им. Иванова', 'ул. Главная 1', 'Высшее', 'Окончено', 1),
  (2, 'Университет им. Иванова', 'ул. Главная 1', 'Высшее', 'Окончено', 11),
  (3, 'Колледж Профессионал', 'пр. Ленина 10', 'Среднее специальное', 'Окончено', 3),
  (4, 'кола 5', 'ул. Садовая 5', 'Среднее', 'Окончено', 4),
  (5, 'Университет им. Петрова', 'пр. Победы 20', 'Высшее', 'Окончено', 8),
  (6, 'Институт искусств', 'ул. Театральная 10', 'Высшее', 'Окончено', 9);


--3 типа семьи
--5 мест регистрации
--5 воинских частей
--6 призывов
--6 призывников 
--5 родителей
