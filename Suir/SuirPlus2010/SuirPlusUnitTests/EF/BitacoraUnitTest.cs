using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class BitacoraUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdBitacora()
        {
            Bitacora bitacora = new Bitacora();
            BitacoraRepository _RepBit = new BitacoraRepository();

            bitacora = _RepBit.GetById(DefaultValues.IdBitacora);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {
            ProcesoRepository _RepProc = new ProcesoRepository();
            Proceso proceso = _RepProc.GetByIdProceso(DefaultValues.IdProceso);

            Bitacora bitacora = new Bitacora {IdBitacora = DefaultValues.IdBitacora, Proceso = proceso };

            string BitacoraMensaje = bitacora.Mensaje;
            //TODO: Kerlin, favor arreglar.
            //string DescripcionProceso = bitacora.Proceso.Descripcion;

           
        }
        
    }
}
