using SuirPlusEF.Models;
using System;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Repositories
{

    public class CaptchaDetalleRepository : Framework.BaseObject<Models.DetalleCaptcha>, Framework.IBaseRepository<Models.DetalleCaptcha>
    {
        public CaptchaDetalleRepository() : base() { }
        public CaptchaDetalleRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        DetalleCaptcha IBaseRepository<DetalleCaptcha>.GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
