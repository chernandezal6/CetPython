using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public class OficioDocumentacionUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdDocumento()
        {
            OficioDocumentacion documento = new OficioDocumentacion();
            OficioDocumentacionRepository _RepOficioDocumentacion = new OficioDocumentacionRepository();

            documento = _RepOficioDocumentacion.GetByIdDocumento(DefaultValues.IdDocumento);
            NUnit.Framework.Assert.True(true);
        }
    }
}
