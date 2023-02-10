component displayname="VFDBEventDAO" output="false" {

    public string function addEditEvent(required eventinfo) {
        var obj = deserializeJSON(eventinfo);
        var ret = {};
        
        chkqry = queryExecute(
            "
                SELECT id
                FROM event_list
                WHERE event_name = :ename
            ",{
                ename: obj.event_name
            },{
                datasource = session.vfdb_calcdb
            } 
        );

        if (chkqry.recordcount GT 0) {
            ret["id"] = chkqry.id;
            updqry = queryExecute(
                "
                    UPDATE event_list
                    SET event_date = :event_date,
                        event_name = :event_name,
                        event_type = :event_type,
                        event_edition = :event_edition,
                        event_description = :event_description,
                        event_page = :event_page,
                        organizer = :organizer,
                        site = :site
                    WHERE id = :retid
                ",{
                    event_date={value=obj.event_date,cfsqltype="cf_sql_timestamp"},
                    event_name={value=obj.event_name,cfsqltype="cf_sql_varchar"},
                    event_type={value=obj.event_type,cfsqltype="cf_sql_varchar"},
                    event_edition={value=obj.event_edition,cfsqltype="cf_sql_integer"},
                    event_description={value=obj.event_description,cfsqltype="cf_sql_varchar"},
                    event_page={value=obj.event_page,cfsqltype="cf_sql_longvarchar"},
                    organizer={value=obj.organizer,cfsqltype="cf_sql_integer"},
                    site={value=obj.site,cfsqltype="cf_sql_integer"},
                    retid={value=ret.id,cfsqltype="cf_sql_integer"}
                },{
                    datasource = session.vfdb_calcdb
                }
            );
        } else {
            //writeOutput(serializeJSON(obj));
            insqry = queryExecute(
                "
                    INSERT INTO event_list (
                        event_date,event_name,event_type,event_edition,event_description,event_page,
                        organizer,site
                    ) VALUES (
                        :event_date,:event_name,:event_type,:event_edition,:event_description,:event_page,
                        :organizer,:site
                    )
                ",{
                    event_date={value=obj.event_date,cfsqltype="cf_sql_timestamp"},
                    event_name={value=obj.event_name,cfsqltype="cf_sql_varchar"},
                    event_type={value=obj.event_type,cfsqltype="cf_sql_varchar"},
                    event_edition={value=obj.event_edition,cfsqltype="cf_sql_integer"},
                    event_description={value=obj.event_description,cfsqltype="cf_sql_varchar"},
                    event_page={value=obj.event_page,cfsqltype="cf_sql_longvarchar"},
                    organizer={value=obj.organizer,cfsqltype="cf_sql_integer"},
                    site={value=obj.site,cfsqltype="cf_sql_integer"}
                },{
                    datasource = session.vfdb_calcdb, result = "insqryresult"
                }
            );
            ret["id"] = insqryresult.generatedKey;
        }

        delgqry = queryExecute(
            "
                DELETE FROM geography
                WHERE mode_id IN (
                    SELECT id FROM mode_list
                    WHERE event_id = :retid
                )
            ",{
                retid = ret.id
            },{
                datasource = session.vfdb_calcdb
            }
        );
        delxqry = queryExecute(
            "
                DELETE FROM gpx_list
                WHERE mode_id IN (
                    SELECT id FROM mode_list
                    WHERE event_id = :retid
                )
            ",{
                retid = ret.id
            },{
                datasource = session.vfdb_calcdb
            }
        );       
        delmqry = queryExecute(
            "
                DELETE FROM mode_list
                WHERE event_id = :retid
            ",{
                retid = ret.id
            },{
                datasource = session.vfdb_calcdb
            }
        );


        for (i = 1; i LTE arrayLen(obj.modes); i++) {
            insmqry = queryExecute("
                    INSERT INTO mode_list (
                        event_id,mode_date,distance,capacity,cost1
                    ) VALUES (
                        :event_id,:mode_date,:distance,:capacity,:cost1
                    )
                ",{
                    event_id=ret.id,
                    mode_date={value=obj.modes[i].mode_date,cfsqltype="cf_sql_timestamp"},
                    distance=obj.modes[i].distance,
                    capacity=obj.modes[i].capacity,
                    cost1=obj.modes[i].cost
                },{
                    datasource = session.vfdb_calcdb, result = "insmqryresult"
                } 
            );
            modeid = insmqryresult.generatedKey;
            effort = 0;
            if (obj.modes[i].real_distance GT 0) {
                effort = obj.modes[i].real_distance + 0.01 * obj.modes[i].ascent;
            } else if (obj.modes[i].distance GT 0) {
                effort = obj.modes[i].distance + 0.01 * obj.modes[i].ascent;
            }
            
            insgqry = queryExecute("
                    INSERT INTO geography (
                        mode_id,distance,min_elevation,max_elevation,ascent,descent,
                        km_effort,route_link
                    ) VALUES (
                        :mode_id,:distance,:min_elevation,:max_elevation,:ascent,:descent,
                        :km_effort,:route_link
                    )
                ",{
                    mode_id={value=modeid,cfsqltype="cf_sql_integer"},
                    distance={value=obj.modes[i].real_distance,cfsqltype="cf_sql_float"},
                    min_elevation={value=obj.modes[i].min_elevation,cfsqltype="cf_sql_float"},
                    max_elevation={value=obj.modes[i].max_elevation,cfsqltype="cf_sql_float"},
                    ascent={value=obj.modes[i].ascent,cfsqltype="cf_sql_float"},
                    descent={value=obj.modes[i].descent,cfsqltype="cf_sql_float"},
                    km_effort={value=effort,cfsqltype="cf_sql_float"},
                    route_link={value=obj.modes[i].route_link,cfsqltype="cf_sql_longvarchar"}                    
                },{
                    datasource = session.vfdb_calcdb
                }
            );

            insxqry = queryExecute("
                    INSERT INTO gpx_list (
                        mode_id,gpx_text
                    ) VALUES (
                        :mode_id,:gpx_text
                    )
                ",{
                    mode_id={value=modeid,cfsqltype="cf_sql_integer"},
                    gpx_text={value=obj.modes[i].gpx_link,cfsqltype="cf_sql_longvarchar"}
                },{
                    datasource = session.vfdb_calcdb
                }
            );
        }

        return serializeJSON(ret);
    }

    public string function getEventData(required eventid) {
        var obj = deserializeJSON(eventid);
        var ret = {};
        
        qry = queryExecute("
                SELECT e.id,e.event_date,e.event_name,e.event_type,e.event_edition,
                    e.event_description,e.event_page,e.organizer,e.site,
                    o.org_name,s.site_name,s.site_mapurl
                FROM event_list e
                JOIN site_list s ON e.site = s.id
                JOIN organizer_list o ON e.organizer = o.id
                WHERE e.id = :eventid
            ",{
                eventid = {value=obj.id, cfsqltype="cf_sql_integer"}
            },{
                datasource = session.vfdb_calcdb
            }
        );
        if (qry.recordCount GT 0) {
            ret["id"] = qry.id;
            ret["event_date"] = dateTimeFormat(qry.event_date,"yyyy-mm-dd");
            ret["event_name"] = qry.event_name;
            ret["event_type"] = qry.event_type;
            ret["event_edition"] = qry.event_edition;
            ret["event_description"] = qry.event_description;
            ret["event_page"] = qry.event_page;
            ret["organizer"] = qry.organizer;
            ret["org_name"] = qry.org_name;            
            ret["site"] = qry.site;
            ret["site_name"] = qry.site_name;
        } else {
            ret["id"] = 0;
            return serializeJSON(ret);
        }

        modes = [];
        amode = {};
        mqry = queryExecute("
                SELECT m.id,m.mode_date,m.distance,m.capacity,m.cost1,
                    g.distance AS real_distance,g.min_elevation,g.max_elevation,
                    g.ascent,g.descent,g.km_effort,g.route_link
                FROM event_list e
                JOIN mode_list m ON m.event_id = e.id
                JOIN geography g ON m.id = g.mode_id
                WHERE e.id = :eventid
            ",{
                eventid = {value=obj.id, cfsqltype="cf_sql_integer"}
            },{
                datasource = session.vfdb_calcdb
            }
        );

        for (row in mqry) {
            amode = {};
            amode["mode_date"] = dateTimeFormat(row.mode_date,"yyyy-mm-dd");
            amode["mode_time"] = dateTimeFormat(row.mode_date,"HH:nn:ss");
            amode["distance"] = row.distance;
            amode["capacity"] = row.capacity;
            amode["cost1"] = row.cost1;
            amode["real_distance"] = row.real_distance;
            amode["min_elevation"] = row.min_elevation;
            amode["max_elevation"] = row.max_elevation;
            amode["ascent"] = row.ascent;
            amode["descent"] = row.descent;
            amode["km_effort"] = row.km_effort;
            amode["route_link"] = row.route_link;
            amode["gpx_link"] = "";

            xqry = queryExecute("
                    SELECT gpx_text
                    FROM gpx_list
                    WHERE mode_id = :modeid
                ",{
                    modeid = {value=row.id, cfsqltype="cf_sql_integer"}
                },{
                    datasource = session.vfdb_calcdb
                }
            );
            if (xqry.recordcount GT 0) {
                amode.gpx_link = xqry.gpx_text;
            }

            arrayAppend(modes, amode);
        }
        ret["modes"] = modes;

        return serializeJSON(ret);
    }
}

