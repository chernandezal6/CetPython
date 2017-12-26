using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603071146)]
    public class _201603071146_insert_into_sre_tipo_documentos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "C", Descripcion = "Cédula", ID_ENTIDAD =1, USO_CIUDADANO="S", VALIDACION_MAYORIA_EDAD = "N" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "P", Descripcion = "Pasaporte", ID_ENTIDAD = 2, USO_CIUDADANO = "N", VALIDACION_MAYORIA_EDAD = "N" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "U", Descripcion = "NUI", ID_ENTIDAD = 3, USO_CIUDADANO = "S", VALIDACION_MAYORIA_EDAD = "S" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "T", Descripcion = "Titulares por excepción", ID_ENTIDAD = 3, USO_CIUDADANO = "S", VALIDACION_MAYORIA_EDAD = "N" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "N", Descripcion = "NSS, menores sin número de documento", ID_ENTIDAD = 3, USO_CIUDADANO = "S", VALIDACION_MAYORIA_EDAD = "S" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "E", Descripcion = "Dependientes de extranjeros cotizantes", ID_ENTIDAD = 3, USO_CIUDADANO = "N", VALIDACION_MAYORIA_EDAD = "S" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "G", Descripcion = "Carné de Migración", ID_ENTIDAD = 3, USO_CIUDADANO = "N", VALIDACION_MAYORIA_EDAD = "N" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "I", Descripcion = "Documento emitido por Interior y Policía", ID_ENTIDAD = 4, USO_CIUDADANO = "N", MASCARA = "DO-99-999999", VALIDACION_MAYORIA_EDAD = "N" });
                Insert.IntoTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "V", Descripcion = "Visa de trabajo", ID_ENTIDAD = 5, USO_CIUDADANO = "N", VALIDACION_MAYORIA_EDAD = "N" });

            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "C" });
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "P"});
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "U"});
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "T"});
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "N"});
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new {Id_Tipo_DOCUMENTO = "E"});
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "G" });
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "I" });
                Delete.FromTable("SRE_TIPO_DOCUMENTOS_T").Row(new { Id_Tipo_DOCUMENTO = "V" });
            }
        }
    }
}
