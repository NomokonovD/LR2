CREATE TABLE conscript (
  conscript_id INT PRIMARY KEY,
  personal_file_id INT,
  FOREIGN KEY (personal_file_id) REFERENCES personal_file (personal_file_id)
);

CREATE TABLE relative (
  relative_id INT PRIMARY KEY,
  personal_data_id INT,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data (personal_data_id)
);

CREATE TABLE personal_data (
  personal_data_id INT PRIMARY KEY,
  surname VARCHAR(40),
  name VARCHAR(15),
  patronymic VARCHAR(40),
  date_of_birth DATE,
  place_of_birth VARCHAR(255),
  place_of_registration_id INT,
  nationality VARCHAR(255),
  criminal_record VARCHAR(255),
  family_type VARCHAR(255),
  passport_data VARCHAR(255),
  gender VARCHAR(255),
  phone_number VARCHAR(255),
  FOREIGN KEY (place_of_registration_id) REFERENCES place_of_registration (place_of_registration_id)
);

CREATE TABLE place_of_registration (
  place_of_registration_id INT PRIMARY KEY,
  federal_district VARCHAR(255),
  area VARCHAR(255),
  city VARCHAR(255),
  street VARCHAR(255),
  house_number VARCHAR(255),
  fraction VARCHAR(255),
  flat INT
);

CREATE TABLE personal_file (
  personal_file_id INT PRIMARY KEY,
  medical_report_id INT,
  call_id INT,
  military_service VARCHAR(255),
  military_ticket VARCHAR(255),
  rank VARCHAR(255),
  date_of_registration DATE,
  date_of_deregistration DATE,
  personal_data_id INT,
  military_unit_id INT,
  FOREIGN KEY (medical_report_id) REFERENCES medical_report (medical_report_id),
  FOREIGN KEY (call_id) REFERENCES call (call_id),
  FOREIGN KEY (personal_data_id) REFERENCES personal_data (personal_data_id),
  FOREIGN KEY (military_unit_id) REFERENCES military_unit (military_unit_id)
);

CREATE TABLE medical_report (
  medical_report_id INT PRIMARY KEY,
  shelf_life_category VARCHAR(255),
  doctor VARCHAR(255),
  diagnosis VARCHAR(255)
);

CREATE TABLE place_work (
  place_work_id INT PRIMARY KEY NOT NULL,
  name_organisation VARCHAR(255),
  address VARCHAR(255),
  field_activity VARCHAR(255),
  state_accreditation VARCHAR(255),
  personal_data_id INT,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data(personal_data_id)
);

CREATE TABLE place_study (
  place_study_id INT PRIMARY KEY,
  name_organisation VARCHAR(255),
  address VARCHAR(255),
  education_level VARCHAR(255),
  end_status VARCHAR(255),
  personal_data_id INT,
  FOREIGN KEY (personal_data_id) REFERENCES personal_data(personal_data_id)
);

CREATE TABLE kinship (
  kinship_id INT PRIMARY KEY,
  relative_id INT,
  conscript_id INT,
  degree_kinship VARCHAR(255),
  FOREIGN KEY (relative_id) REFERENCES relative (relative_id),
  FOREIGN KEY (conscript_id) REFERENCES conscript (conscript_id)
);

CREATE TABLE call (
  call_id INT PRIMARY KEY,
  draft_date DATE,
  place_of_call VARCHAR(255),
  season_name VARCHAR(255)
);

CREATE TABLE military_unit (
  military_unit_id INT PRIMARY KEY,
  name_military_unit VARCHAR(255),
  city VARCHAR(255),
  type_troops VARCHAR(255)
);

--Заполнение таблицы family_type

--Заполнение таблицы place of registrarion

INSERT INTO place_of_registration (place_of_registration_id, federal_district, area, city, street, house_number, fraction, flat)
VALUES
  (1, 'Московский федеральный округ', 'Московская область', 'Москва', 'Тверская', '10', '4', 1),
  (2, 'Северо-Западный федеральный округ', 'Ленинградская область', 'Санкт-Петербург', 'Невский проспект', '25', '3', 2),
  (3, 'Уральский федеральный округ', 'Свердловская область', 'Екатеринбург', 'Ленина', '5', '6', 3),
  (4, 'Сибирский федеральный округ', 'Красноярский край', 'Красноярск', 'Мира', '15', '1', 4),
  (5, 'Дальневосточный федеральный округ', 'Приморский край', 'Владивосток', 'Океанский проспект', '50', '3', 5);

  INSERT INTO place_of_registration (place_of_registration_id, federal_district, area, city, street, house_number, fraction, flat)
