----- TRIGGERS
---- PROJECTS
---Licență 2026
--Roșu Andreea-Florentina


-----FUNCTION: GET_WORKING_DAYS
CREATE OR REPLACE FUNCTION GET_WORKING_DAYS( 
    p_start_date IN DATE,  
    p_end_date IN DATE, 
    p_task_type IN VARCHAR2 
)  
RETURN NUMBER IS 
    v_days NUMBER := 0; 
    v_curr_date DATE := TRUNC(p_start_date); 
    v_holiday_count NUMBER; 
BEGIN 
    -- Exception: Support and Maintenance tasks are executed even on weekends/holidays 
    IF p_task_type LIKE '%Suport%' OR p_task_type LIKE '%Mentenanta%' THEN 
        RETURN TRUNC(p_end_date) - TRUNC(p_start_date) + 1; 
    END IF; 
 
    -- For normal tasks, calculate only actual working days 
    WHILE v_curr_date <= TRUNC(p_end_date) LOOP 
        -- Check if it's not Saturday or Sunday 
        IF TO_CHAR(v_curr_date, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') NOT IN ('SAT', 'SUN') THEN 
            -- Check if it's not a public holiday 
            SELECT COUNT(*) INTO v_holiday_count FROM HOLIDAYS_RO WHERE TRUNC(holiday_date) = v_curr_date; 
             
            IF v_holiday_count = 0 THEN 
                v_days := v_days + 1; 
            END IF; 
        END IF; 
        v_curr_date := v_curr_date + 1; 
    END LOOP; 
     
    RETURN v_days; 
END;
/

---2 TRIGGER TRG_CALC_TASK_DURATION: 
CREATE OR REPLACE TRIGGER TRG_CALC_TASK_DURATION
BEFORE INSERT OR UPDATE OF start_date_task, end_date_task ON TASKS
FOR EACH ROW
BEGIN
    :NEW.duration := GET_WORKING_DAYS(:NEW.start_date_task, :NEW.end_date_task, 'Normal');
END;
/


---3 TRIGGER TRG_PROJECTS: 
create or replace TRIGGER TRG_PROJECTS 
AFTER UPDATE ON PROJECTS 
FOR EACH ROW 
BEGIN 
    --checking the name 
    IF :OLD.name_project <> :NEW.name_project THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('PROJECTS', :OLD.id_project, 'NAME_PROJECT', :OLD.name_project, :NEW.name_project, 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;

    --checking the desciption 
    IF :OLD.description_project <> :NEW.description_project THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES('PROJECTS', :OLD.id_project, 'DESCRIPTION', :OLD.description_project, :NEW.description_project, 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;
 
    --checking the start date 
    IF :OLD.star_date <> :NEW.star_date THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('PROJECTS', :OLD.id_project, 'START_DATE', TO_CHAR(:OLD.star_date, 'DD-MM-YYYY'), TO_CHAR(:NEW.star_date, 'DD-MM-YYYY'), 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;
 
    --checking the end date 
    IF :OLD.end_date <> :NEW.end_date THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES('PROJECTS', :OLD.id_project, 'END_DATE', TO_CHAR(:OLD.end_date, 'DD-MM-YYYY'), TO_CHAR(:NEW.end_date, 'DD-MM-YYYY'), 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;

    --checking the total budget 
    IF :OLD.total_budget <> :NEW.total_budget THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('PROJECTS', :OLD.id_project, 'TOTAL_BUDGET', TO_CHAR(:OLD.total_budget), TO_CHAR(:NEW.total_budget), 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;
 
    --checking the real cost 
    IF :OLD.real_cost <> :NEW.real_cost THEN
        INSERT INTO CHANGE_LOG(table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('PROJECTS', :OLD.id_project, 'REAL_COST', TO_CHAR(:OLD.real_cost), TO_CHAR(:NEW.real_cost), 'UPDATE', V('APP_USER'), SYSDATE);
    END IF;
END;
/




--4 TRIGGER TRG_SUCCESSOR_RESCHEDULING:
create or replace TRIGGER TRG_SUCCESSOR_RESCHEDULING 
FOR UPDATE OF end_date_task ON TASKS 
COMPOUND TRIGGER 
 
    TYPE t_task_shift IS RECORD ( 
        p_id_task TASKS.id_task%TYPE, 
        days_diff NUMBER 
    ); 
    TYPE t_task_list IS TABLE OF t_task_shift; 
    v_tasks t_task_list := t_task_list(); 
 
    AFTER EACH ROW IS 
    BEGIN 
        -- Calculate the difference in days 
        IF :NEW.end_date_task <> :OLD.end_date_task THEN 
            v_tasks.EXTEND; 
            v_tasks(v_tasks.LAST).p_id_task := :NEW.id_task; 
            v_tasks(v_tasks.LAST).days_diff := :NEW.end_date_task - :OLD.end_date_task; 
        END IF; 
    END AFTER EACH ROW; 
 
    AFTER STATEMENT IS 
    BEGIN 
        -- If there is a change, reschedule all tasks that depend on this one 
        FOR i IN 1 .. v_tasks.COUNT LOOP 
            UPDATE TASKS 
            SET start_date_task = start_date_task + v_tasks(i).days_diff, 
                end_date_task = end_date_task + v_tasks(i).days_diff 
            WHERE id_predecessor = v_tasks(i).p_id_task; 
        END LOOP; 
    END AFTER STATEMENT; 
 
END TRG_SUCCESSOR_RESCHEDULING;
/


--5 TRIGGER TRG_TASKS:
create or replace TRIGGER TRG_TASKS
AFTER UPDATE OR DELETE ON TASKS
FOR EACH ROW
BEGIN 
    IF UPDATING THEN 
        -- Status
        IF :OLD.status_task <> :NEW.status_task THEN
            INSERT INTO CHANGE_LOG(table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
            VALUES ('TASKS', :OLD.id_task, 'STATUS_TASK', :OLD.status_task, :NEW.status_task, 'UPDATE', V('APP_USER'), SYSDATE);
        END IF;

        -- Member
        IF (:OLD.id_member IS NULL AND :NEW.id_member IS NOT NULL) OR (:OLD.id_member <> :NEW.id_member) THEN
            INSERT INTO CHANGE_LOG(table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
            VALUES ('TASKS', :OLD.id_task, 'ASSIGNED_MEMBER', :OLD.id_member, :NEW.id_member, 'UPDATE', V('APP_USER'), SYSDATE);
        END IF;
    END IF;

    IF DELETING THEN        
        INSERT INTO CHANGE_LOG(table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('TASKS', :OLD.id_task, 'TITLE', :OLD.title, NULL, 'DELETE', V('APP_USER'), SYSDATE); 
    END IF;
END;
/


---6 TRIGGER TRG_TEAM_CHANGES:
create or replace TRIGGER TRG_TEAM_CHANGES 
AFTER INSERT OR DELETE ON TEAM_PROJECTS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('TEAM_PROJECTS', :NEW.id_project, 'MEMBER_ADDED', NULL, :NEW.id_member, 'INSERT', V('APP_USER'), SYSDATE);    
    END IF;

    IF DELETING THEN
        INSERT INTO CHANGE_LOG (table_name, id_record, column_name, old_value, new_value, action_type, id_member, change_date)
        VALUES ('TEAM_PROJECTS', :OLD.id_project, 'MEMBER_REMOVED', :OLD.id_member, NULL, 'DELETE', V('APP_USER'), SYSDATE);    
    END IF;
END;
/


--7 TRIGGER TRG_UPDATE_PROJECT_BUDGET:
create or replace TRIGGER TRG_UPDATE_PROJECT_BUDGET
FOR INSERT OR UPDATE OR DELETE ON TASKS
COMPOUND TRIGGER

    TYPE t_project_id IS TABLE OF PROJECTS.id_project%TYPE;
    v_project_ids t_project_id := t_project_id();

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING OR UPDATING THEN
            IF :NEW.id_project IS NOT NULL THEN
                DECLARE v_exists BOOLEAN := FALSE; BEGIN
                    FOR i IN 1 .. v_project_ids.COUNT LOOP
                        IF v_project_ids(i) = :NEW.id_project THEN v_exists := TRUE; EXIT; END IF;
                    END LOOP;
                    IF NOT v_exists THEN v_project_ids.EXTEND; v_project_ids(v_project_ids.LAST) := :NEW.id_project; END IF;
                END;
            END IF;
        END IF;
        IF DELETING OR UPDATING THEN
            IF :OLD.id_project IS NOT NULL THEN
                DECLARE v_exists BOOLEAN := FALSE; BEGIN
                    FOR i IN 1 .. v_project_ids.COUNT LOOP
                        IF v_project_ids(i) = :OLD.id_project THEN v_exists := TRUE; EXIT; END IF;
                    END LOOP;
                    IF NOT v_exists THEN v_project_ids.EXTEND; v_project_ids(v_project_ids.LAST) := :OLD.id_project; END IF;
                END;
            END IF;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. v_project_ids.COUNT LOOP

            UPDATE PROJECTS p
            SET 
                p.real_cost = NVL((
                    SELECT SUM(t.hours * m.hourly_rate)
                    FROM TASKS t
                    JOIN TEAM_MEMBERS m ON t.id_member = m.id_member
                    WHERE t.id_project = p.id_project
                ), 0),

                p.star_date = NVL((SELECT MIN(t.start_date_task) FROM TASKS t WHERE t.id_project = p.id_project), p.initial_start_date),
                p.end_date = NVL((SELECT MAX(t.end_date_task) FROM TASKS t WHERE t.id_project = p.id_project), p.initial_end_date),
                p.total_hours = NVL((SELECT SUM(t.hours) FROM TASKS t WHERE t.id_project = p.id_project), 0),
                p.total_days = NVL((SELECT MAX(t.end_date_task) - MIN(t.start_date_task) FROM TASKS t WHERE t.id_project = p.id_project), 0)
            WHERE p.id_project = v_project_ids(i);

            UPDATE PROJECTS p
            SET p.total_budget = NVL(p.fixed_cost, 0) + NVL(p.real_cost, 0)
            WHERE p.id_project = v_project_ids(i);

        END LOOP;
    END AFTER STATEMENT;
END TRG_UPDATE_PROJECT_BUDGET;
/

SELECT 
    p.name_project AS "Project",
    t.title AS "Task",
    m.name_team_member AS "Team Member",
    tr.task_type AS "Task Type",
    t.duration AS "Days",
    t.estimated_hours AS "Est. Hours",
    t.actual_hours AS "Actual Hours",
    tr.hourly_rate AS "Rate/Hour (EUR)",
    p.fixed_cost AS "Project Fixed Cost",
    (t.estimated_hours * tr.hourly_rate) AS "Estimated Cost (EUR)",
    (t.actual_hours * tr.hourly_rate) AS "Actual Cost (EUR)"
FROM TASKS t
JOIN PROJECTS p ON t.id_project = p.id_project
JOIN TEAM_MEMBERS m ON t.id_member = m.id_member
JOIN TASK_RATES tr ON t.id_rate = tr.id_rate;




--pt calcul zile lucratoare
DECLARE
    v_start DATE := TO_DATE(:START_DATE, 'DD-MM-YYYY'); 
    v_end   DATE := TO_DATE(:END_DATE, 'DD-MM-YYYY');
    v_days  NUMBER := 0;
BEGIN
    IF v_start IS NOT NULL AND v_end IS NOT NULL AND v_start <= v_end THEN
        SELECT COUNT(*)
        INTO v_days
        FROM (
            -- Aceasta genereză un rând pentru fiecare zi dintre Start și End
            SELECT v_start + LEVEL - 1 AS data_curenta
            FROM dual
            CONNECT BY LEVEL <= (v_end - v_start + 1)
        )
        WHERE TO_CHAR(data_curenta, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT', 'SUN')
          AND data_curenta NOT IN (SELECT holiday_date FROM HOLIDAYS_RO);
    END IF;
    
    :DURATION := v_days;
    :ESTIMATED_HOURS := v_days * 8;
    
EXCEPTION
    WHEN OTHERS THEN
        :DURATION := 0;
        :ESTIMATED_HOURS := 0;
END;