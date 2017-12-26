using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    //Esta migración fue creada porque ya existe otra que inserta errores [Migration(201602120212)]
    //corrida anteriormente en produccion y viene en la tabla VERSIONINFO

    [Migration(201602120213)]
    public class _201602120213_insert_into_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "243", Error_Des = "ID Bitacora no existe.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "244", Error_Des = "Ya existe otra solicitud pendiente de procesar.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "245", Error_Des = "Numero de expediente no existe.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "246", Error_Des = "Este nro de expediente ya tiene un NSS asignado.", Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS001", Error_Des = "Ciudadano ya tiene un NSS asignado", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "246", Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS401", Error_Des = "Tipo de documento inválido", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "101", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS402", Error_Des = "Número de documento inválido", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "245", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS403", Error_Des = "Ya existe otra solicitud para el mismo ciudadano", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "244", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS404", Error_Des = "Pendiente de evaluación visual", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "439", Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS501", Error_Des = "Documento no existe en JCE", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "J01", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS502", Error_Des = "Ciudadano debe gestionar actualización datos en JCE", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "441", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS503", Error_Des = "Ciudadano NO existe en TSS", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "151", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS504", Error_Des = "Código de parentesco incorrecto", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "9", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS505", Error_Des = "NSS de titular inválido", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "4", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS506", Error_Des = "ARS incorrecta", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "43", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS507", Error_Des = "Nacionalidad incorrecta", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "44", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS508", Error_Des = "Sexo incorrecto", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "107", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS509", Error_Des = "Indicador de extranjero debe ser S o N", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "109", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS510", Error_Des = "Datos de acta deben estar en blanco si es extranjero", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "110", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS511", Error_Des = "Solicitud sin imagen", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "1602", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS512", Error_Des = "Datos de acta incompleto, incorrecto o con caracteres inválidos", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "418", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS513", Error_Des = "Municipio u Oficialía incorrectos", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "419", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS514", Error_Des = "Fecha de nacimiento incorrecta", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "108", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS515", Error_Des = "La conformación del nombre es incorrecto.", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "416", Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS901", Error_Des = "Imagen de documentación ilegible", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "1603", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS902", Error_Des = "Imagen de documentación incompleta de acuerdo a requerimientos de TSS", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "1603", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS903", Error_Des = "Documentación en imagen enviada no se corresponde con la solicitud", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "1613", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS904", Error_Des = "Ciudadano con NSS previamente asignado en el SUIR", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "429", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS905", Error_Des = "Datos del ciudadano con caracteres inválidos(*,%,@,#, etc.)", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "424", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS906", Error_Des = "Ciudadano ya es mayor de edad, debe obtener cédula", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "430", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS907", Error_Des = "Debe reenviar la solicitud vía NUI", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "435", Ult_Usuario_Act = "OPERACIONES" });
                Insert.IntoTable("SEG_ERROR_T").Row(new { Id_Error = "NSS908", Error_Des = "Imagen del titular no corresponde a la solicitud", Ult_Fecha_Act = DateTime.Now, Uso_Unipago = "437", Ult_Usuario_Act = "OPERACIONES" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Exists())
            {
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "243" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "244" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "245" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "246" });

                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS001" });

                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS401" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS402" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS403" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS404" });

                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS501" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS502" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS503" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS504" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS505" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS506" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS507" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS508" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS509" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS510" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS511" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS512" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS513" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS514" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS515" });

                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS901" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS902" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS903" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS904" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS905" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS906" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS907" });
                Delete.FromTable("SEG_ERROR_T").Row(new { Id_error = "NSS908" });
            }
        }
    }
}