VALUES
  (6, 'Центральный федеральный округ', 'Тульская область', 'Тула', 'Пролетарская', '20', '2', 6),
  (7, 'Южный федеральный округ', 'Краснодарский край', 'Краснодар', 'Красная', '12', '5', 7),
  (8, 'Приволжский федеральный округ', 'Республика Татарстан', 'Казань', 'Кремлевская', '7', '1', 8),
  (9, 'Сибирский федеральный округ', 'Омская область', 'Омск', 'Ленинская', '30', '4', 9),
  (10, 'Дальневосточный федеральный округ', 'Хабаровский край', 'Хабаровск', 'Ленина', '8', '2', 10);

--Заполнение таблицы military unit

INSERT INTO military_unit (military_unit_id, name_military_unit, city, type_troops)
VALUES
  (1, '1-й гвардейский танковый полк', 'Москва', 'Танковые войска'),
  (2, '77-я отдельная гвардейская мотострелковая бригада', 'Петрозаводск', 'Мотострелковые войска'),
  (3, '14-я отдельная гвардейская бронетанковая бригада', 'Новосибирск', 'Бронетанковые войска'),
  (4, '31-й отдельный морской полк', 'Севастополь', 'Морская пехота'),
  (5, '56-я отдельная десантно-штурмовая бригада', 'Краснодар', 'Десантно-штурмовые войска');

INSERT INTO military_unit (military_unit_id, name_military_unit, city, type_troops)
VALUES
  (6, '2-й гвардейский мотострелковый полк', 'Санкт-Петербург', 'Мотострелковые войска'),
  (7, '39-я отдельная ракетная дивизия', 'Калининград', 'Ракетные войска'),
  (8, '103-й отдельный гвардейский артиллерийский полк', 'Екатеринбург', 'Артиллерийские войска'),
  (9, '45-й отдельный гвардейский инженерный полк', 'Ростов-на-Дону', 'Инженерные войска'),
  (10, '72-я отдельная бригада специального назначения', 'Владивосток', 'Специальные войска');

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
  (3, 'Смирнов', 'Иван', 'Александрович', '1975-08-20', 'Москва', 4, 'Русский', 'Нет', '234567890', 'Мужской', 'num'),
  (13, 'Смирнов', 'Артём', 'Андреевич', '1975-08-20', 'Санкт-Петербург', 3, 'Русский', 'Да', '738495637', 'Мужской', 'num'); 

--ПРИЗЫВНИК, МАТЬ, ОТЕЦ:
INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (4, 'Ковалев', 'Максим', 'Сергеевич', '1992-11-05', 'Екатеринбург', 1, 'Русский', 'Нет', '654321987', 'Мужской', 'num'),
  (5, 'Ковалёва', 'Мария', 'Ивановна', '1975-03-19', 'Москва', 2, 'Татар', 'Нет', '123456789', 'Женский', 'num'),
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
  (11, 'Номокушкин', 'Вячеслав', 'Петрович', '1972-11-29', 'Новосибирск', 2, 'Русский', 'Нет', '987654321', 'Мужской', 'num'),
  (12, 'Орлов', 'Алексей', 'Иванович', '1973-02-12', 'Бердск', 4, 'Русский', 'Нет', '937485021', 'Мужской', 'num');

INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (14, 'Соколовский', 'Иван', 'Алексеевич', '1990-09-20', 'Москва', 1, 'Русский', 'Нет', '987654321', 'Мужской', 'num'),
  (15, 'Зверева', 'Екатерина', 'Викторовна', '1985-07-08', 'Москва', 6, 'Русский', 'Нет', '543216789', 'Женский', 'num'),
  (16, 'Лебедев', 'Александр', 'Иванович', '1995-11-30', 'Екатеринбург', 4, 'Русский', 'Нет', '987654123', 'Мужской', 'num'),
  (17, 'Михайлова', 'Мария', 'Александровна', '1992-03-25', 'Нижний Новгород', 4, 'Русский', 'Нет', '123459876', 'Женский', 'num'),
  (18, 'Беляев', 'Алексей', 'Игоревич', '1991-08-12', 'Казань', 8, 'Русский', 'Нет', '987651234', 'Мужской', 'num');