/*

CREATE TABLE mode_list (
  id INT UNSIGNED KEY AUTO_INCREMENT,
  event_id INT UNSIGNED,
  mode_date TIMESTAMP,
  distance FLOAT,
  capacity INT,
  participants INT,
  cost1 FLOAT,
  cost2 FLOAT,
  cost3 FLOAT,
  unit INT,
  CONSTRAINT fk_mo_event FOREIGN KEY (event_id) REFERENCES event_list (id)
);

CREATE TABLE geography (
  id INT UNSIGNED KEY AUTO_INCREMENT,
  mode_id INT UNSIGNED,
  grade VARCHAR(50),
  temperature FLOAT,
  humidity FLOAT,
  distance FLOAT,
  min_elevation FLOAT,
  max_elevation FLOAT,
  ascent FLOAT,
  descent FLOAT,
  km_effort FLOAT,
  route_link TEXT,
  CONSTRAINT fk_geo_mode FOREIGN KEY (mode_id) REFERENCES mode_list (id)
);

*/

/*
{
    "event_date": "2023-02-04 06:00:00",
    "event_name": "Un Buen Largo",
    "event_type": "Trail",
    "event_edition": 1,
    "event_description": "Scenic Mountain",
    "event_page": "",
    "organizer": 6,
    "site": 4,
    "modes": [
        {
            "mode_date": "2023-02-04 07:30",
            "distance": 14,
            "capacity": 200,
            "cost": 7,
            "real_distance": 15.109999999999999432,
            "min_elevation": 534,
            "max_elevation": 883,
            "ascent": 612,
            "descent": 612,
            "route_link": "",
            "gpx_link": ""
        },
        {
            "mode_date": "2023-02-04 07:30",
            "distance": 22,
            "capacity": 200,
            "cost": 7,
            "real_distance": 24.010000000000001563,
            "min_elevation": 534,
            "max_elevation": 883,
            "ascent": 717,
            "descent": 717,
            "route_link": "",
            "gpx_link": ""
        }
    ]
}
*/