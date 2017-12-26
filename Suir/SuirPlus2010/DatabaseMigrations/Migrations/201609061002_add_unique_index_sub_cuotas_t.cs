using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{

    [Migration(201609061002)]
    public class _201609061002_add_unique_index_sub_cuotas_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SUB_CUOTAS_T").Index("UK_SUB_CUOTAS").Exists())
            {
                Execute.Sql("ALTER TABLE SUIRPLUS.SUB_CUOTAS_T ADD CONSTRAINT UK_SUB_CUOTAS UNIQUE(TIPO_SUBSIDIO, NRO_SOLICITUD, NRO_PAGO, ID_REGISTRO_PATRONAL) DEFERRABLE NOVALIDATE");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SUB_CUOTAS_T").Index("UK_SUB_CUOTAS").Exists())
            {
                Execute.Sql("ALTER TABLE SUIRPLUS.SUB_CUOTAS_T DROP CONSTRAINT UK_SUB_CUOTAS");
            }
        }

    }
}
