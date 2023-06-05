# post logs to data dog log endpoint
curl -X POST "https://http-intake.logs.us5.datadoghq.com/api/v2/logs" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: c3d8b8bcae834ba11aa1a86186862d45" \
-d @- << EOF
{
  "ddsource": "workmbp",
  "ddtags": "env:dev,version:0.9",
  "hostname": "JRK Mac",
  "message": "2019-11-19T12:32:32,998 ERROR This is a test",
  "service": "apex",
  "username": "JRK",
  "status": "Error",
  "trigger.object": "Case",
  "trigger.class": "CaseServiceEscalations";
  "CPUTime": 15000
}
EOF

# post events to data dog event endpoint
curl -X POST "https://api.us5.datadoghq.com/api/v1/events" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: c3d8b8bcae834ba11aa1a86186862d45" \
-d @- << EOF
{
  "source_type_name": "workmbp",
  "tags": "env:dev,version:0.9",
  "title": "Apex Log",
  "text": "2019-11-19T12:32:32,998 INFO This is a test",
  "alert_type": "error",
  "host": "JRK Mac"
}
EOF

# api key validation
curl -X GET "https://api.us5.datadoghq.com/api/v1/validate" \
-H "Accept: application/json" \
-H "DD-API-KEY: c3d8b8bcae834ba11aa1a86186862d45"