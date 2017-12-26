using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708311500)]
    public class _201708311500_update_ars_catalogo_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_CATALOGO_T").Exists())
            {               
                Update.Table("SUIRPLUS.ARS_CATALOGO_T").Set(new { ID_ENTIDAD_RECAUDADORA = 73, ULT_FECHA_ACT = DateTime.Now }).Where(new { ID_ARS  = 1 });
                Update.Table("SUIRPLUS.ARS_CATALOGO_T").Set(new { ID_ENTIDAD_RECAUDADORA = 74, ULT_FECHA_ACT = DateTime.Now }).Where(new { ID_ARS = 52 });
            }

        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_CATALOGO_T").Exists())
            {
                Update.Table("SUIRPLUS.ARS_CATALOGO_T").Set(new { ID_ENTIDAD_RECAUDADORA = System.DBNull.Value, ULT_FECHA_ACT = DateTime.Now }).Where(new { ID_ARS = 1 });
                Update.Table("SUIRPLUS.ARS_CATALOGO_T").Set(new { ID_ENTIDAD_RECAUDADORA = System.DBNull.Value, ULT_FECHA_ACT = DateTime.Now }).Where(new { ID_ARS = 52 });
            }
        }
    }
}
