using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071148)]
    public class _201603071148_add_fecha_fallecimiento_and_tipo_NSS_to_sre_ciudadanos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_CIUDADANOS_T").Column("ID_TIPO_NSS").Exists())
            {
                Alter.Table("SRE_CIUDADANOS_T")
                    .AddColumn("ID_TIPO_NSS")
                    .AsInt32()
                    .WithColumnDescription("Id Tipo de NSS que tiene asignado una persona.")
                    .Nullable();

                //Se necesita incluir el foreign_key a la tabla sre_tipo_documentos_t 
                Create.ForeignKey("FK_CIUDADANOS_TIPO_NSS")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("ID_TIPO_NSS")
                    .ToTable("SRE_TIPO_NSS_T").PrimaryColumn("ID_TIPO_NSS");
            }

            if (!Schema.Table("SRE_CIUDADANOS_T").Column("FECHA_FALLECIMIENTO").Exists())
            {
                Alter.Table("SRE_CIUDADANOS_T")
                    .AddColumn("FECHA_FALLECIMIENTO")
                    .AsCustom("DATE")
                    .WithColumnDescription("Fecha fallecimiento de la persona.")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_CIUDADANOS_T").Column("ID_TIPO_NSS").Exists())
                {
                    Delete.ForeignKey("FK_CIUDADANOS_TIPO_NSS").OnTable("SRE_CIUDADANOS_T");
                    Delete.Column("ID_TIPO_NSS").FromTable("SRE_CIUDADANOS_T");                    
                }
                if (Schema.Table("SRE_CIUDADANOS_T").Column("FECHA_FALLECIMIENTO").Exists())
                {
                    Delete.Column("FECHA_FALLECIMIENTO").FromTable("SRE_CIUDADANOS_T");
                }
        }
    }
}
