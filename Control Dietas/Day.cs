﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Control_Dietas
{
    public class Day
    {
        public DateTime Date { get; set; }
        public bool Desayuno { get; set; }
        public bool Almuerzo { get; set; }
        public bool Cena { get; set; }
        public bool Alojamiento { get; set; }
        public double Cobrar { get; set; }
        public string LugarVisitado { get; set; }
    }
}
