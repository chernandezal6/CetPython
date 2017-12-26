using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030246)]
    public class _201603030246_create_table_sre_tipo_nss_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_TIPO_NSS_T").Exists())
            {
                Create.Table("SRE_TIPO_NSS_T")
                    .WithColumn("ID_TIPO_NSS").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y id del tipo de nss.")
                    .WithColumn("Descripcion").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción del tipo de NSS.")
                    .WithColumn("COTIZA_SDSS").AsCustom("CHAR(1)").Nullable().WithDefaultValue("N").WithColumnDescription("S=SI, N= NO")
                    .WithColumn("COTIZA_DGII").AsCustom("CHAR(1)").Nullable().WithDefaultValue("N").WithColumnDescription("S=SI, N= NO")
                    .WithColumn("COTIZA_INFOTEP").AsCustom("CHAR(1)").Nullable().WithDefaultValue("N").WithColumnDescription("S=SI, N= NO");
                
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_TIPO_NSS_T").Exists())
            {
                Delete.Table("SRE_TIPO_NSS_T");
            }

        }

    }
}
