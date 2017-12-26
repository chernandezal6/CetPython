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
    public class HistoricoDocumentoUnitTest
    {
        //[Test]
        //[Category("EntityFramework")]
        //public void GetByIdHisDocumento()
        //{
        //    HistoricoDocumento HistoricoDocumento = new HistoricoDocumento();
        //    HistoricoDocumentoRepository _RepHistoricoDocumento = new HistoricoDocumentoRepository();

        //    HistoricoDocumento = _RepHistoricoDocumento.GetByIdHistoricoDocumento(DefaultValues.IdHistoricoDocumento);
        //    int ? hisDocumentoNSS = HistoricoDocumento.IdNSS;

        //    NUnit.Framework.Assert.True(true);
        //}

        //[Test]
        //[Category("EntityFramework")]
        //public void ForeignKeys()
        //{
        //    CiudadanoRepository _RepCiudadano = new CiudadanoRepository();
        //    UsuarioRepository _RepUsuario = new UsuarioRepository(_RepCiudadano.db);
        //    Usuario usuario = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);
        //    Ciudadano ciudadano = _RepCiudadano.GetByNSS(DefaultValues.IdNSS);

        //    HistoricoDocumento HistoricoDocumento = new HistoricoDocumento { Id = DefaultValues.IdHistoricoDocumento, Ciudadano=ciudadano, Usuario=usuario};

        //    string username = HistoricoDocumento.Usuario.IdUsuario;
        //    Int32 nss = HistoricoDocumento.Ciudadano.IdNSS;

        //    NUnit.Framework.Assert.True(true);
        //}


    }
}
