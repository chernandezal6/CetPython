using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;


namespace DatabaseMigrations.Migrations
{
    [Migration(201603180312)]
    public class _201603180312_create_table_nss_evaluacion_visual_t : FluentMigrator.Migration
    {
        public override void Up()
        {            
            if (!Schema.Table("NSS_EVALUACION_VISUAL_T").Exists())
            {
                Create.Table("NSS_EVALUACION_VISUAL_T")
                    .WithColumn("ID_EVALUACION").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y Id de los casos de Evaluación Visual. SEQUENCE")
                    .WithColumn("ID_REGISTRO").AsInt32().Nullable().WithColumnDescription("Id del detalle de la tabla solicitudes de Asignación NSS. – FK de la tabla NSS_det_solicitudes_T.")
                    .WithColumn("FECHA_REGISTRO").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha que especifica cuando fue remitido a evaluación visual.")
                    .WithColumn("FECHA_RESPUESTA").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de respuesta de la evaluación viaual.")
                    .WithColumn("ESTATUS").AsCustom("VARCHAR2(2)").Nullable().WithColumnDescription("Estatus de la solicitud: PE=Pendiente, CO=COMPLETADA.")
                    .WithColumn("USUARIO_PROCESA").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que procesa la evaluación visual.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro. FK de la tabla SEG_USUARIO_T");


                //Foreign_key a la tabla NSS_TIPO_SOLICITUDES_T
                Create.ForeignKey("FK_NSS_EV_TO_DET_SOL")
                    .FromTable("NSS_EVALUACION_VISUAL_T").ForeignColumn("ID_REGISTRO")
                    .ToTable("NSS_DET_SOLICITUDES_T").PrimaryColumn("ID_REGISTRO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_EVA_USU_ACT")
                    .FromTable("NSS_EVALUACION_VISUAL_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("NSS_EVALUACION_VISUAL_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_EVALUACION_VISUAL_T").Exists())
            {
                Delete.Table("NSS_EVALUACION_VISUAL_T");
                Delete.Sequence("NSS_EVALUACION_VISUAL_T_SEQ");
            }
        }
    }
}
