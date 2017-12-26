using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class EvaluacionVisualUnitTest
    {
        // Este unittest esta comentado temporalmente, el sr. armando martinez esta a cargo. 
        //en esta prueba existe un foreignKey que hace referencia a la tabla nss_solicitudes_t pero la tabla nss_evaluacion_visual_t esta vacia y por esto falla el UnitTest.

        //[Test]
        //[Category("EntityFramework")]
        //public void GetByIdEvaluacion()
        //{
        //    EvaluacionVisual evaluacionvisual = new EvaluacionVisual();
        //    EvaluacionVisualRepository _RepEvaluacionVisual = new EvaluacionVisualRepository();

        //    //Hay que crear un valor real en DefaultValues
        //    evaluacionvisual = _RepEvaluacionVisual.GetByIdEvaluacion(DefaultValues.IdEvaluacionVisual);
        //    NUnit.Framework.Assert.True(true);
        //}

        //[Test]
        //[Category("EntityFramework")]
        //public void ForeignKeys()
        //{
        //    SolicitudNSSRepository _RepSolNSS = new SolicitudNSSRepository();
        //    SolicitudNSS SolNSS = _RepSolNSS.GetById(DefaultValues.IdSolicitudNSS);
            
        //    EvaluacionVisual evaluacionvisual = new EvaluacionVisual { Solicitud = SolNSS };

        //    int IdSolicitudnss = evaluacionvisual.Solicitud.IdSolicitud;
        //    NUnit.Framework.Assert.True(true);
        //}

    }
}
