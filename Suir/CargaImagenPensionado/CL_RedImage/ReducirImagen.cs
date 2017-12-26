using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
 
public class ReducirImagen
{

    public static void Reducir(FileInfo Arch, string DirCopiarPagina, string DirCopiarFinal)
    {

        try
        {
            //Bitmap ImgIn;

            Image FirstPage = null;
            Image SecondPage = null;
            Image ThirdPage = null;
            Image FourthPage = null;
            Image FifthPage = null;
            int redImage = 1;
            int numPage = 0;



            AMA.Util.TiffManager FM = new AMA.Util.TiffManager(Arch.FullName);
            numPage = FM.PageNumber;


            for (int i = 0; i < numPage; i++)
            {
                //SI TIENE 1 PAGINA
                if (i == 0)
                {
                    FirstPage = FM.GetSpecificPage(0);
                }

                //**********************************************************************************//
                //SI TIENE 2 PAGINAS
                if (i == 1)
                {
                    SecondPage = FM.GetSpecificPage(1);

                    //Comparando la primera imagen con la segunda.
                    redImage = FirstIsGreater(FirstPage.Size.Width, SecondPage.Size.Width) == true ? 1 : 2;

                }

                //**********************************************************************************//
                //SI TIENE 3 PAGINAS
                if (i == 2)
                {
                    ThirdPage = FM.GetSpecificPage(2);
                    if (redImage == 1)
                    {
                        //Comparando la primera imagen con la tercera.
                        redImage = FirstIsGreater(FirstPage.Size.Width, ThirdPage.Size.Width) == true ? 1 : 3;
                    }
                    else
                    {
                        //Comparando la segunda imagen con la tercera.
                        redImage = FirstIsGreater(SecondPage.Size.Width, ThirdPage.Size.Width) == true ? 2 : 3;
                    }
                }

                //**********************************************************************************//
                //SI TIENE 4 PAGINAS
                if (i == 3)
                {
                    FourthPage = FM.GetSpecificPage(3);

                    if (redImage == 1)
                    {
                        //Comparando la primera imagen con la Cuarta.
                        redImage = FirstIsGreater(FirstPage.Size.Width, FourthPage.Size.Width) == true ? 1 : 4;
                    }
                    else if (redImage == 2)
                    {
                        //Comparando la segunda imagen con la cuarta.
                        redImage = FirstIsGreater(SecondPage.Size.Width, FourthPage.Size.Width) == true ? 2 : 4;
                    }
                    else
                    {
                        //Comparando la tercera imagen con la cuarta.
                        redImage = FirstIsGreater(ThirdPage.Size.Width, FourthPage.Size.Width) == true ? 3 : 4;
                    }
                }


                //**********************************************************************************//
                //SI TIENE 5 PAGINAS
                if (i == 4)
                {
                    FifthPage = FM.GetSpecificPage(4);

                    if (redImage == 1)
                    {
                        //Comparando la primera imagen con la Quinta.
                        redImage = FirstIsGreater(FirstPage.Size.Width, FifthPage.Size.Width) == true ? 1 : 5;
                    }
                    else if (redImage == 2)
                    {
                        //Comparando la segunda imagen con la  Quinta.
                        redImage = FirstIsGreater(SecondPage.Size.Width, FifthPage.Size.Width) == true ? 2 : 5;
                    }
                    else if (redImage == 3)
                    {
                        //Comparando la tercera imagen con la  Quinta.
                        redImage = FirstIsGreater(ThirdPage.Size.Width, FifthPage.Size.Width) == true ? 3 : 5;
                    }
                    else
                    {
                        //Comparando la cuarta imagen con la  Quinta.
                        redImage = FirstIsGreater(FourthPage.Size.Width, FifthPage.Size.Width) == true ? 4 : 5;
                    }
                }
            }

            FM.Dispose();



            SaveImage(FirstPage, SecondPage, ThirdPage, FourthPage, FifthPage, redImage, Arch.Name, DirCopiarPagina, DirCopiarFinal);

            if (FirstPage != null)
            {
                FirstPage.Dispose();
            }

            if (SecondPage != null)
            {
                SecondPage.Dispose();
            }

            if (ThirdPage != null)
            {
                ThirdPage.Dispose();
            }

            if (FourthPage != null)
            {
                FourthPage.Dispose();
            }

            if (FifthPage != null)
            {
                FifthPage.Dispose();
            }


        }
        catch (Exception ex)
        {

            throw ex;
        }
        

    }

