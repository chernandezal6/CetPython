using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030245)]
    public class _201603030245_create_table_sre_tipo_documentos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                Create.Table("SRE_TIPO_DOCUMENTOS_T")
                    .WithColumn("ID_TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").PrimaryKey().NotNullable().WithColumnDescription("Representa el tipo de documento de la persona.")
                    .WithColumn("USO_CIUDADANO").AsCustom("VARCHAR2(1)").NotNullable().WithColumnDescription("Se utiliza en ciudadanos(S/N).")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(50)").NotNullable().WithColumnDescription("Descripción del tipo de documento.")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(2)").NotNullable().WithColumnDescription("Id de la entidad que emite el documento. FK de la tabla NSS_ENTIDADES_T")
                    .WithColumn("MASCARA").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("Mascara para formatear la entrada de dato por pantalla")
                    .WithColumn("VALIDACION_MAYORIA_EDAD").AsCustom("CHAR(1)").Nullable().WithColumnDescription("Para saber si la fecha de nacimiento debe validarse como mayor de 18 años y rechazar la solicitud. S=SI, N=NO");

                //Se necesita incluir el foreign_key a la tabla NSS_entidades_t 
                Create.ForeignKey("FK_TIPO_DOCS_ENTIDADES")
                    .FromTable("SRE_TIPO_DOCUMENTOS_T").ForeignColumn("ID_ENTIDAD")
                    .ToTable("NSS_ENTIDADES_T").PrimaryColumn("ID_ENTIDAD");
            }

        }

        public override void Down()
        {
            if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                Delete.Table("SRE_TIPO_DOCUMENTOS_T");
            }

        }

    }
}
