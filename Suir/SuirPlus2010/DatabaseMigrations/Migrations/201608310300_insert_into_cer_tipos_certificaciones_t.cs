using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608310300)]
    public class _201608310300_insert_into_cer_tipos_certificaciones_t : FluentMigrator.Migration
    {        
        public override void Up()
        {
            if (Schema.Table("CER_TIPOS_CERTIFICACIONES_T").Exists())
            {
                Insert.IntoTable("CER_TIPOS_CERTIFICACIONES_T").Row(new { ID_TIPO_CERTIFICACION = "88", TIPO_CERTIFICACION_DES = "Certificación de NSS de extranjeros", STATUS = "A", ON_LINE = "N",ULT_FECHA_ACT = DateTime.Now, ULT_USUARIO_ACT = "OPERACIONES", NOMBRE_RESP_FIRMA = "Aleida Rodriguez", PUESTO_RESP_FIRMA = "Enc. División Empleadores Sector Privado", EMAIL= "", ENCABEZADO_1 = "Mediante la presente, la Tesorería de la Seguridad Social certifica que al (la) ciudadano(a) [NOMBRE TRABAJADOR] , de nacionalidad [NACIONALIDAD], con fecha de nacimiento [FECHA NACIMIENTO], se le han asignado el Número de Seguridad Social [NSS CIUDADANO] y el identificador  [CEDULA CIUDADANO], a los fines de que se proceda con su registro y afiliación en el Sistema Dominicano de Seguridad Social de acuerdo a la Ley 87-01 y sus normas complementarias vigentes.", ENCABEZADO_2 = "", PIE_DE_PAGINA = "Esta certificación tiene una vigencia de 30 días, a partir de la fecha y se expide <b><u>totalmente gratis sin costo alguno</u></b> a solicitud de la parte interesada.<br /><br />Dado en la ciudad de Santo Domingo, Republica Dominicana, [FECHA LITERAL]", DESCRIPCION = "Certificacion expedida a los extranjeros.", AUTOMATICA = "S" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("CER_TIPOS_CERTIFICACIONES_T").Exists())
            {
                Delete.FromTable("CER_TIPOS_CERTIFICACIONES_T").Row(new { ID_TIPO_CERTIFICACION = "88" });
                
            }
        }
    }
}
