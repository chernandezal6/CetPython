using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201603140226)]
    public class _201603140226_create_table_nss_det_solicitudes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_DET_SOLICITUDES_T").Exists())
            {
                Create.Table("NSS_DET_SOLICITUDES_T")
                    .WithColumn("ID_REGISTRO").AsCustom("NUMBER(10)").NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("ID_SOLICITUD").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Id de la solicitud de asignacion de NSS. FK de la tabla NSS_SOLICITUDES_T.")
                    .WithColumn("SECUENCIA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Secuencia del detalle de la solicitud.")
                    .WithColumn("ID_TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").NotNullable().WithColumnDescription("Tipo de documento de la solicitud. FK de la tabla SRE_TIPO_DOCUMENTOS_T")
                    .WithColumn("NO_DOCUMENTO_SOL").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("Numero de documento de la solicitud.")
                    .WithColumn("ID_ESTATUS").AsCustom("NUMBER(2)").NotNullable().WithDefaultValue(1).WithColumnDescription("Estatus de la solicitud. FK de la tabla NSS_ESTATUS_T")
                    .WithColumn("ID_ERROR").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Id de error. FK de la tabla SEG_ERROR_T")
                    .WithColumn("NOMBRES").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Nombres de la persona.")
                    .WithColumn("PRIMER_APELLIDO").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Primer apellido de la persona.")
                    .WithColumn("SEGUNDO_APELLIDO").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Segundo apellido de la persona.")
                    .WithColumn("FECHA_NACIMIENTO").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de nacimiento de la persona.")
                    .WithColumn("SEXO").AsCustom("CHAR(1)").Nullable().WithColumnDescription("Sexo de la persona, M=Masculino, F=Femenino")
                    .WithColumn("ID_NACIONALIDAD").AsCustom("VARCHAR2(3)").Nullable().WithColumnDescription("Representa la nacionaliad de la persona, FK de la tabla sre_nacionaliad_t")
                    .WithColumn("MUNICIPIO_ACTA").AsCustom("VARCHAR2(6)").Nullable().WithColumnDescription("Id del municipio del acta de nacimiento del ciudadano.")
                    .WithColumn("ANO_ACTA").AsCustom("VARCHAR2(4)").Nullable().WithColumnDescription("Año del acta de nacimiento del ciudadano.")
                    .WithColumn("NUMERO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Número del acta de nacimiento del ciudadano.")
                    .WithColumn("FOLIO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificación del Folio del acta de nacimiento del ciudadano.")
                    .WithColumn("LIBRO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificación del Libro del acta de nacimiento del ciudadano.")
                    .WithColumn("OFICIALIA_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificaion de la Oficialia del acta de nacimiento del ciudadano.")
                    .WithColumn("TIPO_LIBRO_ACTA").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Tipo del libro del acta")
                    .WithColumn("LITERAL_ACTA").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Literal del acta")
                    .WithColumn("ESTADO_CIVIL").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Estado civil")
                    .WithColumn("ID_TIPO_SANGRE").AsCustom("VARCHAR2(4)").Nullable().WithColumnDescription("ID de los tipos de sangres definidos en la table SRE_TIPO_SANCRE_T")
                    .WithColumn("CEDULA_MADRE").AsCustom("VARCHAR2(11)").Nullable().WithColumnDescription("Numero de identificacion de la Madre del ciudadano")
                    .WithColumn("CEDULA_PADRE").AsCustom("VARCHAR2(11)").Nullable().WithColumnDescription("Numero de identificacion del Padre del ciudadano")
                    .WithColumn("NOMBRE_MADRE").AsCustom("VARCHAR2(150)").Nullable().WithColumnDescription("Nombre de la madre")
                    .WithColumn("NOMBRE_PADRE").AsCustom("VARCHAR2(150)").Nullable().WithColumnDescription("Nombre del padre")
                    .WithColumn("TIPO_CAUSA").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Tipo causa cancelación o inhabilidad")
                    .WithColumn("ID_CAUSA_INHABILIDAD").AsCustom("NUMBER(6)").Nullable().WithColumnDescription("ID de la causa de inhabilidad")
                    .WithColumn("FECHA_CANCELACION_JCE").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de cancelacion del documento en JCE")
                    .WithColumn("ESTATUS_JCE").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Estatus de la cedula en la JCE")
                    .WithColumn("IMAGEN_SOLICITUD").AsCustom("BLOB").Nullable().WithColumnDescription("Imagen de la solicitud.")
                    .WithColumn("IMAGEN_ACTA_DEFUNCION").AsCustom("BLOB").Nullable().WithColumnDescription("Imagen del acta de defunción.")
                    .WithColumn("COMENTARIO").AsCustom("VARCHAR2(250)").Nullable().WithColumnDescription("Comentario relacionado al registro.")
                    .WithColumn("EXTRANJERO").AsCustom("CHAR(1)").Nullable().WithColumnDescription("S=SI, N=NO.")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("NSS del titular del solicitante. FK de la tabla SRE_CIUDADANOS_T")
                    .WithColumn("Id_PARENTESCO").AsCustom("VARCHAR2(2)").Nullable().WithColumnDescription("Parentesco del dependiente – FK de la tabla ARS_PARENTESCOS_T.")
                    .WithColumn("ID_ARS").AsCustom("VARCHAR2(4)").Nullable().WithColumnDescription("Id de la ars que solicita.")
                    .WithColumn("ID_NSS").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Id NSS asignado a la solicitud")
                    .WithColumn("ID_CONTROL").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Numero de control recibido - (viene de UNIPAGO)")
                    .WithColumn("NUM_CONTROL").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Numero de lote recibido - (viene de UNIPAGO)")
                    .WithColumn("ID_CERTIFICACION").AsCustom("NUMBER(9)").Nullable().WithColumnDescription("Id de certificacion generada para los extranjeros")                  
                    .WithColumn("USUARIO_PROCESA").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Representa el usuario que procesa la solicitud")
                    .WithColumn("FECHA_PROCESA").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de procesamiento de la solicitud.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro. FK de la tabla SEG_USUARIO_T");

                //Se necesita incluir el foreign_key a la tabla NSS_SOLICITUDES_T
                Create.ForeignKey("FK_NSS_DET_SOL_T_SOL")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_SOLICITUD")
                    .ToTable("NSS_SOLICITUDES_T").PrimaryColumn("ID_SOLICITUD");

                //Se necesita incluir el foreign_key a la tabla TIPO_DOCUMENTO_T
                Create.ForeignKey("FK_NSS_DET_SOL_TIPO_DOC")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_TIPO_DOCUMENTO")
                    .ToTable("SRE_TIPO_DOCUMENTOS_T").PrimaryColumn("ID_TIPO_DOCUMENTO");

                //Se necesita incluir el foreign_key a la tabla NSS_ESTATUS_T
                Create.ForeignKey("FK_NSS_DET_SOL_ESTATUS")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_ESTATUS")
                    .ToTable("NSS_ESTATUS_T").PrimaryColumn("ID_ESTATUS");

                Create.ForeignKey("FK_NSS_DET_SOL_NAC")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_NACIONALIDAD")
                    .ToTable("SRE_NACIONALIDAD_T").PrimaryColumn("ID_NACIONALIDAD");

                //Se necesita incluir el foreign_key a la tabla ARS_PARENTESCOS_T
                Create.ForeignKey("FK_NSS_DET_SOL_PARENTESCOS")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("Id_PARENTESCO")
                    .ToTable("ARS_PARENTESCOS_T").PrimaryColumn("Id_PARENTESCO");

                //Foreign_key a la tabla SRE_CIUDADANOS_T
                Create.ForeignKey("FK_DET_EV_T_CIU_NSS_T")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_NSS_TITULAR")
                    .ToTable("SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_DET_SOL_USU_PROCESA")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("USUARIO_PROCESA")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_DET_SOL_USU_ACT")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_DET_SOL_CER")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_CERTIFICACION")
                    .ToTable("CER_CERTIFICACIONES_T").PrimaryColumn("ID_CERTIFICACION");

                //Se necesita incluir el foreign_key a la tabla SEG_ERROR_T
                Create.ForeignKey("FK_NSS_DET_SOL_T_ERROR")
                    .FromTable("NSS_DET_SOLICITUDES_T").ForeignColumn("ID_ERROR")
                    .ToTable("SEG_ERROR_T").PrimaryColumn("ID_ERROR");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("NSS_DET_SOLICITUDES_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }

        }

        public override void Down()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Exists())
            {
                Delete.Table("NSS_DET_SOLICITUDES_T");
                Delete.Sequence("NSS_DET_SOLICITUDES_T_SEQ");
            }

        }
    }
}
