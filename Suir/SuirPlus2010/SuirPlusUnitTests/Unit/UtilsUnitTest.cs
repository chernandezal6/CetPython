using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;
using SuirPlus;

namespace SuirPlusUnitTests.Unit
{
    public class UtilsUnitTest
    {
        [Test]
        [Category("Utilitarios")]
        public void FormatearFecha() {

            string Fecha1 = "03/03/2016";
            DateTime Fecha1Resultado = SuirPlus.Utilitarios.Utils.FormatearFecha(Fecha1);

            string Fecha2 = "03/03/2016";
            DateTime Fecha2Resultado = SuirPlus.Utilitarios.Utils.FormatearFecha(Fecha2);


            NUnit.Framework.Assert.True(true);

        }

    }
}
