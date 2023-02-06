component displayname="VFDBSiteGateway" output="false" {

    public string function testFunction(required siteinfo) {
        return "queso";
    }

    public string function getSites(required snippet) {
        var obj = deserializeJSON(snippet);
        var ret = {};
        var sites = [];
        var s = {};

        qry = queryExecute(
            "
                SELECT id,site_name,site_address1,site_address2,site_city,
                    site_state,site_zipcode,site_country,site_description,
                    site_latitude,site_longitude,site_mapurl,site_area
                FROM site_list
                ORDER BY site_state,site_name
            ",{
                
            }, {
                datasource = session.vfdb_calcdb
            } 
        );

        for (row in qry) {
            s = {};
            s["id"] = row.id;
            s["site_name"] = row.site_name;
            s["site_address1"] = row.site_address1;
            s["site_address2"] = row.site_address2;
            s["site_city"] = row.site_city;
            s["site_state"] = row.site_state;
            s["site_zipcode"] = row.site_zipcode;
            s["site_country"] = row.site_country;
            s["site_description"] = row.site_description;
            s["site_latitude"] = row.site_latitude;
            s["site_longitude"] = row.site_longitude;
            s["site_mapurl"] = row.site_mapurl;
            s["site_area"] = row.site_area;
            arrayAppend(sites, s);
        }        
        ret["sites"] = sites;

        return serializeJSON(ret);        
    }

    public string function searchSites(required snippet) {
        var obj = deserializeJSON(snippet);
        var ret = {};
        var sites = [];
        var s = {};

        qry = queryExecute(
            "
                SELECT id,site_name,site_address1,site_address2,site_city,
                    site_state,site_zipcode,site_country,site_description,
                    site_latitude,site_longitude,site_mapurl,site_area
                FROM site_list
                WHERE site_name LIKE :snip
                OR site_description LIKE :snip
                ORDER BY site_state,site_name
            ",{
                snip: '%' & obj.snippet & '%'
            }, {
                datasource = session.vfdb_calcdb
            } 
        );

        for (row in qry) {
            s = {};
            s["id"] = row.id;
            s["site_name"] = row.site_name;
            s["site_address1"] = row.site_address1;
            s["site_address2"] = row.site_address2;
            s["site_city"] = row.site_city;
            s["site_state"] = row.site_state;
            s["site_zipcode"] = row.site_zipcode;
            s["site_country"] = row.site_country;
            s["site_description"] = row.site_description;
            s["site_latitude"] = row.site_latitude;
            s["site_longitude"] = row.site_longitude;
            s["site_mapurl"] = row.site_mapurl;
            s["site_area"] = row.site_area;
            arrayAppend(sites, s);
        }        
        ret["sites"] = sites;

        return serializeJSON(ret);
    }

}