    private static Image ResizeImage(Image mg, Size newSize)
    {
        double ratio = 0d;
        double myThumbWidth = 0d;
        double myThumbHeight = 0d;
        int x = 0;
        int y = 0;



        Bitmap bp;

        if ((mg.Width / Convert.ToDouble(newSize.Width)) > (mg.Height / Convert.ToDouble(newSize.Height)))
            ratio = Convert.ToDouble(mg.Width) / Convert.ToDouble(newSize.Width);
        else
            ratio = Convert.ToDouble(mg.Height) / Convert.ToDouble(newSize.Height);
        myThumbHeight = Math.Ceiling(mg.Height / ratio);
        myThumbWidth = Math.Ceiling(mg.Width / ratio);


        Size thumbSize = new Size((int)myThumbWidth, (int)myThumbHeight);
        bp = new Bitmap(newSize.Width, newSize.Height);
        x = (newSize.Width - thumbSize.Width) / 2;
        y = (newSize.Height - thumbSize.Height);

        Graphics g = Graphics.FromImage(bp);
        g.SmoothingMode = SmoothingMode.HighQuality;
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
        g.PixelOffsetMode = PixelOffsetMode.HighQuality;
        Rectangle rect = new Rectangle(x, y, thumbSize.Width, thumbSize.Height);
        g.DrawImage(mg, rect, 0, 0, mg.Width, mg.Height, GraphicsUnit.Pixel);
        return bp;
    }

    private static bool FirstIsGreater(int Width1, int Width2)
    {

        if (Width1 > Width2)
        {
            return true;
        }
        else
        {
            return false;
        }

        return true;

    }

    private static void SaveImage(Image firstPage, Image secondPage, Image thirdPage, Image fourthPage, Image fifthPage, int redNo, string Name, string dirCopiarPagina, string dirCopiarFinal)
    {

        Size nSz;
        Image ImgOut = null;
        System.Collections.ArrayList Imagenes = new System.Collections.ArrayList();
        AMA.Util.TiffManager FMsmall = new AMA.Util.TiffManager();

        //Reduciendo las imagenes
        if (redNo == 1)
        {
            nSz = firstPage.Size;

            nSz.Height = Convert.ToInt32(nSz.Height / 1.5);
            nSz.Width = Convert.ToInt32(nSz.Width / 1.5);

            ImgOut = ResizeImage(firstPage, nSz);

            firstPage = ImgOut;

        }
        else if (redNo == 2)
        {
            nSz = secondPage.Size;

            nSz.Height = Convert.ToInt32(nSz.Height / 1.5);
            nSz.Width = Convert.ToInt32(nSz.Width / 1.5);

            ImgOut = ResizeImage(firstPage, nSz);

            secondPage = ImgOut;

        }
        else if (redNo == 3)
        {
            nSz = thirdPage.Size;

            nSz.Height = Convert.ToInt32(nSz.Height / 1.5);
            nSz.Width = Convert.ToInt32(nSz.Width / 1.5);

            ImgOut = ResizeImage(firstPage, nSz);

            thirdPage = ImgOut;

        }
        else if (redNo == 4)
        {
            nSz = fourthPage.Size;

            nSz.Height = Convert.ToInt32(nSz.Height / 1.5);
            nSz.Width = Convert.ToInt32(nSz.Width / 1.5);

            ImgOut = ResizeImage(firstPage, nSz);

            fourthPage = ImgOut;

        }
        else if (redNo == 5)
        {
            nSz = fifthPage.Size;

            nSz.Height = Convert.ToInt32(nSz.Height / 1.5);
            nSz.Width = Convert.ToInt32(nSz.Width / 1.5);

            ImgOut = ResizeImage(firstPage, nSz);

            fifthPage = ImgOut;

        }


        //Guardando las imagenes
        if (firstPage != null)
        {
            firstPage.Save(dirCopiarPagina + "1_" + Name);
            Imagenes.Add(dirCopiarPagina + "1_" + Name);
        }

        if (secondPage != null)
        {
            secondPage.Save(dirCopiarPagina + "2_" + Name);
            Imagenes.Add(dirCopiarPagina + "2_" + Name);
        }

        if (thirdPage != null)
        {
            thirdPage.Save(dirCopiarPagina + "3_" + Name);
            Imagenes.Add(dirCopiarPagina + "3_" + Name);
        }

        if (fourthPage != null)
        {
            fourthPage.Save(dirCopiarPagina + "4_" + Name);
            Imagenes.Add(dirCopiarPagina + "4_" + Name);
        }

        if (fifthPage != null)
        {
            fifthPage.Save(dirCopiarPagina + "5_" + Name);
            Imagenes.Add(dirCopiarPagina + "5_" + Name);
        }




        //Si existe el archivo que lo borre y cargue el nuevo

        if(System.IO.File.Exists(dirCopiarFinal + "\\" + Name))
        {
            System.IO.File.Delete(dirCopiarFinal + "\\" + Name);
        }
                           
        if (Imagenes.Count > 1)
        {          
                FMsmall.JoinTiffImages(Imagenes, dirCopiarFinal + "\\" + Name, System.Drawing.Imaging.EncoderValue.CompressionLZW);
                       
        }
        else
        {
            firstPage.Save(dirCopiarFinal + "\\" + Name);
        }



        ImgOut.Dispose();
        Imagenes.Clear();
        FMsmall = null;

    }
        
    
}

