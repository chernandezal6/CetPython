using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608310200)]
    public class _201608310200_add_automatica_to_cer_tipos_certificaciones_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("CER_TIPOS_CERTIFICACIONES_T").Column("AUTOMATICA").Exists())
            {
                Alter.Table("CER_TIPOS_CERTIFICACIONES_T")
                    .AddColumn("AUTOMATICA")
                    .AsCustom("CHAR(1)")
                    .WithColumnDescription("Generación de certificaciones completadas automáticamente (S / N).")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("CER_TIPOS_CERTIFICACIONES_T").Column("AUTOMATICA").Exists())
            {
                Delete.Column("AUTOMATICA").FromTable("CER_TIPOS_CERTIFICACIONES_T");
            }
        }

    }
}
