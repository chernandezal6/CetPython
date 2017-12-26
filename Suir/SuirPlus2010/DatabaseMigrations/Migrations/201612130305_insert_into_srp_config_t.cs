using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612130305)]
    public class _201612130305_insert_into_srp_config_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRP_CONFIG_T").Exists())
            {
                Insert.IntoTable("SRP_CONFIG_T").Row(new { ID_MODULO = "MSG_PAG_EX", FIELD1 = "<p class=msg>Puede pasar por una de las oficinas de Banreservas con su cédula a realizar el retiro de su balance.</p>", FIELD2 = "<p class=msg>Favor pasar por una de <a href =http://www.tss.gov.do/contact_frame.htm class=msg> nuestras oficinas</a> a recoger su balance.</p>", FIELD3 = "Reembolso correspondiente a la devolución de Diciembre 2016" });
            }
        }
        public override void Down()
        {
            if (Schema.Table("SRP_CONFIG_T").Exists())
            {
                Delete.FromTable("SRP_CONFIG_T").Row(new { ID_MODULO = "MSG_PAG_EX" });
            }
        }
    }
}
