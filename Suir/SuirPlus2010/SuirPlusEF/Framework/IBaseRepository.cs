using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Framework
{
    public interface IBaseRepository<T>
    {
        T GetById(int id);
    }
}