INSERT INTO personal_data (personal_data_id, surname, name, patronymic, date_of_birth, place_of_birth, place_of_registration_id, nationality, criminal_record, passport_data, gender, phone_number)
VALUES
  (19, 'Кузнецов', 'Андрей', 'Владимирович', '1988-05-15', 'Санкт-Петербург', 2, 'Русский', 'Нет', '987650001', 'Мужской', 'num'),
  (20, 'Воробьев', 'Сергей', 'Иванович', '1993-12-10', 'Москва', 3, 'Русский', 'Нет', '987650002', 'Мужской', 'num'),
  (21, 'Петров', 'Денис', 'Александрович', '1997-09-02', 'Нижний Новгород', 5, 'Русский', 'Нет', '987650003', 'Мужской', 'num'),
  (22, 'Сидоров', 'Максим', 'Сергеевич', '1994-06-18', 'Екатеринбург', 7, 'Русский', 'Нет', '987650004', 'Мужской', 'num'),
  (23, 'Григорьев', 'Владислав', 'Николаевич', '1990-02-28', 'Казань', 9, 'Русский', 'Нет', '987650005', 'Мужской', 'num'),

  (24, 'Никитин', 'Артем', 'Александрович', '1991-03-08', 'Самара', 6, 'Русский', 'Нет', '987650006', 'Мужской', 'num'),
  (25, 'Волков', 'Дмитрий', 'Игоревич', '1996-10-12', 'Волгоград', 8, 'Русский', 'Нет', '987650007', 'Мужской', 'num'),
  (26, 'Романов', 'Николай', 'Андреевич', '1993-07-25', 'Ростов-на-Дону', 3, 'Русский', 'Нет', '987650008', 'Мужской', 'num'),
  (27, 'Алексеев', 'Михаил', 'Владимирович', '1997-12-03', 'Новосибирск', 10, 'Русский', 'Нет', '987650009', 'Мужской', 'num'),
  (28, 'Тимофеев', 'Илья', 'Олегович', '1992-09-17', 'Уфа', 4, 'Русский', 'Нет', '987650010', 'Мужской', 'num'),

  (29, 'Мельников', 'Артём', 'Игоревич', '1995-08-23', 'Красноярск', 1, 'Русский', 'Нет', '987650011', 'Мужской', 'num'),
  (30, 'Терентьев', 'Антон', 'Викторович', '1993-06-14', 'Омск', 5, 'Русский', 'Нет', '987650012', 'Мужской', 'num'),
  (31, 'Лебедев', 'Даниил', 'Алексеевич', '1998-02-17', 'Пермь', 9, 'Русский', 'Нет', '987650013', 'Мужской', 'num'),
  (32, 'Комаров', 'Михаил', 'Петрович', '1994-11-05', 'Воронеж', 3, 'Русский', 'Нет', '987650014', 'Мужской', 'num'),
  (33, 'Соловьев', 'Алексей', 'Сергеевич', '1990-09-30', 'Сочи', 7, 'Русский', 'Нет', '987650015', 'Мужской', 'num');


--Заполнение таблицы personal_file
INSERT INTO personal_file (personal_file_id, medical_report_id, call_id, military_service, military_ticket, rank, date_of_registration, date_of_deregistration, personal_data_id, military_unit_id)
VALUES
  (1, 3, 4, 'Да', 'АБ123456', 'Сержант', '2022-01-01', '2023-02-28', 1, 3),
  (2, 2, 6, 'Нет', 'ВГ654321', 'Рядовой', '2021-05-10', '2023-05-16', 3, 1),
  (3, 1, 5, 'Да', 'ЖД678901', 'Старшина', '2022-02-15', NULL, 4, 5),
  (4, 4, 2, 'Нет', 'ПМ246810', 'Лейтенант', '2015-08-20', '2017-01-15', 7, 2),
  (5, 5, 3, 'Да', 'ИХ543210', 'Капитан', '2022-03-12', NULL, 8, 4),
  (6, 3, 2, 'Да', 'АП342513', 'Рядовой', '2022-09-02', NULL, 9, 1);


