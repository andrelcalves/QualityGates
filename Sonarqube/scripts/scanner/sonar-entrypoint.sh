#!/bin/sh

#dotnet clean
rm -rf bin obj .sonarqube

dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=coveragereport.opencover.xml
dotnet ${SONAR_BIN_DIR}/sonar-scanner/SonarScanner.MSBuild.dll begin /k:${PROJECT_KEY} /n:"${PROJECT_NAME}" /v:${PROJECT_VERSION} /d:sonar.host.url=${SONAR_URL} /d:sonar.login=${SONAR_TOKEN} /d:sonar.cs.opencover.reportsPaths="test/coveragereport.opencover.xml"
dotnet build
dotnet ${SONAR_BIN_DIR}/sonar-scanner/SonarScanner.MSBuild.dll end /d:sonar.login=${SONAR_TOKEN}