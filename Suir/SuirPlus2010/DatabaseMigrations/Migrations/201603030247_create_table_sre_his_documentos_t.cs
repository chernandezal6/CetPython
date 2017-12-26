using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201603030247)]
    public class _201603030247_create_table_sre_his_documentos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_HIS_DOCUMENTOS_T").Exists())
            {
                Create.Table("SRE_HIS_DOCUMENTOS_T")
                    .WithColumn("Id").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("Id_NSS").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("ID que representa el Numero de Seguridad Social de la persona.")
                    .WithColumn("ID_TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").NotNullable().WithColumnDescription("Tipo de documento de identificación. FK de la tabla SRE_TIPO_DOCUMENTOS_T")
                    .WithColumn("NO_DOCUMENTO").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("Documento de identificación personal")
                    .WithColumn("Fecha_Emision").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de emisión del documento.")
                    .WithColumn("Fecha_Expiracion").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de expiración del documento.")
                    .WithColumn("ESTATUS").AsCustom("CHAR(1)").Nullable().WithColumnDescription("Estatus del documento: A=Activo, I=Inactivo , C=Cancelado")
                    .WithColumn("Municipio_Acta").AsCustom("VARCHAR2(6)").Nullable().WithColumnDescription("Id del municipio del acta de nacimiento del ciudadano.")
                    .WithColumn("Ano_Acta").AsCustom("VARCHAR2(4)").Nullable().WithColumnDescription("Año del acta de nacimiento del ciudadano.")
                    .WithColumn("Numero_Acta").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Número del acta de nacimiento del ciudadano.")
                    .WithColumn("Folio_Acta").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificación del Folio del acta de nacimiento del ciudadano.")
                    .WithColumn("Libro_Acta").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificación del Libro del acta de nacimiento del ciudadano.")
                    .WithColumn("Oficialia_Acta").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Identificaion de la Oficialia del acta de nacimiento del ciudadano.")
                    .WithColumn("Tipo_libro").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Tipo del libro del acta")
                    .WithColumn("Literal_acta").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Literal del acta")
                    .WithColumn("Imagen_Acta").AsCustom("BLOB").Nullable().WithColumnDescription("Imagen del acta de nacimiento del ciudadano.")
                    .WithColumn("Imagen_Acta_Defuncion").AsCustom("BLOB").Nullable().WithColumnDescription("Imagen del acta de defuncion de la persona fallecida.")
                    .WithColumn("Recepcion_Documento").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de cuando se recibio el documento.")
                    .WithColumn("Fecha_Efectividad").AsCustom("DATE").Nullable().WithColumnDescription("Fecha a partir de cuando es efectivo el documento.")
                    .WithColumn("REGISTRADO_POR").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Representa el usuario que realiza el registro")
                    .WithColumn("Fecha_Registro").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha en que se realizo el registro.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro. FK de la tabla SEG_USUARIO_T");


                //Se necesita incluir el foreign_key a la tabla SRE_CIUDADANOS_T
                Create.ForeignKey("FK_HIS_DOCUMENTOS_CIU")
                    .FromTable("SRE_HIS_DOCUMENTOS_T").ForeignColumn("ID_NSS")
                    .ToTable("SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Se necesita incluir el foreign_key a la tabla SRE_TIPO_DOCUMENTOS_T
                Create.ForeignKey("FK_HIS_DOCUMENTOS_TIPO_DOC")
                    .FromTable("SRE_HIS_DOCUMENTOS_T").ForeignColumn("ID_TIPO_DOCUMENTO")
                    .ToTable("SRE_TIPO_DOCUMENTOS_T").PrimaryColumn("ID_TIPO_DOCUMENTO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_HIS_DOCUMENTOS_USU")
                    .FromTable("SRE_HIS_DOCUMENTOS_T").ForeignColumn("REGISTRADO_POR")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_NSS_SOL_ULT_USUARIO")
                    .FromTable("SRE_HIS_DOCUMENTOS_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("SRE_HIS_DOCUMENTOS_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }

        }

        public override void Down()
        {
            if (Schema.Table("SRE_HIS_DOCUMENTOS_T").Exists())
            {
                Delete.Table("SRE_HIS_DOCUMENTOS_T");
                Delete.Sequence("SRE_HIS_DOCUMENTOS_T_SEQ");
            }

        }
    }
}
