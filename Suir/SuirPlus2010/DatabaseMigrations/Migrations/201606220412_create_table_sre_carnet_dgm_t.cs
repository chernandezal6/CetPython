using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201606220412)]
    public class _201606220412_create_table_sre_carnet_dgm_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_CARNET_DGM_T").Exists())
            {
                Create.Table("SRE_CARNET_DGM_T")
                    .WithColumn("Id").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("Descripcion").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción del carnet de la Direccion General de Migracion.");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_CARNET_DGM_T").Exists())
            {
                Delete.Table("SRE_CARNET_DGM_T");
            }
        }

    }
}
