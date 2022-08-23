/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package proyecto1individual;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
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
    
    public void pixelesImagen(){
        
        image = new File("C:\\Users\\arman\\Documents\\Abuela.jpg");
        
        BufferedImage buffImage = null;
     
        try {
            buffImage = ImageIO.read(image);
            
            BufferedImage ScaleImage = new BufferedImage(buffImage.getWidth(), buffImage.getHeight(), BufferedImage.TYPE_INT_RGB);
        
            int[][] pixels = new int[buffImage.getWidth()][buffImage.getHeight()];
            
             

            
            for(int i = 0; i <100;i++){
            for (int j = 0; j <100;j++){
                pixels[i][j] =  buffImage.getRGB( i, j );
                System.out.print(buffImage.getRGB( i, j )+" ");
            } 
        }
            //System.out.println(Arrays.deepToString(pixels));
        } catch (IOException ex) {
            Logger.getLogger(Imagen.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    
}
   
    }