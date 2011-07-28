# advertise couch via bonjour:
dns-sd -R couchdb _http._tcp local 5984

# load json document into db:
curl -X POST http://localhost:5984/dev/ -H "Content-Type: application/json" -d @apps.json

curl -X POST http://localhost:5984/dev/ -H "Content-Type: application/json" -d @DBGERLT2073%2F2011-03-02.json

