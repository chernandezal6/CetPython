using System;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201702140424)]
    public class _201702140424_add_numero_evento_to_nss_det_solicitudes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_DET_SOLICITUDES_T").Column("NUMERO_EVENTO").Exists())
            {
                Alter.Table("NSS_DET_SOLICITUDES_T")
                    .AddColumn("NUMERO_EVENTO")
                    .AsCustom("VARCHAR2(50)")
                    .WithColumnDescription("Número del evento de nacimiento")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Column("NUMERO_EVENTO").Exists())
            {
            }
        }       
    }
}
