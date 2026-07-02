
# **LUCRARE DE LICENȚĂ: Sistem informatic pentru managementul proiectelor utilizând tehnologia Oracle APEX**

*STUDENT: Andreea-Florentina Roșu*

*SPECIALIZAREA: Informatică*

*Anul: 2026*


## 1. Livrabilele proiectului:
* Codul sursă al aplicației: Roșu_Andreea-Florentina_Informatică_Licență.sql
* Scripturile SQL pentru structura bazei de date:
    * `Schema_PM.sql`
    * `Triggers_PM.sql`
    * `Date_PM.sql`

## 2. Adresa repository-ului
https://github.com/98andreea/Backup-Licenta

## 3. Pașii de compilare ai aplicației:
Aplicația utilizează **`Oracle Database Free`** (succesorul ediției Oracle Express), care include nativ platforma **Oracle APEX**. Această configurație permite rularea gratuită a întregului sistem pe un calculator local, fără costuri suplimentare de licențiere.

* **Bază de date:** Oracle Database Free
* **Platformă dezvoltare:** Oracle APEX
* **Compilare:** Nu este necesară o compilare tradițională. Logica PL/SQL este interpretată direct de baza de date la momentul execuției scripturilor.

## 4. Pașii de instalare și lansare a aplicației

### 4.1. Configurarea inițială a mediului APEX
* Instalați **Oracle Database Free** local.
* Accesați interfața de administrare (APEX Administration Services).
* Creați un **Workspace** nou și un cont de **Administrator**. Aceste credențiale vor fi necesare pentru accesarea mediului de dezvoltare (SQL Workshop și App Builder).

### 4.2. Configurarea Bazei de Date
* Accesați **SQL Workshop** folosind credențialele Workspace-ului creat anterior.
* Mergeți la **SQL Scripts** și încărcați fișierele în următoarea ordine: `Schema_PM.sql`, apoi `Triggers_PM.sql` și la final `Date_PM.sql`.
* Executați scripturile (`Run`) pentru a crea structura tabelelor și a obiectelor PL/SQL (triggere și funcții) necesare bazei de date.

### 4.3. Importul aplicației
* Accesați **App Builder** în mediul APEX.
* Selectați **Import** și încărcați fișierul `Roșu_Andreea-Florentina_Informatică_Licență.sql`.
* Urmați pașii din `Import Wizard` utilizând setările implicite până la finalizarea instalării.

### 4.4. Lansarea aplicației
* După instalare, selectați aplicația din **App Builder**.
* Apăsați butonul **Run Application** din colțul dreapta sus pentru a accesa interfața grafică a sistemului.
