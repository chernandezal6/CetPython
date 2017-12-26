using FluentMigrator;
using System;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704201107)]
    public class _201704201107_update_sfc_procesos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "update_sfc_procesos_t.sql");
            Execute.Sql("update suirplus.sfc_procesos_t  set lista_ok = '_divisionadministraciondeincidentes@mail.tss2.gov.do', lista_error = '_divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso in ('VC', 'VD', 'SS')");
            Execute.Sql("update suirplus.sfc_procesos_t set lista_ok = '_divisionadministraciondeincidentes@mail.tss2.gov.do,Hector_Mota@mail.tss2.gov.do, _dba@mail.tss2.gov.do', lista_error = '_divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso = 'AN'");
            Execute.Sql("update suirplus.sfc_procesos_t set lista_ok = '_divisionadministraciondeincidentes@mail.tss2.gov.do,Hector_Mota@mail.tss2.gov.do', lista_error = '_divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso = 'CN'");
            Execute.Sql("update suirplus.sfc_procesos_t set lista_ok = 'bolivar.fabian@sespas.gov.do, ivan.lora@sespas.gov.do, EEstevez@cerss.gov.do, _divisionadministraciondeincidentes@mail.tss2.gov.do', lista_error = '_divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso = '89'");
            Execute.Sql("update suirplus.sfc_procesos_t set lista_ok = 'bolivar.fabian@sespas.gov.do, ivan.lora@sespas.gov.do, EEstevez@cerss.gov.do, _divisionadministraciondeincidentes@mail.tss2.gov.do', lista_error = '_divisionadministraciondeincidentes@mail.tss2.gov.do' where id_proceso = 'AF'");
           
        }

        public override void Down()
        {
        }
    }
}
