--Если прошло условно n лет с момента снятия с учета то, при следующем добавлении, удаляется данные об этом призывнике

CREATE OR REPLACE FUNCTION delete_conscript_trigger()
RETURNS TRIGGER AS $$
DECLARE
  deregistration_date DATE;
BEGIN
  SELECT date_of_deregistration FROM personal_file INTO deregistration_date; 
  IF (deregistration_date IS NOT NULL AND 
      deregistration_date < current_date - INTERVAL '5 years') THEN
    DELETE FROM conscript WHERE conscript_id = personal_file_id;
  END IF;
RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_conscript
AFTER INSERT ON personal_file
FOR EACH ROW
EXECUTE FUNCTION delete_conscript_trigger();


--Ограничение на то, что дата постановки на учет не может быть ≧ дата призыва

CREATE OR REPLACE FUNCTION check_registration_date()
RETURNS TRIGGER AS $$
DECLARE
    draft_date1 DATE;
BEGIN
    SELECT draft_date INTO draft_date1
    FROM call
    WHERE call_id = NEW.personal_file_id;

    IF NEW.date_of_registration >= draft_date1 THEN
        RAISE EXCEPTION 'The date of registration cannot be greater than or equal to the date of conscription';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER registration_date_check
BEFORE INSERT OR UPDATE ON personal_file
FOR EACH ROW
EXECUTE FUNCTION check_registration_date();


--«Проверка даты призыва» - перед введением информации о Призыве, триггер проверяет, что указанная дата призыва находится в допустимых пределах (например, не раньше 18-летнего возраста призывника и не позднее законной возрастной границы).

CREATE OR REPLACE FUNCTION check_draft_date()
RETURNS TRIGGER AS $$
BEGIN
    -- Получение даты рождения призывника
    DECLARE
        birth_date DATE;
        min_draft_date DATE;
        max_draft_date DATE;
    BEGIN
        SELECT date_of_birth INTO birth_date
        FROM personal_data
        WHERE personal_data_id = NEW.call_id;

        -- Вычисление минимальной и максимальной даты призыва на основе даты рождения
        min_draft_date := birth_date + INTERVAL '18 years';
        max_draft_date := birth_date + INTERVAL '27 years';

        IF NEW.draft_date < min_draft_date OR NEW.draft_date > max_draft_date THEN
            RAISE EXCEPTION 'Invalid draft date';
        END IF;

        RETURN NEW;
    END;
END;  
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER draft_date_check
BEFORE INSERT OR UPDATE ON call
FOR EACH ROW
EXECUTE FUNCTION check_draft_date();


-- Автоматическое заполнение поля «Тип семьи» - после ввода информации о Родственниках и их родственных связях в таблицы Родство и Родственник, триггер автоматически заполняет поле "Тип семьи" в таблице Призывник (например, "одиночка", "неполная семья", "полная семья" и т.д.).

CREATE OR REPLACE FUNCTION update_family_type()
RETURNS TRIGGER AS $$
BEGIN
   
     -- Проверяем наличие матери и отца у призывника
    IF EXISTS (
            SELECT 1
            FROM kinship k
            WHERE k.conscript_id = NEW.conscript_id
                AND k.degree_kinship = 'Мать'
        ) AND EXISTS (
            SELECT 1
            FROM kinship k
            WHERE k.conscript_id = NEW.conscript_id
                AND k.degree_kinship = 'Отец'
        ) THEN
            -- Если есть и мать, и отец, устанавливаем значение "Полная"
            UPDATE personal_data
            SET family_type = 'Полная'
            WHERE personal_data_id = NEW.conscript_id;

        ELSIF EXISTS (
            SELECT 1
            FROM kinship k
            WHERE k.conscript_id = NEW.conscript_id
                AND (k.degree_kinship = 'Мать' OR k.degree_kinship = 'Отец')
        ) THEN
            -- Если есть только мать или только отец, устанавливаем значение "Неполная"
            UPDATE personal_data
            SET family_type = 'Не полная'
            WHERE personal_data_id = NEW.conscript_id;

        ELSE
            -- Если нет ни матери, ни отца, устанавливаем значение "Одиночка"
            UPDATE personal_data
            SET family_type = 'Одиночка'
            WHERE personal_data_id = NEW.conscript_id;

        END IF;
        


    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_family_type_trigger
AFTER INSERT OR UPDATE ON kinship
FOR EACH ROW
EXECUTE FUNCTION update_family_type();


UPDATE kinship
SET degree_kinship = CASE
    WHEN kinship_id = 1 THEN 'Мать'
    WHEN kinship_id = 2 THEN 'Мать'
    WHEN kinship_id = 3 THEN 'Отец'
    WHEN kinship_id = 4 THEN 'Приемная мать'
    WHEN kinship_id = 5 THEN 'Приемный отец'
    WHEN kinship_id = 6 THEN 'Дядя'
    WHEN kinship_id = 7 THEN 'Дядя'
  END;


DROP TRIGGER update_family_type_trigger ON kinship;
DROP FUNCTION update_family_type;

SELECT * FROM personal_data;


--	"Обновление статуса годности к военной службе" - при изменении информации в таблице Медицинское заключение, триггер автоматически обновляет статус годности к военной службе в таблице Призывник на основе новой информации (например, "годен", "ограниченно годен", "негоден").

CREATE OR REPLACE FUNCTION update_shelf_life_category()
RETURNS TRIGGER AS $$
BEGIN
    CASE NEW.diagnosis
        WHEN 'Здоров' THEN
            NEW.shelf_life_category := 'Годен';
        WHEN 'Психическое расстройство' THEN
            NEW.shelf_life_category := 'Негоден';
        WHEN 'Астма' THEN
            NEW.shelf_life_category := 'Ограниченно годен';
        ELSE
            NULL;
    END CASE;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_shelf_life_category_trigger
BEFORE UPDATE ON medical_report
FOR EACH ROW
EXECUTE FUNCTION update_shelf_life_category();



UPDATE medical_report
SET diagnosis = 'Астма' WHERE medical_report_id = 2;


SELECT * FROM medical_report;

DROP TRIGGER update_shelf_life_category_trigger ON medical_report;
DROP FUNCTION update_shelf_life_category;