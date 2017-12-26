using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201603030242)]
    public class _201603030242_create_table_nss_estatus_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_ESTATUS_T").Exists())
            {
                Create.Table("NSS_ESTATUS_T")
                    .WithColumn("ID_ESTATUS").AsCustom("NUMBER(2)").NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("Descripcion").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción del estatus.");
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ESTATUS_T").Exists())
            {
                Delete.Table("NSS_ESTATUS_T");
            }
        }

    }
}
