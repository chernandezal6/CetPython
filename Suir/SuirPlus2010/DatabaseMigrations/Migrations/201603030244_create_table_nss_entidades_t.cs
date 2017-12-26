using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030244)]
    public class _201603030244_create_table_nss_entidades_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_ENTIDADES_T").Exists())
            {
                Create.Table("NSS_ENTIDADES_T")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(2)").NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y id de la entidad.")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción de la entidad.");
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ENTIDADES_T").Exists())
            {
                Delete.Table("NSS_ENTIDADES_T");
            }

        }
    }
}
