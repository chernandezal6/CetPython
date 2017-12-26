using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708221036)]
    public class _201708221036_create_table_sfc_historico_deudores_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SFC_HISTORICO_DEUDORES_T").Exists())
            {
                Create.Table("SUIRPLUS.SFC_HISTORICO_DEUDORES_T")
                    .WithDescription("Tabla para almacenar el historico de empleadores deudores bajo ciertos parametros.")
                    .WithColumn("FECHA").AsDate().NotNullable().WithColumnDescription("Fecha registro.")
                    .WithColumn("ID_REGISTRO_PATRONAL").AsCustom("NUMBER(9)").NotNullable().WithColumnDescription("Registro patronal del empleador en cuestion.")
                    .WithColumn("PERIODOS_VENCIDOS").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("Cantidad de periodos vencidos del empleador.")
                    .WithColumn("NPS_VENCIDAS").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("Cantidad de Nps vencidas que posee el empleador")
                    .WithColumn("TOTAL_DEUDA").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Total adeudado por el empleador.");  
            }

        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SFC_HISTORICO_DEUDORES_T").Exists())
            {
               Delete.Table("SUIRPLUS.SFC_HISTORICO_DEUDORES_T");                  
            }

        }
    }
}
