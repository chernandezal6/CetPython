using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{

    [Migration(201706200932)]
    public class _201706200932_add_id_entidad_recaudadora_to_ars_catalogo_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("ARS_CATALOGO_T").Column("ID_ENTIDAD_RECAUDADORA").Exists())
            {
                Alter.Table("SUIRPLUS.ARS_CATALOGO_T")
                    .AddColumn("ID_ENTIDAD_RECAUDADORA")
                    .AsCustom("NUMBER(2)")
                    .WithColumnDescription("ID de la entidad recaudadora.")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_CATALOGO_T").Column("ID_ENTIDAD_RECAUDADORA").Exists())
            {
                Delete.Column("ID_ENTIDAD_RECAUDADORA").FromTable("SUIRPLUS.ARS_CATALOGO_T");
            }

        }

    }

}