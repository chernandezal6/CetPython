using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201611030218)]
    public class _201611030218_alter_table_sre_empleadores_t : FluentMigrator.Migration
    {        
        public override void Up()
        {
            if (!Schema.Table("SRE_EMPLEADORES_T").Column("SOLICITUD_NSS_AUT").Exists())
            {
                Alter.Table("SRE_EMPLEADORES_T")
                    .AddColumn("SOLICITUD_NSS_AUT")
                    .AsCustom("CHAR(1)")
                    .WithColumnDescription("CREA SOLICITUD DE NSS AUTOMATICA PARA CEDULA")
                    .WithDefaultValue("S");

                Execute.Sql("alter table SRE_EMPLEADORES_T  add constraint CKC_SOLICITUD_NSS_AUT  check(SOLICITUD_NSS_AUT IN('S', 'N'))");
            }            
        }

        public override void Down()
        {
            if (Schema.Table("SRE_EMPLEADORES_T").Column("SOLICITUD_NSS_AUT").Exists())
            {
            
            }
        }
        
    }
}
