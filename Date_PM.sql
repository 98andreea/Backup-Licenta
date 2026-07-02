----- DATE
---- PROJECTS
---Licență 2026
--Roșu Andreea-Florentina

-- PROJECTS
INSERT INTO PROJECTS (name_project, description_project, star_date, end_date, fixed_cost, allocated_budget) 
VALUES ('Automatizare SAP', 'Automatizarea proceselor de creare conturi in baza de date SAP.', TO_DATE('01-02-2026', 'DD-MM-YYYY'), TO_DATE('30-06-2026', 'DD-MM-YYYY'), 5000, 15000);

INSERT INTO PROJECTS (name_project, description_project, star_date, end_date, fixed_cost, allocated_budget) 
VALUES ('Gestiune Medicala', 'Aplicatie pentru gestionarea stocurilor si reactivilor in spitale.', TO_DATE('01-04-2026', 'DD-MM-YYYY'), TO_DATE('15-10-2026', 'DD-MM-YYYY'), 8000, 25000);

INSERT INTO PROJECTS (name_project, description_project, star_date, end_date, fixed_cost, allocated_budget) 
VALUES ('Aplicatie Fitness', 'Aplicatie mobila cu programe personalizate si nutritie.', TO_DATE('01-07-2026', 'DD-MM-YYYY'), TO_DATE('15-12-2026', 'DD-MM-YYYY'), 3000, 12000);

-- TEAM MEMBERS
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('COL_TIM', 'Crisan Oleg', 'Analist Business', 25);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('MAC_TIM', 'Maxim Aaron Cezar', 'Designer UI/UX', 20);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('RAF_BUC', 'Rusu Andrei Florian', 'Software Developer', 30);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('IAC_BUC', 'Ion Andrei Cristian', 'Software Developer', 28);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('TAF_BUC', 'Tataru Albert', 'System Engineer', 26);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('ROB_TIM', 'Robert Oana', 'QA Engineer', 18);
INSERT INTO TEAM_MEMBERS (id_member, name_team_member, role_member, hourly_rate) VALUES('CAL_TIM', 'Calin Alin', 'Project Manager', 35);

-- TASK_RATES
INSERT INTO TASK_RATES(task_type, hourly_rate) VALUES ('Proiectare', 25);
INSERT INTO TASK_RATES(task_type, hourly_rate) VALUES ('Implementare', 18);
INSERT INTO TASK_RATES(task_type, hourly_rate) VALUES ('Testare', 12);

-- TASKS
-- PROJECT 1
INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(1, 1, 'COL_TIM', 'Proiectare flux SAP', 'Analiza campurilor necesare pentru automatizare', TO_DATE('02-02-2026', 'DD-MM-YYYY'), TO_DATE('27-02-2026', 'DD-MM-YYYY'), 80, 'High', 'Completed', NULL);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(1, 2, 'RAF_BUC', 'Implementare Agent Screen', 'Conectarea formularului la DB', TO_DATE('02-03-2026', 'DD-MM-YYYY'), TO_DATE('30-04-2026', 'DD-MM-YYYY'), 160, 'High', 'In Progress', 1);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(1, 3, 'ROB_TIM', 'Testare conexiune SAP', 'Verificarea scripturilor de automatizare', TO_DATE('04-05-2026', 'DD-MM-YYYY'), TO_DATE('22-05-2026', 'DD-MM-YYYY'), 40, 'High', 'Pending', 2);

-- PROJECT 2
INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(2, 1, 'TAF_BUC', 'Proiectare structura DB', 'Definirea tabelelor pentru reactivi', TO_DATE('01-04-2026', 'DD-MM-YYYY'), TO_DATE('24-04-2026', 'DD-MM-YYYY'), 60, 'Medium', 'Completed', NULL);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(2, 2, 'IAC_BUC', 'Implementare modul inventar', 'Dezvoltarea codului pentru evidenta', TO_DATE('27-04-2026', 'DD-MM-YYYY'), TO_DATE('30-06-2026', 'DD-MM-YYYY'), 120, 'High', 'Pending', 4);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(2, 3, 'ROB_TIM', 'Testare functionalitate stoc', 'Simulare praguri minime', TO_DATE('01-07-2026', 'DD-MM-YYYY'), TO_DATE('20-07-2026', 'DD-MM-YYYY'), 40, 'Medium', 'Pending', 5);

