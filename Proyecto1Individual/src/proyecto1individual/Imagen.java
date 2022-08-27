/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package proyecto1individual;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

/**
 *
 * @author arman
 */
public class Imagen {
    
    public File image;
    public File txt;
    public int[][] pixels;
    
    public void pixelesImagen(String URL, int init_x, int init_y, int end_x, int end_y){
        
        image = new File(URL);
        
        BufferedImage buffImage = null;
        
        FileWriter fichero = null;
        PrintWriter pw = null;
     
        try {
            buffImage = ImageIO.read(image);
            
            BufferedImage ScaleImage = new BufferedImage(buffImage.getWidth(), buffImage.getHeight(), BufferedImage.TYPE_INT_RGB);
        
            pixels = new int[buffImage.getWidth()][buffImage.getHeight()];
            
             

            
            
            
            for(int i = 0; i <buffImage.getWidth();i++){
            for (int j = 0; j <buffImage.getHeight();j++){
                pixels[i][j] =  buffImage.getRGB( i, j );
            } 
        }
            txt = new File("C:\\Users\\arman\\Documents\\Segundo Semestre 2022\\Arqui\\Proyecto1Individual\\src\\proyecto1individual\\PixelesIMG.txt");
            //System.out.print(txt.getAbsolutePath());
            fichero = new FileWriter(txt);
            BufferedWriter bw = new BufferedWriter(new FileWriter(txt));
            bw.write("");
            bw.close();
            
            pw = new PrintWriter(fichero);
            
            for(int i = init_x; i < end_x;i++){
            for (int j = init_y; j < end_y;j++){
                int r = (pixels[i][j]>>16) & 0xff;
                pw.println(r);
            } 
        }
            fichero.close();
           
            //System.out.println(Arrays.deepToString(pixels));
        } catch (IOException ex) {
            Logger.getLogger(Imagen.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    
}
   
    }