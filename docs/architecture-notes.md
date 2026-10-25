# Architecture notes

## Relational entities

- **Clients**: organizations using the data center service.
- **Server_Zones**: physical/logical zones and their cooling configuration.
- **Server_Racks**: racks assigned to a zone and a client, including power draw.
- **Maintenance_Logs**: dated issues and maintenance actions for each rack.

## Relationships

- One client can own or use many server racks.
- One server zone can contain many server racks.
- One server rack can have many maintenance log entries.

## Planned NoSQL integration

Member 2 owns the telemetry document schema and MongoDB aggregation pipeline. The intended dashboard analysis is hourly average temperature by rack/zone. Coordinate exact field names with Member 2 before integrating backend queries.

## Report evidence checklist

- [ ] ER diagram
- [ ] relational schema and constraints
- [ ] screenshots of table creation and sample records
- [ ] INNER JOIN output
- [ ] nested subquery output
- [ ] stored procedure creation and successful CALL
- [ ] index explanation and query output
- [ ] final UI screenshots
- [ ] test cases and validation evidence