-- PROJECT 3
INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(3, 1, 'MAC_TIM', 'Proiectare Interfata Mobila', 'Creare wireframes pentru aplicatie', TO_DATE('01-07-2026', 'DD-MM-YYYY'), TO_DATE('31-07-2026', 'DD-MM-YYYY'), 80, 'Low', 'Pending', NULL);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(3, 2, 'RAF_BUC', 'Implementare Backend', 'Dezvoltarea bazei de date si a API-urilor', TO_DATE('03-08-2026', 'DD-MM-YYYY'), TO_DATE('30-10-2026', 'DD-MM-YYYY'), 200, 'High', 'Pending', 7);

INSERT INTO TASKS (id_project, id_rate, id_member, title, description_task, start_date_task, end_date_task, estimated_hours, priority_task, status_task, id_predecessor) 
VALUES(3, 3, 'ROB_TIM', 'Testare iOS si Android', 'Verificare pe device-uri', TO_DATE('02-11-2026', 'DD-MM-YYYY'), TO_DATE('20-11-2026', 'DD-MM-YYYY'), 50, 'High', 'Pending', 8);

-- TEAM_PROJECTS
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('COL_TIM', 1);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('RAF_BUC', 1);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('ROB_TIM', 1);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('IAC_BUC', 2);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('TAF_BUC', 2);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('CAL_TIM', 2);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('MAC_TIM', 3);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('RAF_BUC', 3);
INSERT INTO TEAM_PROJECTS (id_member, id_project) VALUES('ROB_TIM', 3);

-- COMMENTS
INSERT INTO COMMENTS (id_project, id_member, comment_text) VALUES(1, 'COL_TIM', 'Analiza campurilor a fost finalizata. Putem incepe dezvoltarea.');
INSERT INTO COMMENTS (id_project, id_member, comment_text) VALUES(1, 'RAF_BUC', 'Am intampinat probleme la conexiunea cu serverul de test SAP.');
INSERT INTO COMMENTS (id_project, id_member, comment_text) VALUES(2, 'CAL_TIM', 'Asteptam confirmarea listei de reactivi de la unitatea medicala.');
INSERT INTO COMMENTS (id_project, id_member, comment_text) VALUES(3, 'MAC_TIM', 'Interfata pentru mobil este gata de review.');

-- HOLIDAYS_RO
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('01-01-2026', 'DD-MM-YYYY'), 'Anul Nou');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('02-01-2026', 'DD-MM-YYYY'), 'Anul Nou');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('06-01-2026', 'DD-MM-YYYY'), 'Boboteaza');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('07-01-2026', 'DD-MM-YYYY'), 'Sfantul Ioan Botezatorul');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('24-01-2026', 'DD-MM-YYYY'), 'Ziua Unirii Principatelor Române');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('10-04-2026', 'DD-MM-YYYY'), 'Paște ortodox 2026');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('13-04-2026', 'DD-MM-YYYY'), 'Paște ortodox 2026');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('01-05-2026', 'DD-MM-YYYY'), 'Ziua Muncii');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('31-05-2026', 'DD-MM-YYYY'), 'Rusalii');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('01-06-2026', 'DD-MM-YYYY'), 'Ziua Copilului');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('15-08-2026', 'DD-MM-YYYY'), 'Adormirea Maicii Domnului');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('30-11-2026', 'DD-MM-YYYY'), 'Sfântul Andrei');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('01-12-2026', 'DD-MM-YYYY'), 'Ziua Națională a României');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('25-12-2026', 'DD-MM-YYYY'), 'Crăciunul');
INSERT INTO HOLIDAYS_RO(holiday_date, holiday_name) VALUES(TO_DATE('26-12-2026', 'DD-MM-YYYY'), 'Crăciunul');