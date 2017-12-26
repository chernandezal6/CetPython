using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603140220)]
    public class _201603140220_create_table_nss_tipo_solicitudes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_TIPO_SOLICITUDES_T").Exists())
            {
                Create.Table("NSS_TIPO_SOLICITUDES_T")
                    .WithColumn("ID_TIPO").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y id del tipo de solicitud.")
                    .WithColumn("CODIGO").AsCustom("VARCHAR2(3)").NotNullable().WithColumnDescription("Código de identificación del tipo de solicitud.")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción del tipo de solicitud.");
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_TIPO_SOLICITUDES_T").Exists())
            {
                Delete.Table("NSS_TIPO_SOLICITUDES_T");
            }

        }
    }
}

