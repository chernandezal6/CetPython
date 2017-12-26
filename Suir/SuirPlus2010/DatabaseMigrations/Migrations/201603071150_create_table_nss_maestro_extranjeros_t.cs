using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071150)]
    public class _201603071150_create_table_nss_maestro_extranjeros_ : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_MAESTRO_EXTRANJEROS_T").Exists())
            {
                Create.Table("NSS_MAESTRO_EXTRANJEROS_T")
                    .WithColumn("ID_MAESTRO_EXTRANJERO").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("ID_EXPEDIENTE").AsCustom("VARCHAR2(25)").NotNullable().WithColumnDescription("Documento de identificación")
                    .WithColumn("ID_TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Tipo de documento de la solicitud. FK de la tabla SRE_TIPO_DOCUMENTOS_T")
                    .WithColumn("Nombres").AsCustom("VARCHAR2(150)").Nullable().WithColumnDescription("Nombres de la persona.")
                    .WithColumn("Primer_Apellido").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Primer apellido de la persona.")
                    .WithColumn("Segundo_Apellido").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Segundo apellido de la persona.")
                    .WithColumn("Fecha_nacimiento").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de nacimiento de la persona.")
                    .WithColumn("Sexo").AsCustom("CHAR(1)").Nullable().WithColumnDescription("Sexo de la persona, M=Masculino, F=Femenino")
                    .WithColumn("ID_NACIONALIDAD").AsCustom("VARCHAR2(3)").Nullable().WithColumnDescription("Representa la nacionaliad de la persona, FK de la tabla sre_nacionaliad_t")
                    .WithColumn("CEDULA").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("nro. de documento con el cual se inscribió la persona.")
                    .WithColumn("Tipo_permiso_residencia").AsCustom("VARCHAR2(3)").Nullable().WithColumnDescription("Tipo de permiso de residencia")
                    .WithColumn("Fecha_Expedicion").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de expedicióN del documento de la persona.")
                    .WithColumn("Fecha_Expiracion").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de expiración del documento de la persona.")
                    .WithColumn("ID_NSS").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Id NSS asignado a la solicitud");


                //Se necesita incluir el foreign_key a la tabla TIPO_DOCUMENTO_T
                Create.ForeignKey("FK_NSS_MAESTRO_EXT_TIPO_DOC")
                    .FromTable("NSS_MAESTRO_EXTRANJEROS_T").ForeignColumn("ID_TIPO_DOCUMENTO")
                    .ToTable("SRE_TIPO_DOCUMENTOS_T").PrimaryColumn("ID_TIPO_DOCUMENTO");

                Create.ForeignKey("FK_EXTRANJEROS_MIP_NAC")
                    .FromTable("NSS_MAESTRO_EXTRANJEROS_T").ForeignColumn("ID_NACIONALIDAD")
                    .ToTable("SRE_NACIONALIDAD_T").PrimaryColumn("ID_NACIONALIDAD");

                //Foreign_key a la tabla SRE_CIUDADANOS_T
                Create.ForeignKey("FK_DET_EV_TO_CIUDADANO")
                    .FromTable("NSS_MAESTRO_EXTRANJEROS_T").ForeignColumn("ID_NSS")
                    .ToTable("SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                Create.UniqueConstraint("UN_NSS_MAESTRO_EXTRANJEROS_T")
                    .OnTable("NSS_MAESTRO_EXTRANJEROS_T").Column("ID_EXPEDIENTE");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("NSS_MAESTRO_EXTRANJEROS_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }

        }

        public override void Down()
        {
            if (Schema.Table("NSS_MAESTRO_EXTRANJEROS_T").Exists())
            {
                Delete.Table("NSS_MAESTRO_EXTRANJEROS_T");
                Delete.Sequence("NSS_MAESTRO_EXTRANJEROS_T_SEQ");
            }

        }
    }
}