INSERT INTO personal_file (personal_file_id, medical_report_id, call_id, military_service, military_ticket, rank, date_of_registration, date_of_deregistration, personal_data_id, military_unit_id)
VALUES
  (7, 4, 1, 'Да', 'ИХ543210', 'Капитан', '2022-03-12', NULL, 14, 4),
  (8, 2, 2, 'Да', 'МН987654', 'Лейтенант', '2021-11-05', '2023-04-30', 15, 6),
  (9, 3, 4, 'Нет', NULL, 'Рядовой', '2022-07-20', NULL, 16, 5),
  (10, 3, 2, 'Да', 'УЮ654321', 'Майор', '2023-01-10', NULL, 17, 7),
  (11, 1, 4, 'Да', 'ВТ135792', 'Прапорщик', '2022-09-15', '2023-03-31', 18, 9);

INSERT INTO personal_file (personal_file_id, medical_report_id, call_id, military_service, military_ticket, rank, date_of_registration, date_of_deregistration, personal_data_id, military_unit_id)
VALUES
  (12, 5, 3, 'Нет', 'РУ987654', 'Прапорщик', '2017-04-18', '2018-04-20', 19, 6),
  (13, 2, 5, 'Нет', 'РК982351', 'Рядовой', '2017-12-02', '2018-12-22', 20, 2),
  (14, 4, 1, 'Нет', 'ВК123456', 'Старший сержант', '2017-02-20', '2019-02-22', 21, 2),
  (15, 1, 6, 'Нет', 'ТЕ654321', 'Лейтенант', '2018-10-25', '2019-10-29', 22, 2),
  (16, 3, 4, 'Нет', 'УЛ789456', 'Капитан', '2018-03-05', '2020-03-05', 23, 6),

  (17, 3, 2, 'Нет', 'ПУ987654', 'Рядовой', '2018-07-12', '2019-08-15', 24, 2),
  (18, 1, 4, 'Нет', 'НМ234567', 'Прапорщик', '2018-09-30', '2020-12-01', 25, 6),
  (19, 5, 1, 'Нет', 'АВ123456', 'Сержант', '2019-02-05', '2021-03-08', 26, 6),
  (20, 2, 6, 'Нет', 'ТР654321', 'Рядовой', '2019-04-20', '2021-05-23', 27, 2),
  (21, 4, 3, 'Нет', 'ВЛ987654', 'Капрал', '2020-08-10', '2021-09-12', 28, 6),

  (22, 1, 4, 'Нет', 'ОБ987654', 'Рядовой', '2021-06-15', '2021-07-18', 29, 2),
  (23, 3, 2, 'Нет', 'АЗ982345', 'Старший сержант', '2020-09-02', '2019-01-10', 30, 6),
  (24, 4, 6, 'Нет', 'ЛЖ123456', 'Прапорщик', '2023-01-08', '2022-05-12', 31, 2),
  (25, 2, 1, 'Нет', 'ТЮ654321', 'Лейтенант', '2017-03-25', '2018-01-05', 32, 6),
  (26, 5, 5, 'Нет', 'РК789456', 'Капитан', '2022-10-10', '2020-04-15', 33, 2);

--Заполнение таблицы conscript
INSERT INTO conscript (conscript_id, personal_file_id)
VALUES
  (1, 1), --//ИВАНОВ
  (2,2), --//СМИРНОВ
  (3,3), --//КОВАЛЕВ
  (4,4), --//ПЕТРОВА
  (5,5), --//СИДОРОВ
  (6,6); --//ДОМОФОНОВ

INSERT INTO conscript (conscript_id, personal_file_id)
VALUES
  (7,7), 
  (8,8),
  (9,9),
  (10,10),
  (11,11);

INSERT INTO conscript (conscript_id, personal_file_id)
VALUES
  (12, 12),
  (13, 13),
  (14, 14),
  (15, 15),
  (16, 16),
  (17, 17),
  (18, 18),
  (19, 19),
  (20, 20),
  (21, 21),
  (22, 22),
  (23, 23),
  (24, 24),
  (25, 25),
  (26, 26);

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
