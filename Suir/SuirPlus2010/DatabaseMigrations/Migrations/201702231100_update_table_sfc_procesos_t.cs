using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201702231100)]
    public class _201702231100_update_table_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Sql("update sfc_procesos_t set lista_ok = 'divisionadministraciondeincidentes@mail.tss2.gov.do,hector_mota@mail.tss2.gov.do,dba@mail.tss2.gov.do', lista_error = 'divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso = 'ER'");
        }

        public override void Down()
        {        
        }
    }
}
