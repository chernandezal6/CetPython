using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071149)]
     class _201603071149_create_fk_ciudadanos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_CIUDADANOS_T").Exists())
            {
                //Create.Table("SRE_CIUDADANOS_T")
                //    .WithColumn("ID_NSS").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("ID que representa el Numero de Seguridad Socia creado en la tabla SRE_CIUDADANO_T")
                //    .WithColumn("NOMBRES").AsCustom("VARCHAR2(50)").NotNullable().WithColumnDescription("Nombre del ciudadano, por lo genera es PRIMERO NOMBRE Y SEGUNDO")
                //    .WithColumn("PRIMER_APELLIDO").AsCustom("VARCHAR2(40)").NotNullable().WithColumnDescription("Campo que almacena el primer apellido del ciudadano")
                //    .WithColumn("SEGUNDO_APELLIDO").AsCustom("VARCHAR2(40)").Nullable().WithColumnDescription("Segundo apellido")
                //    .WithColumn("ESTADO_CIVIL").AsCustom("VARCHAR(1)").Nullable().WithColumnDescription("Estado civil")
                //    .WithColumn("FECHA_NACIMIENTO").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de nacimiento")
                //    .WithColumn("NO_DOCUMENTO").AsCustom("VARCHAR2(25)").NotNullable().WithColumnDescription("Numero del identificacion ( pasaporte, rnc, etc.)  requerido para los ciudadano extranjeros")
                //    .WithColumn("TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").ForeignKey().Nullable().WithColumnDescription("Tipo de documento puede ser cedula o pasaporte")
                //    .WithColumn("SEXO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Sexo")
                //    .WithColumn("ID_PROVINCIA").AsCustom("VARCHAR2(6)").ForeignKey().Nullable().WithColumnDescription("Identificador del las provincias definidas en la tabla SRE_PROVINCIA_T")
                //    .WithColumn("ID_TIPO_SANGRE").AsCustom("VARCHAR2(4)").ForeignKey().Nullable().WithColumnDescription("ID de los tipos de sangres definidos en la table SRE_TIPO_SANCRE_T")
                //    .WithColumn("ID_CAUSA_INHABILIDAD").AsInt32().ForeignKey("SRE_INHABILIDAD_JCE_T", "ID_CAUSA_INHABILIDAD").Nullable().WithColumnDescription("ID de la causa de inhabilidad")
                //    .WithColumn("TIPO_CAUSA").AsCustom("VARCHAR2(1)").ForeignKey("SRE_INHABILIDAD_JCE_T", "TIPO_CAUSA").Nullable().WithColumnDescription("Tipo causa cancelación ó inhabilidad")
                //    .WithColumn("ID_NACIONALIDAD").AsCustom("VARCHAR2(3)").ForeignKey().Nullable().WithColumnDescription("ID de las nacionalidades creada en la tabla SRE_NACIONALIDAD_T")
                //    .WithColumn("NOMBRE_PADRE").AsCustom("VARCHAR2(150)").Nullable().WithColumnDescription("Nombre del padre")
                //    .WithColumn("NOMBRE_MADRE").AsCustom("VARCHAR2(150)").Nullable().WithColumnDescription("Nombre de la madre")
                //    .WithColumn("FECHA_REGISTRO").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de registro")
                //    .WithColumn("MUNICIPIO_ACTA").AsCustom("VARCHAR2(6)").ForeignKey().Nullable().WithColumnDescription("ID de los municipios creados en la tabla SRE_MUNICIPIO_T")
                //    .WithColumn("ANO_ACTA").AsCustom("VARCHAR2(4)").Nullable().WithColumnDescription("A?o del acta de nacimiento")
                //    .WithColumn("NUMERO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Numero del acta de nacimiento del ciudadano")
                //    .WithColumn("FOLIO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Folio del acta de nacimiento")
                //    .WithColumn("LIBRO_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Numero del acta de nacimiento del ciudadano")
                //    .WithColumn("OFICIALIA_ACTA").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Numero de la oficialia civil")
                //    .WithColumn("CEDULA_ANTERIOR").AsCustom("VARCHAR2(11)").Nullable().WithColumnDescription("Cedula Anterior")
                //    .WithColumn("STATUS").AsCustom("CHAR(1)").Nullable().WithColumnDescription("Estatus de la cédula en la JCE")
                //    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualizacion del registro")
                //    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por ultima vez el registro")                    
                //    .WithColumn("FECHA_EXPEDICION").AsCustom("DATE").Nullable().WithColumnDescription("Fecha de expidición del documento")
                //    .WithColumn("COTIZACION").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Cotiza (S/N).")
                //    .WithColumn("SECUENCIA_SIPEN").AsInt32().Nullable().WithColumnDescription("Secuencia numerica para la Sipen")
                //    .WithColumn("IMAGEN_ACTA").AsCustom("BLOB").Nullable().WithColumnDescription("Imagen de la Acta de nacimiento")
                //    .WithColumn("TIPO_LIBRO_ACTA").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Tipo del libro de acta")
                //    .WithColumn("LITERAL_ACTA").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Literal del acta")
                //    .WithColumn("ID_TIPO_NSS").AsInt32().Nullable().WithColumnDescription("Id Tipo de NSS que tiene asignado una persona.")
                //    .WithColumn("FECHA_FALLECIMIENTO").AsCustom("DATE").Nullable().WithColumnDescription("Fecha fallecimiento de la persona.");

                //Se necesita incluir el foreign_key a la tabla SRE_TIPO_DOCUMENTOS_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_TIPO_DOC")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("TIPO_DOCUMENTO")
                    .ToTable("SRE_TIPO_DOCUMENTOS_T").PrimaryColumn("ID_TIPO_DOCUMENTO");

                //Se necesita incluir el foreign_key a la tabla SRE_TIPO_NSS_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_TIPO_NSS")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("ID_TIPO_NSS")
                    .ToTable("SRE_TIPO_NSS_T").PrimaryColumn("ID_TIPO_NSS");

                //Se necesita incluir el foreign_key a la tabla SRE_MUNICIPIO_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_MUNICIPIO")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("MUNICIPIO_ACTA")
                    .ToTable("SRE_MUNICIPIO_T").PrimaryColumn("ID_MUNICIPIO");

                //Se necesita incluir el foreign_key a la tabla SRE_NACIONALIDAD_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_NAC")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("ID_NACIONALIDAD")
                    .ToTable("SRE_NACIONALIDAD_T").PrimaryColumn("ID_NACIONALIDAD");

                //Se necesita incluir el foreign_key a la tabla SRE_TIPO_SANGRE_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_SANGRE")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumn("ID_TIPO_SANGRE")
                    .ToTable("SRE_TIPO_SANGRE_T").PrimaryColumn("ID_TIPO_SANGRE");

                //Se necesita incluir el foreign_key a la tabla SRE_PROVINCIAS_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_PROVINCIA")
                    .FromTable("SRE_CIUDADANOS_T").ForeignColumns("ID_PROVINCIA")
                    .ToTable("SRE_PROVINCIAS_T").PrimaryColumns("ID_PROVINCIA");

            }
        }

        public override void Down()
        {
            //if (Schema.Table("SRE_CIUDADANOS_T").Exists())
            //{
            //    Delete.Table("SRE_CIUDADANOS_T");                
            //}
        }
        
    }
}
