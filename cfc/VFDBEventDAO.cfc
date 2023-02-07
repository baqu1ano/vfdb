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
                        event_id,distance,capacity,cost1
                    ) VALUES (
                        :event_id,:distance,:capacity,:cost1
                    )
                ",{
                    event_id=ret.id,
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
                effort = obj.modes[i].real_distance + 0.1 * obj.modes[i].ascent;
            } else if (obj.modes[i].distance GT 0) {
                effort = obj.modes[i].distance + 0.1 * obj.modes[i].ascent;
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
}

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