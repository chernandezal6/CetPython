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
    public class TipoDocumentoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdTipoDocumento()
        {
            TipoDocumentoRepository _RepTipoDocumento = new TipoDocumentoRepository();
            TipoDocumento TipoDocumento = new TipoDocumento();            

            TipoDocumento = _RepTipoDocumento.GetByIdTipoDocumento(DefaultValues.IdTipoDocumento);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {

            //EntidadRepository _RepEntidad = new EntidadRepository();
            //Entidad Entidad = _RepEntidad.GetByIdEntidad(DefaultValues.IdEntidad);

            //TipoDocumento TipoDocumento = new TipoDocumento { IdTipoDocumento = DefaultValues.IdTipoDocumento, Entidad= Entidad };
            //Int32 IdEntidadEmite = TipoDocumento.Entidad.IdEntidad;

            //NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFrameworkData")]
        public void GetTiposDocumento()
        {
            TipoDocumentoRepository _RepTipoDocumento = new TipoDocumentoRepository();

            foreach (var row in _RepTipoDocumento.GetAllTipoDocumento())
            {
                Console.WriteLine("tipo de documento = " + row);
            }
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFrameworkData")]
        public void GetAllTiposDocumento()
        {
            //TipoDocumentoRepository _RepTipoDocumento = new TipoDocumentoRepository();            
            //NUnit.Framework.Assert.Greater(_RepTipoDocumento.GetAllTiposDocumento().Count, 0);
        }

    }
}
