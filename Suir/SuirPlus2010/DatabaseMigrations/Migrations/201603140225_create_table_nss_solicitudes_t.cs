using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603140225)]
    public class _201603140225_create_table_nss_solicitudes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_SOLICITUDES_T").Exists())
            {
                Create.Table("NSS_SOLICITUDES_T")
                    .WithColumn("ID_SOLICITUD").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y Id de la solicitud.")
                    .WithColumn("ID_TIPO").AsInt32().NotNullable().WithColumnDescription("Id del tipo de solicitud. FK de la tabla NSS_TIPO_SOLICITUDES_T.")
                    .WithColumn("USUARIO_SOLICITA").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Representa el usuario que realiza la solicitud")
                    .WithColumn("FECHA_SOLICITUD").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha del registro de la solicitud.")
                    .WithColumn("ID_REGISTRO_PATRONAL").AsCustom("NUMBER(9)").Nullable().WithColumnDescription("Registgro patronal que solicita. FK de la tabla SRE_EMPLEADORES_T.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro. FK de la tabla SEG_USUARIO_T");

                //Se necesita incluir el foreign_key a la tabla NSS_TIPO_SOLICITUDES_T
                Create.ForeignKey("FK_NSS_SOL_NSS_TIPO_SOL")
                    .FromTable("NSS_SOLICITUDES_T").ForeignColumn("ID_TIPO")
                    .ToTable("NSS_TIPO_SOLICITUDES_T").PrimaryColumn("ID_TIPO");

                //Se necesita incluir el foreign_key a la tabla NSS_TIPO_SOLICITUDES_T
                Create.ForeignKey("FK_NSS_SOL_REG_PAT")
                    .FromTable("NSS_SOLICITUDES_T").ForeignColumn("ID_REGISTRO_PATRONAL")
                    .ToTable("SRE_EMPLEADORES_T").PrimaryColumn("ID_REGISTRO_PATRONAL");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_SOL_USU_SOL")
                    .FromTable("NSS_SOLICITUDES_T").ForeignColumn("USUARIO_SOLICITA")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_SOL_ULT_USUARIO_ACT")
                    .FromTable("NSS_SOLICITUDES_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("NSS_SOLICITUDES_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_SOLICITUDES_T").Exists())
            {
                Delete.Table("NSS_SOLICITUDES_T");
                Delete.Sequence("NSS_SOLICITUDES_T_SEQ");
            }
        }
    }
}

