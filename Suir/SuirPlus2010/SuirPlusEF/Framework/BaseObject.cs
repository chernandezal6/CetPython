using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Framework
{
    public abstract class BaseObject<T> where T : class
    {

        public SuirPlusEF.Framework.OracleDbContext db;
        public DbSet<T> DbSet;
        
        public BaseObject() {
            db = new OracleDbContext();
            DbSet = db.Set<T>();
            
        }

        public BaseObject(Framework.OracleDbContext db) {
            this.db = db;
            DbSet = db.Set<T>();
        }

        public virtual string Update(T entity)
        {
            db.SaveChanges();
            return "";
        }


        public T Add(T entity)
        {
            //Se castea entity a BaseModel, que es donde esta toda la logistica para obtener la secuencia correspondiente al objeto a insertar y 
            //se le asigna el valor de dicha secuencia a la columna id de la entidad.
            try
            {
                BaseModel bas = entity as BaseModel;
                bas.GetNextSequence();
                //********************************
                db = new OracleDbContext();
                DbSet = db.Set<T>();
                //********************************
                DbSet.Add(entity);
                SaveChanges();

                return entity;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error= " + ex.ToString());
                throw ex;
            }
        }
        //Este metodo es para insertar los casos donde no existe secuencia en el objeto
        public T AddNoSequence(T entity)
        {
            try {
                DbSet.Add(entity);
                SaveChanges();

                return entity;
            }
            catch (Exception ex) {
                Console.WriteLine("Error= " + ex.ToString());
                throw ex;
            }
        }

        public int SaveChanges()
        {
            return db.SaveChanges();
        }

        public virtual IQueryable<T> GetAll()
        {
            return db.Set<T>();
        }

    }
}
