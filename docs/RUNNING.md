# Running Smart Boys' Fashion locally

Prerequisites
- Java 17 installed and on PATH (`java -version`).
- Apache Tomcat (recommended) installed. Note its installation folder (e.g. `C:\tomcat`).
- (Optional) Apache Maven installed and on PATH (`mvn -version`). If not present the script will assemble a WAR from compiled classes if available.

Quick steps

1. Build the project (preferred with Maven):

```powershell
cd "C:\Users\dinusha dilshan\Desktop\smart-boys-fashion\smart-boys-fashion"
mvn clean package
```

2. Deploy to Tomcat:

Copy the generated WAR from `target\` into Tomcat's `webapps` folder, then start Tomcat:

```powershell
Copy-Item .\target\*.war C:\tomcat\webapps\ -Force
& C:\tomcat\bin\startup.bat
```

3. If you don't have Maven: use the helper script `scripts\deploy_to_tomcat.ps1` (below) which will try to assemble a WAR from the project files and deploy it.

Helper script usage

```powershell
# provide Tomcat path explicitly:
.\scripts\deploy_to_tomcat.ps1 -TomcatPath "C:\tomcat"

# or rely on CATALINA_HOME if set:
.\scripts\deploy_to_tomcat.ps1
```

Database
- Create a MySQL database and run `database/schema.sql`.
- Update DB credentials in `src/main/java/com/smartboys/dao/DBConnection.java` before starting Tomcat.

If you want, I can try to deploy the WAR for you here — tell me the local Tomcat path, or install Maven/Tomcat and I will run the script.
